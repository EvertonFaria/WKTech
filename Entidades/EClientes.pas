unit EClientes;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, System.Generics.Collections, FireDAC.Stan.Param, ETipos, Dialogs;

const
  MSG_INSERT_SUCESSO = 'Registro inserido com sucesso.';
  MSG_UPDATE_SUCESSO = 'Registro atualizado com sucesso.';
  MSG_DELETE_SUCESSO = 'Registro excluído com sucesso.';
  MSG_DB_ERROR = 'Erro ao acessar o banco de dados: ';
  MSG_RECORD_NOT_FOUND = 'Registro não encontrado.';
  MSG_NEW_ID = 'Código: ';

  TPB_CODIGO  = 0;
  TPB_NOME    = 1;
  TPB_CIDADE  = 2;
  TPB_UF      = 3;

type
  TCliente = class
  private
    FConnection: TFDConnection;
    FCLI_CDCLIENTE: TIntegerEx;
    FCLI_NMCLIENTE: TStringEx;
    FCLI_DSCIDADE: TStringEx;
    FCLI_DSUF: TStringEX;
    FCLI_DTCADASTRO: TDateEx;
    FCLI_USCADASTRO: TStringEx;
    FCLI_DTALTERACAO: TDateEX;
    FCLI_USALTERACAO: TStringEx;

  protected
    function GetCLI_CDCLIENTE: TIntegerEx;
    function GetCLI_NMCLIENTE: TStringEx;
    function GetCLI_DSCIDADE: TStringEx;
    function GetCLI_DSUF: TStringEx;
    function GetCLI_DTCADASTRO: TDateEX;
    function GetCLI_USCADASTRO: TStringEx;
    function GetCLI_DTALTERACAO: TDateEX;
    function GetCLI_USALTERACAO: TStringEx;

    procedure SetCLI_NMCLIENTE(const Value: TStringEx);
    procedure SetCLI_DSCIDADE(const Value: TStringEx);
    procedure SetCLI_DSUF(const Value: TStringEx);
    procedure SetCLI_USCADASTRO(const Value: TStringEx);
    procedure SetCLI_DTALTERACAO(const Value: TDateEX);
    procedure SetCLI_USALTERACAO(const Value: TStringEx);

    procedure CarredarDadosCampos;

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    property Codigo: TIntegerEx read GetCLI_CDCLIENTE;
    property Nome: TStringEx read GetCLI_NMCLIENTE write SetCLI_NMCLIENTE;
    property Cidade: TStringEx read GetCLI_DSCIDADE write SetCLI_DSCIDADE;
    property UF: TStringEx read GetCLI_DSUF write SetCLI_DSUF;
    property DataCadastro: TDateEX read GetCLI_DTCADASTRO;
    property UsuarioCadastro: TStringEx read GetCLI_USCADASTRO write SetCLI_USCADASTRO;
    property DataAlteracao: TDateEX read GetCLI_DTALTERACAO write SetCLI_DTALTERACAO;
    property UsuarioAlteracao: TStringEx read GetCLI_USALTERACAO write SetCLI_USALTERACAO;

    function InserirCliente: TList<string>;
    function AlterarCliente: TList<string>;
    function ExcluirCliente: TList<string>;
    function BuscarCliente(const pValue: string; pCampoBusca: Integer): TObjectList<TCliente>;
  end;

  TClienteList = TObjectList<TCliente>;

implementation

{ TCliente }

constructor TCliente.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;

  FCLI_CDCLIENTE    := TIntegerEx.Create;
  FCLI_NMCLIENTE    := TStringEX.Create;
  FCLI_DSCIDADE     := TStringEX.Create;
  FCLI_DSUF         := TStringEX.Create;
  FCLI_DTCADASTRO   := TDateEX.Create;
  FCLI_USCADASTRO   := TStringEX.Create;
  FCLI_DTALTERACAO  := TDateEX.Create;
  FCLI_USALTERACAO  := TStringEX.Create;

  CarredarDadosCampos;
end;

destructor TCliente.Destroy;
begin
  inherited;
end;

function TCliente.GetCLI_CDCLIENTE: TIntegerEx;
begin
  Result := FCLI_CDCLIENTE;
end;

function TCliente.GetCLI_NMCLIENTE: TStringEx;
begin
  Result := FCLI_NMCLIENTE;
end;

function TCliente.GetCLI_DSCIDADE: TStringEx;
begin
  Result := FCLI_DSCIDADE;
end;

function TCliente.GetCLI_DSUF: TStringEx;
begin
  Result := FCLI_DSUF;
end;

function TCliente.GetCLI_DTCADASTRO: TDateEX;
begin
  Result := FCLI_DTCADASTRO;
end;

function TCliente.GetCLI_USCADASTRO: TStringEx;
begin
  Result := FCLI_USCADASTRO;
end;

function TCliente.GetCLI_DTALTERACAO: TDateEX;
begin
  Result := FCLI_DTALTERACAO;
end;

function TCliente.GetCLI_USALTERACAO: TStringEx;
begin
  Result := FCLI_USALTERACAO;
end;

procedure TCliente.SetCLI_NMCLIENTE(const Value: TStringEx);
begin
  FCLI_NMCLIENTE.Valor := Value.Valor;
end;

procedure TCliente.SetCLI_DSCIDADE(const Value: TStringEx);
begin
  FCLI_DSCIDADE.Valor := Value.Valor;
end;

procedure TCliente.SetCLI_DSUF(const Value: TStringEx);
begin
  FCLI_DSUF.Valor := Value.Valor;
end;

procedure TCliente.SetCLI_USCADASTRO(const Value: TStringEx);
begin
  FCLI_USCADASTRO.Valor := Value.Valor;
end;

procedure TCliente.SetCLI_DTALTERACAO(const Value: TDateEX);
begin
  FCLI_DTALTERACAO.Valor := Value.Valor;
end;

procedure TCliente.SetCLI_USALTERACAO(const Value: TStringEx);
begin
  FCLI_USALTERACAO.Valor := Value.Valor;
end;

function TCliente.InserirCliente: TList<string>;
var
  vSequence: Integer;
  qConsulta: TFDQuery;
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qConsulta := TFDQuery.Create(nil);
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.ExecSQL('CALL GetNextSequenceValue(''CLIENTE_CLI_SEQ'', @next_val)');
    qConsulta.SQL.Add('SELECT @next_val');
    qConsulta.Open();
    vSequence := qConsulta.FieldByName('@next_val').AsInteger;

    FConnection.StartTransaction;

    qProcessa.Connection := FConnection;
    qProcessa.SQL.Add(
      'INSERT INTO CLIENTE_CLI (' + #10 + #13 +
      '  CLI_CDCLIENTE,'          + #10 + #13 +
      '  CLI_NMCLIENTE,'          + #10 + #13 +
      '  CLI_DSCIDADE,'           + #10 + #13 +
      '  CLI_DSUF'                + #10 + #13 +
      ') VALUES ('                + #10 + #13 +
      '  :CLI_CDCLIENTE,'         + #10 + #13 +
      '  :CLI_NMCLIENTE,'         + #10 + #13 +
      '  :CLI_DSCIDADE, '         + #10 + #13 +
      '  :CLI_DSUF)'
    );

    qProcessa.ParamByName('CLI_CDCLIENTE').AsInteger := vSequence;
    qProcessa.ParamByName('CLI_NMCLIENTE').AsString := FCLI_NMCLIENTE.Valor;
    qProcessa.ParamByName('CLI_DSCIDADE').AsString := FCLI_DSCIDADE.Valor;
    qProcessa.ParamByName('CLI_DSUF').AsString := FCLI_DSUF.Valor;

    try
      qProcessa.ExecSQL;
      FConnection.Commit;

      Messages.Add(MSG_INSERT_SUCESSO);
      Messages.Add(MSG_NEW_ID + IntToStr(vSequence));
    except
      on E: Exception do begin
        FConnection.Rollback;
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qConsulta.Free;
    qProcessa.Free;
  end;

  Result := Messages;
end;

function TCliente.AlterarCliente: TList<string>;
var
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction;

    qProcessa.Connection := FConnection;
    qProcessa.SQL.Add(
      'UPDATE CLIENTE_CLI SET'             + #10 + #13 +
      '  CLI_NMCLIENTE = :CLI_NMCLIENTE, ' + #10 + #13 +
      '  CLI_DSCIDADE = :CLI_DSCIDADE, '   + #10 + #13 +
      '  CLI_DSUF = :CLI_DSUF, '           + #10 + #13 +
      'WHERE CLI_CDCLIENTE = :CLI_CDCLIENTE'
    );

    qProcessa.ParamByName('CLI_CDCLIENTE').AsInteger := FCLI_CDCLIENTE.Valor;
    qProcessa.ParamByName('CLI_NMCLIENTE').AsString := FCLI_NMCLIENTE.Valor;
    qProcessa.ParamByName('CLI_DSCIDADE').AsString := FCLI_DSCIDADE.Valor;
    qProcessa.ParamByName('CLI_DSUF').AsString := FCLI_DSUF.Valor;

    try
      qProcessa.ExecSQL;
      if qProcessa.RowsAffected > 0 then
        Messages.Add(MSG_UPDATE_SUCESSO)
      else
        Messages.Add(MSG_RECORD_NOT_FOUND);

      FConnection.Commit;
    except
      on E: Exception do begin
        FConnection.Rollback;
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qProcessa.Free;
  end;

  Result := Messages;
end;

function TCliente.ExcluirCliente: TList<string>;
var
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction;

    qProcessa.Connection := FConnection;
    qProcessa.SQL.Add('DELETE FROM CLIENTE_CLI WHERE CLI_CDCLIENTE = :CLI_CDCLIENTE');
    qProcessa.ParamByName('CLI_CDCLIENTE').AsInteger := FCLI_CDCLIENTE.Valor;

    try
      qProcessa.ExecSQL;

      if qProcessa.RowsAffected > 0 then
        Messages.Add(MSG_DELETE_SUCESSO)
      else
        Messages.Add(MSG_RECORD_NOT_FOUND);

      FConnection.Commit;
    except
      on E: Exception do begin
        FConnection.Rollback;
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qProcessa.Free;
  end;

  Result := Messages;
end;

function TCliente.BuscarCliente(const pValue: string; pCampoBusca: Integer): TObjectList<TCliente>;
var
  qConsulta: TFDQuery;
  Cliente: TCliente;
  ClienteList: TObjectList<TCliente>;
begin
  ClienteList := TObjectList<TCliente>.Create;

  qConsulta := TFDQuery.Create(nil);
  qConsulta.Connection := FConnection;
  qConsulta.SQL.Add(
    'SELECT CLI_CDCLIENTE,    ' + #10 + #13 +
    '       CLI_NMCLIENTE,    ' + #10 + #13 +
    '       CLI_DSCIDADE,     ' + #10 + #13 +
    '       CLI_DSUF,         ' + #10 + #13 +
    '       CLI_DTCADASTRO,   ' + #10 + #13 +
    '       CLI_USCADASTRO,   ' + #10 + #13 +
    '       CLI_DTALTERACAO,  ' + #10 + #13 +
    '       CLI_USALTERACAO   ' + #10 + #13 +
    '  FROM CLIENTE_CLI'
  );

  case pCampoBusca of
    TPB_CODIGO: begin
      qConsulta.SQL.Add(' WHERE CLI_CDCLIENTE = :pCLI_CDCLIENTE');
      qConsulta.ParamByName('pCLI_CDCLIENTE').asInteger := StrToInt(pValue);
    end;

    TPB_NOME: begin
      qConsulta.SQL.Add(' WHERE CLI_NMCLIENTE LIKE :pCLI_NMCLIENTE');
      qConsulta.ParamByName('pCLI_NMCLIENTE').AsString := '%' + pValue + '%';
    end;

    TPB_CIDADE: begin
      qConsulta.SQL.Add(' WHERE CLI_DSCIDADE LIKE :pCLI_DSCIDADE');
      qConsulta.ParamByName('pCLI_DSCIDADE').AsString := '%' + pValue + '%';
    end;

    TPB_UF: begin
      qConsulta.SQL.Add(' WHERE CLI_DSUF LIKE :pCLI_DSUF');
      qConsulta.ParamByName('pCLI_DSUF').AsString := '%' + pValue + '%';
    end;
  end;

  try
    try
      qConsulta.Open;

      while not qConsulta.Eof do begin
        Cliente := TCliente.Create(FConnection);

        Cliente.FCLI_CDCLIENTE.Valor    := qConsulta.FieldByName('CLI_CDCLIENTE').AsInteger;
        Cliente.FCLI_NMCLIENTE.Valor    := qConsulta.FieldByName('CLI_NMCLIENTE').AsString;
        Cliente.FCLI_DSCIDADE.Valor     := qConsulta.FieldByName('CLI_DSCIDADE').AsString;
        Cliente.FCLI_DSUF.Valor         := qConsulta.FieldByName('CLI_DSUF').AsString;
        Cliente.FCLI_DTCADASTRO.Valor   := qConsulta.FieldByName('CLI_DTCADASTRO').AsDateTime;
        Cliente.FCLI_USCADASTRO.Valor   := qConsulta.FieldByName('CLI_USCADASTRO').AsString;
        Cliente.FCLI_DTALTERACAO.Valor  := qConsulta.FieldByName('CLI_DTALTERACAO').AsDateTime;
        Cliente.FCLI_USALTERACAO.Valor  := qConsulta.FieldByName('CLI_USALTERACAO').AsString;

        ClienteList.Add(Cliente);

        qConsulta.Next;
      end;
    except
      on E: Exception do
        ShowMessage('Ocorreu um erro ao executar a busca de clientes!');
    end;
  finally
    qConsulta.Free;
  end;

  Result := ClienteList;
end;

procedure TCliente.CarredarDadosCampos;
begin
  FCLI_CDCLIENTE.Load('Codigo', 'CLI_CDCLIENTE');
  FCLI_NMCLIENTE.Load('Nome', 'CLI_NMCLIENTE');
  FCLI_DSCIDADE.Load('Cidade', 'CLI_DSCIDADE');
  FCLI_DSUF.Load('Uf', 'CLI_DSUF');
  FCLI_DTCADASTRO.Load('Data de cadastro', 'CLI_DTCADASTRO');
  FCLI_USCADASTRO.Load('Usuario de cadastro', 'CLI_USCADASTRO');
  FCLI_DTALTERACAO.Load('Data de alteração', 'CLI_DTALTERACAO');
  FCLI_USALTERACAO.Load('Usuario de alteração', 'CLI_USALTERACAO');
end;

end.
