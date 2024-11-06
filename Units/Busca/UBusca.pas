unit UBusca;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, FireDAC.Comp.Client,
  System.Generics.Collections, FireDAC.Stan.Param, ETipos, EClientes, EProdutos, EPedido;

type
  TfrmBuscar = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    vTipoBusca: Integer;
    FComboBox: TComboBox;
    FEdit: TEdit;
    FButtonBuscar: TButton;
    FGrid: TDBGrid;
    FButtonOK: TButton;
    FButtonCancel: TButton;
    FDataSource: TDataSource;
    FQuery: TFDQuery;
    FSelectedValue: Variant;
    FConnection: TFDConnection;
    FCampos: TList<TStringEX>;
    procedure OnBuscarClick(Sender: TObject);
    procedure OnOKClick(Sender: TObject);
    procedure OnCancelClick(Sender: TObject);
  protected
    function GetTipoBusca: Integer;
    procedure SetTipoBusca(const Value: Integer);
  public
    property TipoBusca: Integer read GetTipoBusca write SetTipoBusca;
    constructor Create(AOwner: TComponent; AConnection: TFDConnection); reintroduce;
    constructor CreateCli(AOwner: TComponent; AConnection: TFDConnection; ACliente: TCliente);
    constructor CreatePro(AOwner: TComponent; AConnection: TFDConnection; AProduto: TProduto);
    constructor CreatePed(AOwner: TComponent; AConnection: TFDConnection; APedido: TPedido);
    destructor Destroy; override;
    function ExecuteSearch: Variant;
  end;

const
  cCLIENTE = 0;
  cPRODUTO = 1;
  cPEDIDO  = 2;

  BUSCAR_CLIENTE = 'Buscar cliente';
  BUSCAR_PEDIDO = 'Buscar pedido';
  BUSCAR_PRODUTO = 'Buscar produto';

var
  frmBuscar: TfrmBuscar;

implementation

{$R *.dfm}

constructor TfrmBuscar.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create(AOwner);

  // Configuração da conexão e query
  FConnection := AConnection;
  FQuery := TFDQuery.Create(Self);
  FQuery.Connection := FConnection;
  FDataSource := TDataSource.Create(Self);
  FDataSource.DataSet := FQuery;

  // Configuração do ComboBox
  FComboBox := TComboBox.Create(Self);
  FComboBox.Parent := Self;
  FComboBox.Style := csDropDownList;
  FComboBox.Left := 10;
  FComboBox.Top := 10;
  FComboBox.Width := 150;
  FComboBox.TabOrder := 0;

  // Configuração do Edit para busca
  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Left := FComboBox.Left + FComboBox.Width + 10;
  FEdit.Top := 10;
  FEdit.Width := 200;
  FEdit.TabOrder := 1;

  // Configuração do botão de buscar
  FButtonBuscar := TButton.Create(Self);
  FButtonBuscar.Parent := Self;
  FButtonBuscar.Left := FEdit.Left + FEdit.Width + 10;
  FButtonBuscar.Top := 10;
  FButtonBuscar.Caption := 'Buscar';
  FButtonBuscar.OnClick := OnBuscarClick;
  FButtonBuscar.TabOrder := 2;

  // Configuração do DBGrid
  FGrid := TDBGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Left := 10;
  FGrid.Top := FComboBox.Top + FComboBox.Height + 10;
  FGrid.Width := 480;
  FGrid.Height := 200;
  FGrid.DataSource := FDataSource;
  FGrid.TabOrder := 3;

  // Botão OK
  FButtonOK := TButton.Create(Self);
  FButtonOK.Parent := Self;
  FButtonOK.Left := 10;
  FButtonOK.Top := FGrid.Top + FGrid.Height + 10;
  FButtonOK.Caption := 'OK';
  FButtonOK.OnClick := OnOKClick;
  FButtonOK.TabOrder := 4;

  // Botão Cancelar
  FButtonCancel := TButton.Create(Self);
  FButtonCancel.Parent := Self;
  FButtonCancel.Left := FButtonOK.Left + FButtonOK.Width + 10;
  FButtonCancel.Top := FGrid.Top + FGrid.Height + 10;
  FButtonCancel.Caption := 'Cancelar';
  FButtonCancel.OnClick := OnCancelClick;
  FButtonCancel.TabOrder := 5;

  Self.ClientHeight := FButtonCancel.Top + FButtonCancel.Height + 10;
  Self.ClientWidth := FGrid.Width + 20;
end;

constructor TfrmBuscar.CreateCli(AOwner: TComponent; AConnection: TFDConnection; ACliente: TCliente);
begin
  Create(AOwner, AConnection);

  FCampos := TList<TStringEX>.Create;

  FCampos.Add(TStringEx.CriarComValor(ACliente.Codigo.Descricao, ACliente.Codigo.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(ACliente.Nome.Descricao, ACliente.Nome.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(ACliente.Cidade.Descricao, ACliente.Cidade.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(ACliente.UF.Descricao, ACliente.UF.Campo, string.Empty));

  FComboBox.Items.Add(ACliente.Codigo.Descricao);
  FComboBox.Items.Add(ACliente.Nome.Descricao);
  FComboBox.Items.Add(ACliente.Cidade.Descricao);
  FComboBox.Items.Add(ACliente.UF.Descricao);

  FComboBox.ItemIndex := 0;
end;

constructor TfrmBuscar.CreatePed(AOwner: TComponent; AConnection: TFDConnection; APedido: TPedido);
begin
  Create(AOwner, AConnection);

  FCampos := TList<TStringEX>.Create;

  FCampos.Add(TStringEx.CriarComValor(APedido.NumeroPedido.Descricao, APedido.NumeroPedido.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(APedido.CDCliente.Descricao, APedido.CDCliente.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(APedido.DataEmissao.Descricao, APedido.DataEmissao.Campo, string.Empty));

  FComboBox.Items.Add(APedido.NumeroPedido.Descricao);
  FComboBox.Items.Add(APedido.CDCliente.Descricao);
  FComboBox.Items.Add(APedido.DataEmissao.Descricao);

  FComboBox.ItemIndex := 0;
end;

constructor TfrmBuscar.CreatePro(AOwner: TComponent; AConnection: TFDConnection; AProduto: TProduto);
begin
  Create(AOwner, AConnection);

  FCampos := TList<TStringEX>.Create;

  FCampos.Add(TStringEx.CriarComValor(AProduto.Codigo.Descricao, AProduto.Codigo.Campo, string.Empty));
  FCampos.Add(TStringEx.CriarComValor(AProduto.Descricao.Descricao, AProduto.Descricao.Campo, string.Empty));

  FComboBox.Items.Add(AProduto.Codigo.Descricao);
  FComboBox.Items.Add(AProduto.Descricao.Descricao);

  FComboBox.ItemIndex := 0;
end;

destructor TfrmBuscar.Destroy;
begin
  FQuery.Free;
  FDataSource.Free;
  inherited;
end;

function TfrmBuscar.ExecuteSearch: Variant;
begin
  Result := Null;
  if Self.ShowModal = mrOk then
    Result := FSelectedValue;
end;

procedure TfrmBuscar.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  frmBuscar := nil;
end;

procedure TfrmBuscar.FormShow(Sender: TObject);
begin
  case vTipoBusca of
    cCLIENTE : begin
      Self.Caption := BUSCAR_CLIENTE;
    end;

    cPRODUTO : begin
      Self.Caption := BUSCAR_PRODUTO;
    end;

    cPEDIDO : begin
      Self.Caption := BUSCAR_PEDIDO;
    end;
  end;

  FEdit.SetFocus;
end;

function TfrmBuscar.GetTipoBusca;
begin
  Result := vTipoBusca;
end;

procedure TfrmBuscar.OnBuscarClick(Sender: TObject);
var
  Indice: Integer;
  vTabela: string;
  vColunas: string;
begin
  case vTipoBusca of
    cCLIENTE: vTabela := 'CLIENTE_CLI';
    cPRODUTO: vTabela := 'PRODUTO_PRO';
    cPEDIDO: vTabela := 'PEDIDO_PED';
  end;

  vColunas := string.Empty;

  for Indice := 0 to Fcampos.Count - 1 do
  begin
    vColunas := vColunas + FCampos[Indice].Campo + ' AS ' + FCampos[Indice].Descricao;
    if not (Indice = Fcampos.Count - 1) then
      vColunas := vColunas + ',' + #13 + #10;
  end;

  FQuery.Close;
  FQuery.SQL.Text := Format('SELECT %s FROM %s WHERE %s LIKE :SearchValue', [vColunas, vTabela, FCampos[FComboBox.ItemIndex].Campo]);
  FQuery.ParamByName('SearchValue').AsString := '%' + FEdit.Text + '%';

  try
    FQuery.Open;
  except
    on E: Exception do
      ShowMessage('Erro ao realizar busca: ' + E.Message);
  end;
end;

procedure TfrmBuscar.OnCancelClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TfrmBuscar.OnOKClick(Sender: TObject);
begin
  if not FQuery.IsEmpty then
    FSelectedValue := FQuery.Fields[0].Value;
  ModalResult := mrOk;
end;

procedure TfrmBuscar.SetTipoBusca(const Value: Integer);
begin
  vTipoBusca := Value;
end;

end.
