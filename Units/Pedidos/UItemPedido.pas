unit UItemPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Generics.Collections, EProdutos;

type
  TfrmIncluirItemPedido = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
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
    procedure edtCodProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure CarregarProduto();
  public
    { Public declarations }
  end;

var
  frmIncluirItemPedido: TfrmIncluirItemPedido;

implementation

uses
  UImagensEIcones, UBusca, UMenu;

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
        edtQuantidade.Text := '0';
        edtValorUnitario.Text := FloatToStr(FProduto.ValorUnitario.Valor);
        edtValorTotal.Text := '0';
      end;
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

procedure TfrmIncluirItemPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
  frmIncluirItemPedido := nil;
end;

end.
