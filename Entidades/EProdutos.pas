unit EProdutos;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, System.Generics.Collections, ETipos, FireDAC.Stan.Param, Data.DB;

const
  MSG_INSERT_SUCESSO = 'Produto inserido com sucesso.';
  MSG_UPDATE_SUCESSO = 'Produto alterado com sucesso.';
  MSG_DELETE_SUCESSO = 'Produto excluído com sucesso.';
  MSG_DB_ERROR = 'Erro no banco de dados: ';
  MSG_RECORD_NOT_FOUND = 'Produto não encontrado.';
  MSG_NEW_ID = 'Código: ';

  TPB_CDPRODUTO = 0;
  TPB_NMPRODUTO = 1;

type
  TProduto = class
  private
    FConnection: TFDConnection;
    FCDProduto: TIntegerEX;
    FNMProduto: TStringEX;
    FVLUnitario: TDoubleEX;
    FDTCadastro: TDateEX;
    FUSCadastro: TStringEX;
    FDTAlteracao: TDateEX;
    FUSAlteracao: TStringEX;

  protected
    procedure SetCDProduto(Value: TIntegerEX);
    procedure SetNMProduto(Value: TStringEX);
    procedure SetVLUnitario(Value: TDoubleEX);

    procedure CarredarDadosCampos;

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    property Codigo: TIntegerEX read FCDProduto write SetCDProduto;
    property Descricao: TStringEX read FNMProduto write SetNMProduto;
    property ValorUnitario: TDoubleEX read FVLUnitario write SetVLUnitario;
    property DataCadastro: TDateEX read FDTCadastro;
    property UsuarioCadastro: TStringEX read FUSCadastro write FUSCadastro;
    property DataAlteracao: TDateEX read FDTAlteracao;
    property UsuarioAlteracao: TStringEX read FUSAlteracao write FUSAlteracao;


    function InserirProduto: TList<string>;
    function AlterarProduto: TList<string>;
    function ExcluirProduto: TList<string>;
    function BuscarProduto(const pValue: string; pCampoBusca: Integer): TObjectList<TProduto>;
  end;

implementation

{ TProduto }

constructor TProduto.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;

  FCDProduto    := TIntegerEX.Create;
  FNMProduto    := TStringEX.Create;
  FVLUnitario   := TDoubleEX.Create;
  FDTCadastro   := TDateEX.Create;
  FUSCadastro   := TStringEX.Create;
  FDTAlteracao  := TDateEX.Create;
  FUSAlteracao  := TStringEX.Create;

  CarredarDadosCampos;
end;

destructor TProduto.Destroy;
begin

  inherited;
end;

procedure TProduto.SetCDProduto(Value: TIntegerEX);
begin
  FCDProduto := Value;
end;

procedure TProduto.SetNMProduto(Value: TStringEX);
begin
  FNMProduto := Value;
end;

procedure TProduto.SetVLUnitario(Value: TDoubleEX);
begin
  FVLUnitario := Value;
end;

function TProduto.InserirProduto: TList<string>;
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
    FConnection.ExecSQL('CALL GetNextSequenceValue(''PRODUTO_PRO_SEQ'', @next_val)');
    qConsulta.SQL.Add('SELECT @next_val');
    qConsulta.Open();
    vSequence := qConsulta.FieldByName('@next_val').AsInteger;

    FConnection.StartTransaction;

    qProcessa.Connection := FConnection;
    qProcessa.SQL.Add(
      'INSERT INTO PRODUTO_PRO (' + #13 + #10 +
      '  PRO_NMPRODUTO,         ' + #13 + #10 +
      '  PRO_VLUNITARIO,        ' + #13 + #10 +
      '  PRO_USCADASTRO         ' + #13 + #10 +
      ') VALUES (               ' + #13 + #10 +
      '  :NMProduto,            ' + #13 + #10 +
      '  :VLUnitario,           ' + #13 + #10 +
      '  :USCadastro)'
    );

    qProcessa.ParamByName('NMProduto').AsString := Descricao.Valor;
    qProcessa.ParamByName('VLUnitario').AsFloat := ValorUnitario.Valor;
    qProcessa.ParamByName('USCadastro').AsString := UsuarioCadastro.Valor;

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

function TProduto.AlterarProduto: TList<string>;
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
      'UPDATE PRODUTO_PRO SET ' + #13 + #10 +
      '  PRO_NMPRODUTO = :NMProduto, ' + #13 + #10 +
      '  PRO_VLUNITARIO = :VLUnitario, ' + #13 + #10 +
      '  PRO_USALTERACAO = :USAlteracao ' + #13 + #10 +
      ' WHERE PRO_CDPRODUTO = :CDProduto '
    );

    qProcessa.ParamByName('NMProduto').AsString   := Descricao.Valor;
    qProcessa.ParamByName('VLUnitario').AsFloat   := ValorUnitario.Valor;
    qProcessa.ParamByName('USAlteracao').AsString := UsuarioAlteracao.Valor;
    qProcessa.ParamByName('CDProduto').AsInteger  := Codigo.Valor;

    try
      qProcessa.ExecSQL;
      if ( qProcessa.RowsAffected > 0) then
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

function TProduto.ExcluirProduto: TList<string>;
var
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction;

    qProcessa.Connection := FConnection;
    qProcessa.SQL.Text := 'DELETE FROM PRODUTO_PRO WHERE PRO_CDPRODUTO = :CDProduto';
    qProcessa.ParamByName('CDProduto').AsInteger := Codigo.Valor;

    try
      qProcessa.ExecSQL;
      if ( qProcessa.RowsAffected > 0) then
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

function TProduto.BuscarProduto(const pValue: string; pCampoBusca: Integer): TObjectList<TProduto>;
var
  qConsulta: TFDQuery;
  Produto: TProduto;
  ProdutoList: TObjectList<TProduto>;
begin
  ProdutoList := TObjectList<TProduto>.Create;
  qConsulta := TFDQuery.Create(nil);

  try
    qConsulta.Connection := FConnection;
    qConsulta.SQL.Add(
      'SELECT PRO_CDPRODUTO,  ' + #10 + #13 +
      '       PRO_NMPRODUTO,  ' + #10 + #13 +
      '       PRO_VLUNITARIO, ' + #10 + #13 +
      '       PRO_DTCADASTRO, ' + #10 + #13 +
      '       PRO_USCADASTRO, ' + #10 + #13 +
      '       PRO_DTALTERACAO,' + #10 + #13 +
      '       PRO_USALTERACAO ' + #10 + #13 +
      '  FROM PRODUTO_PRO     ' + #10 + #13
    );

    case pCampoBusca of
      TPB_CDPRODUTO: begin
        qConsulta.SQL.Add('WHERE PRO_CDPRODUTO = :CDProduto');
        qConsulta.ParamByName('CDProduto').AsInteger := StrToInt(pValue);
      end;

      TPB_NMPRODUTO: begin
        qConsulta.SQL.Add('WHERE PRO_NMPRODUTO LIKE :NMProduto');
        qConsulta.ParamByName('NMProduto').AsString := '%' + pValue + '%';
      end;
    end;

    qConsulta.Open;

    if not qConsulta.IsEmpty then begin
      Produto := TProduto.Create(FConnection);

      Produto.FCDProduto.Valor    := qConsulta.FieldByName('PRO_CDPRODUTO').AsInteger;
      Produto.FNMProduto.Valor    := qConsulta.FieldByName('PRO_NMPRODUTO').AsString;
      Produto.FVLUnitario.Valor   := qConsulta.FieldByName('PRO_VLUNITARIO').AsCurrency;
      Produto.FDTCadastro.Valor   := qConsulta.FieldByName('PRO_DTCADASTRO').AsDateTime;
      Produto.FUSCadastro.Valor   := qConsulta.FieldByName('PRO_USCADASTRO').AsString;
      Produto.FDTAlteracao.Valor  := qConsulta.FieldByName('PRO_DTALTERACAO').AsDateTime;
      Produto.FUSAlteracao.Valor  := qConsulta.FieldByName('PRO_USALTERACAO').AsString;

      ProdutoList.Add(Produto);

      qConsulta.Next;
    end;

  finally
    qConsulta.Free;
  end;

  Result := ProdutoList;
end;

procedure TProduto.CarredarDadosCampos;
begin
  FCDProduto.Load('Codigo', 'PRO_CDPRODUTO');
  FNMProduto.Load('Descrição', 'PRO_NMPRODUTO');
  FVLUnitario.Load('Valor unitário', 'PRO_VLUNITARIO');
  FDTCadastro.Load('Data de cadastro', 'PRO_DTCADASTRO');
  FUSCadastro.Load('Usuário de cadastro', 'PRO_USCADASTRO');
  FDTAlteracao.Load('Data de alteração', 'PRO_DTALTERACAO');
  FUSAlteracao.Load('Usuário de alteração', 'PRO_USALTERACAO');
end;

end.

