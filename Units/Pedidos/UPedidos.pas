unit UPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, System.Generics.Collections,
  Vcl.Grids, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, EItemPedido, System.UITypes;

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
    edtTotalPedido: TEdit;
    lblTotalPedido: TLabel;
    lblOrientação: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure dtpEmissaoChange(Sender: TObject);
    procedure btnBuscaPedidoClick(Sender: TObject);
    procedure btnBuscaClienteClick(Sender: TObject);
    procedure edtPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnIncluirItemClick(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stgItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stgItensPedidoDblClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarAlterarClick(Sender: TObject);
    procedure edtPedidoExit(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
  private
    procedure LimparGrid();
    procedure LimpaUltimaLinhaGrid();
  protected
    procedure CarregarPedido();
    procedure CarregarDadosGrid(pItemPedido: TItemPedido);
    procedure CarregarGridNaTela();
    procedure CriarFormBusca(pTipoBusca: Integer);
    procedure ConfigurarGridItensPedido();
    procedure HabilitarTelaEdicao(pNovoPedido: Boolean);
    procedure LimparTela(pNovoPedido: Boolean);
    procedure CarregarDadosCliente(pFiltro: string);
    procedure EditarRegistro();
    procedure ExcluirRegistro(pLinha: Integer);
  public
    procedure CalcularTotalPedido();
  end;

const
  DATA_VAZIA = '  /  /    ';
  MSG_CONDIRMAR_EXCLUSAO = 'Deseja realmente remover o registro?';

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
  UMenu, UImagensEIcones, UBusca, EClientes, EPedido, EProdutos, UItemPedido, CustomMessageDialogBox;

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
        edtPedido.Text := VarToStr(SelectedID);
      end;
    finally
      frmBuscar.Free;
    end;
  end;

  if not string.IsNullOrEmpty(edtPedido.Text) then begin
    CarregarPedido();
  end;

  HabilitarTelaEdicao(string.IsNullOrEmpty(edtPedido.Text));
end;

procedure TfrmPedidoVenda.btnCancelarClick(Sender: TObject);
begin
  LimparTela(False);
end;

procedure TfrmPedidoVenda.btnExcluirClick(Sender: TObject);
var
  FPedido: TPedido;
  Messages: TList<string>;
begin
  if MessageDlg(MSG_CONDIRMAR_EXCLUSAO, mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    FPedido := TPedido.Create(frmMenu.fdcMySQLConnection);
    FPedido.NumeroPedido.Valor := StrToInt(edtPedido.Text);

    try
      Messages := TList<string>.Create;

      try
        FPedido.LoadPedido();
        Messages.AddRange(FPedido.ExcluirPedido());
        LimparTela(True);
      except
        on E: Exception do
          Messages.Add(MSG_DB_ERROR);
      end;
    finally
      FPedido.Free;
    end;

    TCustomMessageDialog.ShowDialog(Messages);
  end;
end;

procedure TfrmPedidoVenda.btnGravarAlterarClick(Sender: TObject);
var
  vLinha: Integer;
  FPedido: TPedido;
  Messages: TList<string>;
begin
  FPedido := TPedido.Create(frmMenu.fdcMySQLConnection);

  FPedido.DataEmissao.Valor := dtpEmissao.DateTime;
  if not string.IsNullOrEmpty(edtPedido.Text) then
    FPedido.NumeroPedido.Valor := StrToInt(edtPedido.Text);

  FPedido.CDCliente.Valor := StrToInt(edtCodigoCliente.Text);

  if (stgItensPedido.RowCount > stgItensPedido.FixedRows) and
     (not string.IsNullOrEmpty(stgItensPedido.Rows[stgItensPedido.RowCount - 2][colCDPRODUTO]))
  then begin
    for vLinha := stgItensPedido.FixedRows to Pred(stgItensPedido.RowCount - 1) do begin
      FPedido.AdicionarItem(
        TItemPedido.Create(
          vLinha,
          FPedido.NumeroPedido.Valor,
          StrToInt(stgItensPedido.Cells[colCDPRODUTO, vLinha]),
          StrToFloat(stgItensPedido.Cells[colQUANTIDADE, vLinha]),
          StrToCurr(StringReplace(stgItensPedido.Cells[colVALORUNITARIO, vLinha], FormatSettings.ThousandSeparator, '', [rfReplaceAll]))
        )
      );
    end;
  end;

  try
    Messages := TList<string>.Create;
    try
      if string.IsNullOrEmpty(edtPedido.Text) then
        Messages.AddRange(FPedido.InserirPedido())
      else
        Messages.AddRange(FPedido.AlterarPedido());

      LimparTela(True);
      edtPedido.Text := IntToStr(FPedido.NumeroPedido.Valor);
    except
      on E: Exception do
        Messages.Add(MSG_DB_ERROR);
    end;
  finally
    FPedido.Free;
  end;

  TCustomMessageDialog.ShowDialog(Messages);
end;

procedure TfrmPedidoVenda.btnIncluirItemClick(Sender: TObject);
begin
  if not Assigned(frmIncluirItemPedido) then
    frmIncluirItemPedido := TfrmIncluirItemPedido.Create(Application);

  frmIncluirItemPedido.Show;
end;

procedure TfrmPedidoVenda.btnRemoverItemClick(Sender: TObject);
begin
  if MessageDlg(MSG_CONDIRMAR_EXCLUSAO, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ExcluirRegistro(stgItensPedido.Row);
end;

procedure TfrmPedidoVenda.dtpEmissaoChange(Sender: TObject);
begin
  dtpEmissao.Format := FormatSettings.ShortDateFormat;
end;

procedure TfrmPedidoVenda.EditarRegistro;
begin
  if not string.IsNullOrEmpty(stgItensPedido.Rows[stgItensPedido.Row][colCDPRODUTO]) then begin
    if not Assigned(frmIncluirItemPedido) then
      frmIncluirItemPedido := TfrmIncluirItemPedido.Create(Application);

    CarregarGridNaTela();

    frmIncluirItemPedido.Editando := true;
    frmIncluirItemPedido.Linha := stgItensPedido.Row;

    frmIncluirItemPedido.Show;
  end;
end;

procedure TfrmPedidoVenda.edtCodigoClienteExit(Sender: TObject);
begin
  if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
    CarregarDadosCliente(edtCodigoCliente.Text);
  end;
end;

procedure TfrmPedidoVenda.edtCodigoClienteKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (key = VK_TAB) then begin
    if not string.IsNullOrEmpty(edtCodigoCliente.Text) then begin
      CarregarDadosCliente(edtCodigoCliente.Text);
    end;
  end;
end;

procedure TfrmPedidoVenda.edtPedidoExit(Sender: TObject);
begin
  if (not (string.IsNullOrEmpty(edtPedido.Text))) and (StrToInt(edtPedido.Text) > 0 ) then begin
    CarregarPedido;
    HabilitarTelaEdicao((edtPedido.Text = String.Empty));
  end;
end;

procedure TfrmPedidoVenda.edtPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key in [VK_RETURN, VK_TAB])  then begin
    if (not (string.IsNullOrEmpty(edtPedido.Text))) and (StrToInt(edtPedido.Text) >= 0 ) then begin
      CarregarPedido;
    end;

    HabilitarTelaEdicao((edtPedido.Text = String.Empty));
  end;
end;

procedure TfrmPedidoVenda.ExcluirRegistro(pLinha: Integer);
var
  Indice: Integer;
begin
  stgItensPedido.Row := pLinha;

  if (stgItensPedido.Row = stgItensPedido.RowCount - 1) then
    stgItensPedido.RowCount := stgItensPedido.RowCount - 1
  else begin
    for Indice := pLinha to stgItensPedido.RowCount - 1 do
      stgItensPedido.Rows[Indice] := stgItensPedido.Rows[Indice + 1];

    stgItensPedido.RowCount := stgItensPedido.RowCount - 1;
  end;

  CalcularTotalPedido();
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
  btnBuscaPedido.Enabled := False;
  dtpEmissao.Format := FormatSettings.ShortDateFormat;

  edtCodigoCliente.SetFocus;

  if pNovoPedido then begin
    btnExcluir.Enabled := false;
    dtpEmissao.DateTime := Now;
  end;
end;

procedure TfrmPedidoVenda.LimparTela(pNovoPedido: Boolean);
begin
  edtCodigoCliente.Text := string.Empty;
  edtNomeCliente.Text := string.Empty;
  edtCidadeCliente.Text := string.Empty;
  edtUFCliente.Text := string.Empty;
  edtTotalPedido.Text := string.Empty;
  dtpEmissao.Format := DATA_VAZIA;
  btnBuscaPedido.Enabled := true;

  LimparGrid();
  LimpaUltimaLinhaGrid();

  gbxDadosGerais.Enabled := false;
  gbxItensPedido.Enabled := false;
  pnlPersistir.Enabled := false;
  dtpEmissao.Enabled := false;
  edtPedido.Enabled := true;
  btnExcluir.Enabled := true;
  edtPedido.SetFocus;

  if not pNovoPedido then begin
    edtPedido.Text := String.Empty;
  end;
end;

procedure TfrmPedidoVenda.stgItensPedidoDblClick(Sender: TObject);
begin
  EditarRegistro();
end;

procedure TfrmPedidoVenda.stgItensPedidoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    EditarRegistro()
  else if Key = VK_DELETE then
    ExcluirRegistro(stgItensPedido.Row);
end;

procedure TfrmPedidoVenda.CalcularTotalPedido;
var
  Linha: Integer;
  vTotalPedido: Currency;
begin
  vTotalPedido := 0;
  for Linha := stgItensPedido.FixedRows to Pred(stgItensPedido.RowCount) do begin
    if not string.IsNullOrEmpty(stgItensPedido.Cells[colVALORTOTAL, Linha]) then
      vTotalPedido := vTotalPedido +
        StrToCurr(StringReplace(stgItensPedido.Cells[colVALORTOTAL, Linha], FormatSettings.ThousandSeparator, '', [rfReplaceAll]));
  end;

  edtTotalPedido.Text := FormatFloat('#,##0.00;-#,##0.00', vTotalPedido);
end;

procedure TfrmPedidoVenda.LimpaUltimaLinhaGrid();
begin
  stgItensPedido.Cells[colCDPRODUTO, stgItensPedido.RowCount - 1] := string.Empty;
  stgItensPedido.Cells[colPRODUTO, stgItensPedido.RowCount - 1] := string.Empty;
  stgItensPedido.Cells[colQUANTIDADE, stgItensPedido.RowCount - 1] := string.Empty;
  stgItensPedido.Cells[colVALORUNITARIO, stgItensPedido.RowCount - 1] := string.Empty;
  stgItensPedido.Cells[colVALORTOTAL, stgItensPedido.RowCount - 1] := string.Empty;
end;

procedure TfrmPedidoVenda.LimparGrid();
begin
  stgItensPedido.RowCount := stgItensPedido.RowCount + 1;

  stgItensPedido.Rows[stgItensPedido.FixedRows] := stgItensPedido.Rows[stgItensPedido.RowCount - 1];
  stgItensPedido.RowCount := stgItensPedido.FixedRows + 1;
end;

procedure TfrmPedidoVenda.CarregarGridNaTela;
begin
  frmIncluirItemPedido.edtCodProduto.Text := stgItensPedido.Rows[stgItensPedido.Row][colCDPRODUTO];
  frmIncluirItemPedido.edtDescricaoProduto.Text := stgItensPedido.Rows[stgItensPedido.Row][colPRODUTO];
  frmIncluirItemPedido.edtQuantidade.Text := stgItensPedido.Rows[stgItensPedido.Row][colQUANTIDADE];
  frmIncluirItemPedido.edtValorUnitario.Text := stgItensPedido.Rows[stgItensPedido.Row][colVALORUNITARIO];
  frmIncluirItemPedido.edtValorTotal.Text := stgItensPedido.Rows[stgItensPedido.Row][colVALORTOTAL];
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
    end
    else begin
      ShowMessage(EClientes.MSG_RECORD_NOT_FOUND);
      edtCodigoCliente.SetFocus;
    end;
  finally
    FCliente.Free;
  end;
end;

procedure TfrmPedidoVenda.CarregarDadosGrid(pItemPedido: TItemPedido);
var
  FProduto: Tproduto;
begin
  FProduto := TProduto.Create(frmMenu.fdcMySQLConnection);
  FProduto.Codigo.Valor := pItemPedido.CDProduto;
  FProduto.LoadProduto();

  stgItensPedido.Cells[colCDPRODUTO, stgItensPedido.RowCount - 1]     := IntToStr(pItemPedido.CDProduto);
  stgItensPedido.Cells[colPRODUTO, stgItensPedido.RowCount - 1]       := FProduto.Descricao.Valor;
  stgItensPedido.Cells[colQUANTIDADE, stgItensPedido.RowCount - 1]    := FloatToStr(pItemPedido.Quantidade);
  stgItensPedido.Cells[colVALORUNITARIO, stgItensPedido.RowCount - 1] := FormatCurr('#,##0.00;-#,##0.00', pItemPedido.VLUnitario);
  stgItensPedido.Cells[colVALORTOTAL, stgItensPedido.RowCount - 1]    := FormatCurr('#,##0.00;-#,##0.00', pItemPedido.VLTotal);

  stgItensPedido.RowCount := stgItensPedido.RowCount + 1;

  if Assigned(FProduto) then
    FProduto.Free;
end;

procedure TfrmPedidoVenda.CarregarPedido;
var
  FPedido: TPedido;
  FItemPedido: TItemPedido;
  LPedidoList: TList<TPedido>;
begin
  FPedido := TPedido.Create(frmMenu.fdcMySQLConnection);
  LPedidoList := TList<TPedido>.Create;

  try
    LPedidoList.AddRange(FPEdido.Create(frmMenu.fdcMySQLConnection).BuscarPedido(edtPedido.Text, 0));

    if (LPedidoList.Count > 0) then begin
      for FPedido in LPedidoList do begin
        edtPedido.Text := IntToStr(FPedido.NumeroPedido.Valor);
        dtpEmissao.DateTime := FPedido.DataEmissao.Valor;
        edtCodigoCliente.Text := IntToStr(FPedido.CDCliente.Valor);

        if (FPedido.Itens.Count > 0) then begin
          for FItemPedido in FPedido.Itens do begin
            CarregarDadosGrid(FItemPedido);
          end;
        end;

        LimpaUltimaLinhaGrid();
      end;
    end
    else begin
      ShowMessage(EClientes.MSG_RECORD_NOT_FOUND);
      edtPedido.Clear;
      edtPedido.SetFocus;
      Abort;
    end;

    if not (string.IsNullOrEmpty(edtCodigoCliente.Text)) then
      CarregarDadosCliente(edtCodigoCliente.Text);

    CalcularTotalPedido();
  finally
    FPedido.Free;
    LPedidoList.Free;
  end;
end;

end.
