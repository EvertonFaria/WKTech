unit UPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, System.Generics.Collections,
  Vcl.Grids, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TfrmPedidoVenda = class(TForm)
    pnlPedidoVenda: TPanel;
    gbxBuscaPedido: TGroupBox;
    lblPedido: TLabel;
    edtPedido: TEdit;
    btnBuscaPedido: TButton;
    gbxDadosGerais: TGroupBox;
    edtCodigoCliente: TEdit;
    edtNomeCliente: TEdit;
    edtCidadeCliente: TEdit;
    edtUFCliente: TEdit;
    lblCliente: TLabel;
    lblCidade: TLabel;
    lblUF: TLabel;
    lblDataEmissao: TLabel;
    btnBuscaCliente: TButton;
    gbxItensPedido: TGroupBox;
    dtpEmissao: TDateTimePicker;
    pnlPersistir: TPanel;
    btnGravarAlterar: TButton;
    btnExcluir: TButton;
    pnlIncluirAlterarRemoverItens: TPanel;
    btnIncluirItem: TButton;
    btnAlterarItem: TButton;
    btnRemoverItem: TButton;
    stgItensPedido: TStringGrid;
    btnCancelar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure dtpEmissaoChange(Sender: TObject);
    procedure btnBuscaPedidoClick(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure edtPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtPedidoExit(Sender: TObject);
    procedure btnIncluirItemClick(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    procedure CriarFormBusca(pTipoBusca: Integer);
    procedure ConfigurarGridItensPedido();
    procedure HabilitarTelaEdicao(pNovoPedido: Boolean);
    procedure LimparTela(pNovoPedido: Boolean);
    procedure CarregarDadosCliente(pFiltro: string);
    { Private declarations }
  public
    { Public declarations }
  end;

const
  DATA_VAZIA = '  /  /    ';

  cCLIENTE = 0;
  cPRODUTO = 1;
  cPEDIDO  = 2;

  colCDPRODUTO     = 0;
  colPRODUTO       = 1;
  colQUANTIDADE    = 2;
  colVALORUNITARIO = 3;
  colVALORTOTAL    = 4;

  cabCDPRODUTO     = 'Código';
  cabPRODUTO       = 'Produto';
  cabQUANTIDADE    = 'Quantidade';
  cabVALORUNITARIO = 'Vlr. unitário';
  cabVALORTOTAL    = 'Vlr. total';

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

uses
  UMenu, UImagensEIcones, UBusca, EClientes, EPedido, EProdutos, UItemPedido;

{$R *.dfm}

procedure TfrmPedidoVenda.btnBuscaClienteClick(Sender: TObject);
var
  SelectedID: Variant;
begin
  CriarFormBusca(cCLIENTE);

  if Assigned(frmBuscar) then begin
    try
      SelectedID := frmBuscar.ExecuteSearch;
      if not VarIsNull(SelectedID) then begin
        edtCodigoCliente.Text := VarToStr(SelectedID);
      end;
    finally
      frmBuscar.Free;
    end;
  end;

  if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
    CarregarDadosCliente(edtCodigoCliente.Text);
  end;
end;

procedure TfrmPedidoVenda.btnBuscaPedidoClick(Sender: TObject);
var
  SelectedID: Variant;
begin
  CriarFormBusca(cPEDIDO);

  if Assigned(frmBuscar) then begin
    try
      SelectedID := frmBuscar.ExecuteSearch;
      if not VarIsNull(SelectedID) then begin
        edtCodigoCliente.Text := VarToStr(SelectedID);
      end;
    finally
      frmBuscar.Free;
    end;
  end;

  if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
    CarregarDadosCliente(edtCodigoCliente.Text);
  end;
end;

procedure TfrmPedidoVenda.btnIncluirItemClick(Sender: TObject);
begin
  if not Assigned(frmIncluirItemPedido) then
    frmIncluirItemPedido := TfrmIncluirItemPedido.Create(Application);

  frmIncluirItemPedido.Show;
end;

procedure TfrmPedidoVenda.dtpEmissaoChange(Sender: TObject);
begin
  dtpEmissao.Format := FormatSettings.ShortDateFormat;
end;

procedure TfrmPedidoVenda.edtCodigoClienteExit(Sender: TObject);
begin
  if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
    CarregarDadosCliente(edtCodigoCliente.Text);
  end;
end;

procedure TfrmPedidoVenda.edtCodigoClienteKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (key = VK_TAB) then begin
    if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
      CarregarDadosCliente(edtCodigoCliente.Text);
    end;
  end;
end;

procedure TfrmPedidoVenda.edtPedidoExit(Sender: TObject);
begin
  HabilitarTelaEdicao((edtPedido.Text = String.Empty));
end;

procedure TfrmPedidoVenda.edtPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_TAB) then begin
    if (edtPedido.Text <> String.Empty) and (StrToInt(edtPedido.Text) > 0 ) then begin
      //TODO
    end;

    HabilitarTelaEdicao((edtPedido.Text = String.Empty));
  end;
end;

procedure TfrmPedidoVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not frmMenu.btnPedidos.Enabled then
    frmMenu.btnPedidos.Enabled := true;

  if Assigned(dtmImagensEIcones) then begin
    FreeAndNil(dtmImagensEIcones);
  end;

  Action := caFree;
  Release;
  frmPedidoVenda := nil;
end;

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
  dtpEmissao.Format := DATA_VAZIA;

  if not Assigned(dtmImagensEIcones) then
    dtmImagensEIcones := TdtmImagensEIcones.Create(Application);

  ConfigurarGridItensPedido();
end;

procedure TfrmPedidoVenda.CriarFormBusca(pTipoBusca: Integer);
var
  Cliente: TCliente;
  Produto: TProduto;
  Pedido: TPedido;
begin
  if not Assigned(frmBuscar) then begin
    case pTipoBusca of
      cCLIENTE: begin
        Cliente := TCliente.Create(frmMenu.fdcMySQLConnection);
        frmBuscar := TfrmBuscar.CreateCli(Application, frmMenu.fdcMySQLConnection, Cliente);

        if Assigned(Cliente) then
          Cliente.Free;
      end;

      cPRODUTO: begin
        Produto := TProduto.Create(frmMenu.fdcMySQLConnection);
        frmBuscar := TfrmBuscar.CreatePro(Application, frmMenu.fdcMySQLConnection, Produto);

        if Assigned(Produto) then
          Produto.Free;
      end;

      cPEDIDO: begin
        Pedido := TPedido.Create(frmMenu.fdcMySQLConnection);
        frmBuscar := TfrmBuscar.CreatePed(Application, frmMenu.fdcMySQLConnection, Pedido);

        if Assigned(Pedido) then
          Pedido.Free;
      end;
    end;

  end;

  frmBuscar.TipoBusca := pTipoBusca;
end;

procedure TfrmPedidoVenda.ConfigurarGridItensPedido();
begin
  with stgItensPedido do begin
    Cells[colCDPRODUTO, Pred(FixedRows)] := cabCDPRODUTO;
    Cells[colPRODUTO, Pred(FixedRows)] := cabPRODUTO;
    Cells[colQUANTIDADE, Pred(FixedRows)] := cabQUANTIDADE;
    Cells[colVALORUNITARIO, Pred(FixedRows)] := cabVALORUNITARIO;
    Cells[colVALORTOTAL, Pred(FixedRows)] := cabVALORTOTAL;
  end;
end;

procedure TfrmPedidoVenda.HabilitarTelaEdicao(pNovoPedido: Boolean);
begin
  gbxDadosGerais.Enabled := true;
  gbxItensPedido.Enabled := true;
  pnlPersistir.Enabled := true;
  dtpEmissao.Enabled := true;
  edtPedido.Enabled := false;
  btnBuscaPedido.Enabled := false;

  edtCodigoCliente.SetFocus;

  if pNovoPedido then begin
    btnExcluir.Enabled := false;
    dtpEmissao.Format := FormatSettings.ShortDateFormat;
  end;
end;

procedure TfrmPedidoVenda.LimparTela(pNovoPedido: Boolean);
begin
  gbxDadosGerais.Enabled := false;
  gbxItensPedido.Enabled := false;
  pnlPersistir.Enabled := false;
  dtpEmissao.Enabled := false;
  edtPedido.Enabled := true;
  dtpEmissao.Format := DATA_VAZIA;
  edtPedido.SetFocus;

  if not pNovoPedido then begin
    edtPedido.Text := String.Empty;
  end;
end;

procedure TfrmPedidoVenda.CarregarDadosCliente(pFiltro: string);
var
  FCliente: TCliente;
  FClienteList: System.Generics.Collections.TObjectList<TCliente>;
begin
  FCliente := TCliente.Create(frmMenu.fdcMySQLConnection);

  try
    FClienteList := TCliente.Create(frmMenu.fdcMySQLConnection).BuscarCliente(pFiltro, 0);

    if (FClienteList.Count > 0) then begin
      for FCliente in FClienteList do begin
        edtNomeCliente.Text := FCliente.Nome.Valor;
        edtCidadeCliente.Text := FCliente.Cidade.Valor;
        edtUFCliente.Text := FCliente.UF.Valor;
      end;
    end;
  finally
    FCliente.Free;
  end;
end;
end.
