unit CustomMessageDialogBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, UImagensEIcones,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, System.Generics.Collections,
  Vcl.Imaging.pngimage;

type
  TCustomMessageDialog = class(TForm)
    StringGrid: TStringGrid;
    pnlBotao: TPanel;
    PanelDetail: TPanel;
    btnOK: TButton;
    imgDialog: TImage;
    procedure FormCreate(Sender: TObject);
    procedure StringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure BtnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FMessageList: TList<string>;
    procedure PopulateGrid;
  public
    constructor Create(AOwner: TComponent; MessageList: TList<string>); reintroduce;
    class procedure ShowDialog(MessageList: TList<string>);
  end;

const
  STR_ESPACO_BRANCO = '    ';

implementation

{$R *.dfm}

constructor TCustomMessageDialog.Create(AOwner: TComponent; MessageList: TList<string>);
begin
  inherited Create(AOwner);
  FMessageList := MessageList;
  PopulateGrid;
end;

procedure TCustomMessageDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  Release;
end;

procedure TCustomMessageDialog.FormCreate(Sender: TObject);
begin
  // Configurações do StringGrid
  StringGrid.ColCount := 2;
  StringGrid.RowCount := 2;
  StringGrid.FixedRows := 1;
  StringGrid.Cells[0, 0] := 'Índice';
  StringGrid.Cells[1, 0] := 'Prévia da Mensagem';

  // Ajuste automático das colunas
  StringGrid.ColWidths[0] := 50;
  StringGrid.ColWidths[1] := 300;
end;

procedure TCustomMessageDialog.PopulateGrid;
var
  i: Integer;
begin
  StringGrid.RowCount := FMessageList.Count + 1;
  for i := 0 to FMessageList.Count - 1 do
  begin
    StringGrid.Cells[0, i + 1] := IntToStr(i + 1);
    StringGrid.Cells[1, i + 1] := Copy(FMessageList[i], 1, 250); // Mostra uma prévia da mensagem
  end;
end;

procedure TCustomMessageDialog.StringGridSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  // Exibe a mensagem completa no painel quando uma linha é selecionada
  if ARow > 0 then
    PanelDetail.Caption := STR_ESPACO_BRANCO + IntToStr(ARow) + ': ' + FMessageList[ARow - 1];
end;

procedure TCustomMessageDialog.BtnOKClick(Sender: TObject);
begin
  Close;
end;

class procedure TCustomMessageDialog.ShowDialog(MessageList: TList<string>);
var
  Dialog: TCustomMessageDialog;
begin
  Dialog := TCustomMessageDialog.Create(nil, MessageList);
  try
    Dialog.ShowModal;
  finally
    Dialog.Free;
  end;
end;

end.
