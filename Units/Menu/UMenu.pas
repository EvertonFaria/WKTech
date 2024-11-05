unit UMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, System.UITypes,
  Vcl.ComCtrls, Vcl.StdCtrls, IniFiles, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI, FireDAC.Phys.MySQL, Data.DB,
  FireDAC.Comp.Client, FireDAC.DApt, FireDAC.Stan.Param;

type
  TfrmMenu = class(TForm)
    mmnMenu: TMainMenu;
    mniCadastros: TMenuItem;
    mniProcessos: TMenuItem;
    mniUtilitarios: TMenuItem;
    mniSair: TMenuItem;
    mniClientes: TMenuItem;
    mniProdutos: TMenuItem;
    mniPedidos: TMenuItem;
    stbMenu: TStatusBar;
    mniParametrosGerais: TMenuItem;
    pnlAcessoRapido: TPanel;
    btnPedidos: TButton;
    fdcMySQLConnection: TFDConnection;
    dvrMySQLDriverLink: TFDPhysMySQLDriverLink;
    wcrMySQLWaytCursor: TFDGUIxWaitCursor;
    procedure mniSairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mniPedidosClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fdcMySQLConnectionAfterConnect(Sender: TObject);
  end;

  TFuncoesGerais = class
    protected
      class function LerArquivoConexao(pParamA: string; pParamB: string): string;
  end;

const
  ENCERRAR_PROGRAMA = 'Deseja sair da aplicação?';
  DEFINIR_VARIAVEL_USERNAME = 'SET @USERNAME = :username';

  ERRO_CONECTARDB = 'Falha ao conectar ao banco de dados! Erro: ';
  ERRO_DEFINIR_VARIAVEL = 'Ocorreu um erro ao definir variável de ambiente! Erro: ';

  LIBPATH = 'libs\libmysql.dll';
  CONFIGDBFILE = 'Config.ini';

  NULL_STRING = '';

var
  frmMenu: TFrmMenu;

implementation

uses
  UPedidos;

{$R *.dfm}

procedure TfrmMenu.fdcMySQLConnectionAfterConnect(Sender: TObject);
begin
  with fdcMySQLConnection do begin
    try
      ExecSQL(DEFINIR_VARIAVEL_USERNAME, [Params.UserName]);
    except
      on e: Exception do begin
        ShowMessage(ERRO_DEFINIR_VARIAVEL + e.Message);
      end;
    end;
  end;
end;

procedure TfrmMenu.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg(ENCERRAR_PROGRAMA, mtConfirmation, [mbYes,mbCancel], 0) = mrCancel then
    CanClose := false;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  try
    with dvrMySQLDriverLink do begin
      VendorLib := ExtractFilePath(Application.ExeName) + LIBPATH;
    end;

    with fdcMySQLConnection do begin
      Params.DriverID := 'MySQL';
      Params.Database := TFuncoesGerais.LerArquivoConexao('DATABASE', 'Banco');
      Params.UserName := TFuncoesGerais.LerArquivoConexao('DATABASE', 'Usuario');
      Params.Password := TFuncoesGerais.LerArquivoConexao('DATABASE', 'Senha');

      Params.Add('Server=' + TFuncoesGerais.LerArquivoConexao('DATABASE', 'Servidor'));

      Connected := true;
    end;

  except
    on e: Exception do begin
      ShowMessage(ERRO_CONECTARDB + e.Message);
    end;
  end;
end;

procedure TfrmMenu.mniPedidosClick(Sender: TObject);
var
  teste: string;
begin
  if not Assigned(frmPedidoVenda) then begin
    frmPedidoVenda := TfrmPedidoVenda.Create(Application);
    frmPedidoVenda.Show;
  end
  else begin
    frmPedidoVenda.WindowState := wsMaximized;
  end;

  if Sender = btnPedidos then
    btnPedidos.Enabled := false;

  teste := TFuncoesGerais.LerArquivoConexao('a','b');
end;

procedure TfrmMenu.mniSairClick(Sender: TObject);
begin
  Close;
end;

{ TFuncoesGerais }

class function TFuncoesGerais.LerArquivoConexao(pParamA: string; pParamB: string): string;
var
  vArquivo: string;
  vFileIni: TIniFile;
begin
  vArquivo := ExtractFilePath(Application.ExeName) + CONFIGDBFILE;
  Result := NULL_STRING;

  try
    vFileIni := TIniFile.Create(vArquivo);
    if FileExists(vArquivo) then
      Result := vFileIni.ReadString(pParamA, pParamB, NULL_STRING);
  finally
    FreeAndNil(vFileIni);
  end;
end;

end.
