unit UItemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Collections, EProdutos;

type
  TfrmIncluirItemPedido = class(TForm)
    pnlBotoes: TPanel;
    pnlCampos: TPanel;
    btnInserir: TButton;
    btnCancelar: TButton;
    edtCodProduto: TEdit;
    edtDescricaoProduto: TEdit;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    edtValorTotal: TEdit;
    lblProduto: TLabel;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    lblValorTotal: TLabel;
    btnBuscaProduto: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnBuscaProdutoClick(Sender: TObject);
    procedure edtCodProdutoExit(Sender: TObject);
    procedure edtCodProdutoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtValorTotalChange(Sender: TObject);
    procedure btnInserirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtValorUnitarioExit(Sender: TObject);
    procedure edtValorUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FEditando: Boolean;
    FLinha: Integer;
  protected
    procedure CarregarProduto();
    procedure CalcularTotal();
    procedure LimpaTela();
  public
    property Editando: Boolean write FEditando;
    property Linha: Integer write FLinha;
  end;

var
  frmIncluirItemPedido: TfrmIncluirItemPedido;

implementation

uses
  UImagensEIcones, UBusca, UMenu, UPedidos;

{$R *.dfm}

procedure TfrmIncluirItemPedido.btnBuscaProdutoClick(Sender: TObject);
var
  FProduto: TProduto;
  SelectedID: Integer;
begin
  FProduto := TProduto.Create(frmMenu.fdcMySQLConnection);
  frmBuscar := TfrmBuscar.CreatePro(Application, frmMenu.fdcMySQLConnection, FProduto);
  frmBuscar.TipoBusca := cPRODUTO;

  if Assigned(FProduto) then
    FProduto.Free;

  if Assigned(frmBuscar) then begin
    try
      SelectedID := frmBuscar.ExecuteSearch;
      if not VarIsNull(SelectedID) then begin
        edtCodProduto.Text := VarToStr(SelectedID);
      end;
    finally
      frmBuscar.Free;
    end;
  end;

  if not string.IsNullOrEmpty(edtCodProduto.Text) then begin
    CarregarProduto();
  end;
end;

procedure TfrmIncluirItemPedido.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmIncluirItemPedido.btnInserirClick(Sender: TObject);
var
  vLinha: Integer;
begin
  if not string.IsNullOrEmpty(edtCodProduto.Text) then begin
    if Assigned(frmPedidoVenda) then begin
      if FEditando then
        vLinha := FLinha
      else
        vLinha := frmPedidoVenda.stgItensPedido.RowCount - 1;

      frmPedidoVenda.stgItensPedido.Cells[colCDPRODUTO, vLinha] := edtCodProduto.Text;
      frmPedidoVenda.stgItensPedido.Cells[colPRODUTO, vLinha] := edtDescricaoProduto.Text;
      frmPedidoVenda.stgItensPedido.Cells[colQUANTIDADE, vLinha] := edtQuantidade.Text;
      frmPedidoVenda.stgItensPedido.Cells[colVALORUNITARIO, vLinha] := edtValorUnitario.Text;
      frmPedidoVenda.stgItensPedido.Cells[colVALORTOTAL, vLinha] := edtValorTotal.Text;

      if not string.IsNullOrEmpty(frmPedidoVenda.stgItensPedido.Rows[frmPedidoVenda.stgItensPedido.RowCount - 1][colCDPRODUTO]) then
        frmPedidoVenda.stgItensPedido.RowCount := frmPedidoVenda.stgItensPedido.RowCount + 1;

      frmPedidoVenda.CalcularTotalPedido();
    end;

    LimpaTela;
  end;
end;

procedure TfrmIncluirItemPedido.CalcularTotal;
var
  vValorTotal: Currency;
begin
  if not string.IsNullOrEmpty(edtValorUnitario.Text) then begin
    edtValorUnitario.Text := FormatFloat('#,##0.00;-#,##0.00', StrToCurr(edtValorUnitario.Text));

    vValorTotal := StrToCurr(edtValorUnitario.Text) * StrToFloat(edtQuantidade.Text);
    edtValorTotal.Text := FormatFloat('#,##0.00;-#,##0.00', vValorTotal);
  end;
end;

procedure TfrmIncluirItemPedido.CarregarProduto();
var
  FProduto: TProduto;
  LProdutoList: TList<TProduto>;
begin
    FProduto := TProduto.Create(frmMenu.fdcMySQLConnection);
    LProdutoList := FProduto.BuscarProduto(edtCodProduto.Text, TPB_CDPRODUTO);

    if (LProdutoList.Count > 0) then begin
      for FProduto in LProdutoList do begin
        edtDescricaoProduto.Text := FProduto.Descricao.Valor;

        if string.IsNullOrEmpty(edtQuantidade.Text) then
          edtQuantidade.Text := '0';

        if string.IsNullOrEmpty(edtValorUnitario.Text) then
          edtValorUnitario.Text := CurrToStr(FProduto.ValorUnitario.Valor);

        if string.IsNullOrEmpty(edtValorTotal.Text) then
          edtValorTotal.Text := '0,00';
      end;
    end
    else begin
      ShowMessage(EProdutos.MSG_RECORD_NOT_FOUND);
      edtCodProduto.SetFocus;
    end;
end;

procedure TfrmIncluirItemPedido.edtCodProdutoExit(Sender: TObject);
begin
  if not string.IsNullOrEmpty(edtCodProduto.Text) then
    CarregarProduto();
end;

procedure TfrmIncluirItemPedido.edtCodProdutoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_RETURN) or (Key = VK_TAB) then begin
    if not string.IsNullOrEmpty(edtCodProduto.Text) then
      CarregarProduto();
  end;
end;

procedure TfrmIncluirItemPedido.edtQuantidadeExit(Sender: TObject);
begin
  if string.IsNullOrEmpty(edtQuantidade.Text) then
    edtQuantidade.Text := '0';

  CalcularTotal();
end;

procedure TfrmIncluirItemPedido.edtValorTotalChange(Sender: TObject);
begin
  if not string.IsNullOrEmpty(edtValorTotal.Text) then
    edtValorTotal.Text := FormatFloat('#,##0.00;-#,##0.00', StrToCurr(StringReplace(edtValorTotal.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll])));
end;

procedure TfrmIncluirItemPedido.edtValorUnitarioExit(Sender: TObject);
begin
  if not string.IsNullOrEmpty(edtValorUnitario.Text) then
    edtValorUnitario.Text := FormatFloat('#,##0.00;-#,##0.00', StrToCurr(StringReplace(edtValorUnitario.Text, FormatSettings.ThousandSeparator, '', [rfReplaceAll])));

  CalcularTotal();
end;

procedure TfrmIncluirItemPedido.edtValorUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not CharInSet(Key,['0'..'9',#8,',']) then
    key := #0;
end;

procedure TfrmIncluirItemPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  frmIncluirItemPedido := nil;
end;

procedure TfrmIncluirItemPedido.FormCreate(Sender: TObject);
begin
  FEditando := false;
end;

procedure TfrmIncluirItemPedido.FormShow(Sender: TObject);
begin
  edtCodProduto.Enabled := not FEditando;
end;

procedure TfrmIncluirItemPedido.LimpaTela;
begin
  edtCodProduto.Clear;
  edtDescricaoProduto.Clear;
  edtQuantidade.Clear;
  edtValorUnitario.Clear;
  edtValorTotal.Clear;

  edtCodProduto.SetFocus;

  FEditando := False;
  edtCodProduto.Enabled := not FEditando;
end;

end.
