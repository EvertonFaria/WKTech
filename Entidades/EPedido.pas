unit EPedido;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, System.Generics.Collections, EProdutos, EClientes, EItemPedido,
  FireDAC.Stan.Param, Data.DB, Dialogs, ETipos;

const
  MSG_INSERT_SUCESSO = 'Pedido inserido com sucesso.';
  MSG_UPDATE_SUCESSO = 'Pedido alterado com sucesso.';
  MSG_DELETE_SUCESSO = 'Pedido excluído com sucesso.';
  MSG_DB_ERROR = 'Erro no banco de dados: ';
  MSG_RECORD_NOT_FOUND = 'Pedido não encontrado.';
  MSG_NEW_ID = 'Código: ';

  TPB_NRPEDIDO  = 0;
  TPB_CDCLIENTE = 1;
  TPB_DTEMISSAO = 2;
type
  TPedido = class
  private
    FConnection: TFDConnection;
    FNumeroPedido: TIntegerEX;
    FDataEmissao: TDateEX;
    FCDCliente: TIntegerEX;
    FValorTotal: TCurrencyEx;
    FItens: TObjectList<TItemPedido>;
    FUSCadastro: TStringEx;
    FDTCadastro: TDateEX;
    FUSAlteracao: TStringEx;
    FDTAlteracao: TDateEX;

  protected
    procedure CarregarDetalhesCampos();
    procedure SetCDCliente(Value: TIntegerEX);
    procedure AtualizarValorTotal();

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    property NumeroPedido: TIntegerEX read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateEX read FDataEmissao;
    property CDCliente: TIntegerEX read FCDCliente write SetCDCliente;
    property ValorTotal: TCurrencyEx read FValorTotal;
    property Itens: TObjectList<TItemPedido> read FItens;

    procedure AdicionarItem(AItem: TItemPedido);
    procedure RemoverItem(AItem: TItemPedido);
    procedure LoadPedido();

    function InserirPedido: TList<string>;
    function AlterarPedido: TList<string>;
    function ExcluirPedido: TList<string>;
    function BuscarPedido(const pValue: string; pCampoBusca: Integer): TObjectList<TPedido>;
  end;

implementation

{ TPedido }

procedure TPedido.CarregarDetalhesCampos;
begin
  FNumeroPedido.Load('Pedido', 'PED_NRPEDIDO');
  FDataEmissao.Load('Emissão', 'PED_DTEMISSAO');
  FCDCliente.Load('Cliente', 'CLI_CDCLIENTE');
  FValorTotal.Load('Valor total', 'PED_VLTOTAL');
  FUSCadastro.Load('Dt. cadastro', 'PED_DTCADASTRO');
  FDTCadastro.Load('Usuário de cadastro', 'PED_USCADASTRO');
  FUSAlteracao.Load('Dt. alteração', 'PED_DTALTERACAO');
  FDTAlteracao.Load('Usuário de alteração', 'PED_USALTERACAO');
end;

constructor TPedido.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;

  FNumeroPedido := TIntegerEX.Create;
  FDataEmissao  := TDateEX.Create;
  FCDCliente    := TIntegerEX.Create;
  FValorTotal   := TCurrencyEx.Create;
  FUSCadastro   := TStringEx.Create;
  FDTCadastro   := TDateEX.Create;
  FUSAlteracao  := TStringEx.Create;
  FDTAlteracao  := TDateEX.Create;

  FItens        := TObjectList<TItemPedido>.Create;

  FValorTotal.Valor := 0;
  CarregarDetalhesCampos();
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

procedure TPedido.SetCDCliente(Value: TIntegerEX);
begin
  FCDCliente := Value;
end;

procedure TPedido.AdicionarItem(AItem: TItemPedido);
begin
  FItens.Add(AItem);
  AtualizarValorTotal;
end;

procedure TPedido.RemoverItem(AItem: TItemPedido);
begin
  if FItens.Remove(AItem) >= 0 then
    AtualizarValorTotal;
end;

procedure TPedido.AtualizarValorTotal;
var
  Item: TItemPedido;
begin
  FValorTotal.Valor := 0; // Reinicia o valor total
  for Item in FItens do
    FValorTotal.Valor := FValorTotal.Valor + Item.VLTotal; // Soma os valores totais dos itens
end;

function TPedido.InserirPedido: TList<string>;
var
  vItem: TItemPedido;
  qProcessa: TFDQuery;
  qConsulta: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qConsulta := TFDQuery.Create(nil);
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction; // Inicia a transação

    try
      FConnection.ExecSQL('CALL GetNextSequenceValue(''PEDIDO_PED_SEQ'', @next_val)');
      qConsulta.Connection := FConnection;
      qConsulta.SQL.Add('SELECT @next_val');
      qConsulta.Open();
      FNumeroPedido.Valor := qConsulta.FieldByName('@next_val').AsInteger;

      qProcessa.Connection := FConnection;
      qProcessa.SQL.Add(
        'INSERT INTO PEDIDO_PED ( ' + #13 + #10 +
        '  PED_NRPEDIDO, '          + #13 + #10 +
        '  PED_DTEMISSAO, '         + #13 + #10 +
        '  CLI_CDCLIENTE, '         + #13 + #10 +
        '  PED_VLTOTAL '            + #13 + #10 +
        ') VALUES ( '               + #13 + #10 +
        '  :NrPedido, '             + #13 + #10 +
        '  :DataEmissao, '          + #13 + #10 +
        '  :CDCliente, '            + #13 + #10 +
        '  :ValorTotal)'
      );

      qProcessa.ParamByName('NrPedido').AsInteger := FNumeroPedido.Valor;
      qProcessa.ParamByName('DataEmissao').AsDateTime := DataEmissao.Valor;
      qProcessa.ParamByName('CDCliente').AsInteger := CDCliente.Valor;
      qProcessa.ParamByName('ValorTotal').AsFloat := ValorTotal.Valor;

      qProcessa.ExecSQL;

      // Adiciona os itens do pedido
      for vItem in Itens do begin
        qProcessa.SQL.Clear;
        qProcessa.SQL.Add(
          'INSERT INTO ITEMPEDIDO_ITE ( ' + #13 + #10 +
          '  ITE_SEQ, '                   + #13 + #10 +
          '  PED_NRPEDIDO, '              + #13 + #10 +
          '  PRO_CDPRODUTO, '             + #13 + #10 +
          '  ITE_QTDE, '                  + #13 + #10 +
          '  ITE_VLUNITARIO'              + #13 + #10 +
          ') VALUES ( '                   + #13 + #10 +
          '  :Sequencial, '               + #13 + #10 +
          '  :NumeroPedido, '             + #13 + #10 +
          '  :CDProduto, '                + #13 + #10 +
          '  :Quantidade, '               + #13 + #10 +
          '  :VLUnitario)'
        );

        qProcessa.ParamByName('Sequencial').AsInteger := vItem.Sequencial;
        qProcessa.ParamByName('NumeroPedido').AsInteger := FNumeroPedido.Valor; // Use o número do pedido gerado
        qProcessa.ParamByName('CDProduto').AsInteger := vItem.CDProduto;
        qProcessa.ParamByName('Quantidade').AsFloat := vItem.Quantidade;
        qProcessa.ParamByName('VLUnitario').AsFloat := vItem.VLUnitario;

        qProcessa.ExecSQL;
      end;

      FConnection.Commit; // Commit na transação
      Messages.Add(MSG_INSERT_SUCESSO);
      Messages.Add(MSG_NEW_ID + IntToStr(FNumeroPedido.Valor));
    except
      on E: Exception do begin
        FConnection.Rollback; // Reverte a transação em caso de erro
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qProcessa.Free;
    qConsulta.Free;
  end;

  Result := Messages;
end;

procedure TPedido.LoadPedido;
var
  qConsulta: TFDQuery;
begin
  qConsulta := TFDQuery.Create(nil);
  qConsulta.Connection := FConnection;
  qConsulta.SQL.Add(
    'SELECT PED_NRPEDIDO, ' + #13 + #10 +
    '       PED_DTEMISSAO, ' + #13 + #10 +
    '       CLI_CDCLIENTE,' + #13 + #10 +
    '       PED_VLTOTAL,' + #13 + #10 +
    '       PED_USCADASTRO,' + #13 + #10 +
    '       PED_DTCADASTRO,' + #13 + #10 +
    '       PED_USALTERACAO,' + #13 + #10 +
    '       PED_DTALTERACAO ' + #13 + #10 +
    '  FROM PEDIDO_PED ' + #13 + #10 +
    ' WHERE 1 = 1 '
  );

  if FNumeroPedido.Valor > 0 then begin
    qConsulta.SQL.Add(' AND PED_NRPEDIDO = :NrPedido');
    qConsulta.ParamByName('NrPedido').AsInteger := FNumeroPedido.Valor;
  end;

  if FCDCliente.Valor > 0 then begin
    qConsulta.SQL.Add(' AND CLI_CDCLIENTE = :CdCliente');
    qConsulta.ParamByName('CdCliente').AsInteger := FCDCliente.Valor;
  end;

  if FDataEmissao.Valor > 0 then begin
    qConsulta.SQL.Add(' AND PED_DTEMISSAO = :DtEmissao');
    qConsulta.ParamByName('DtEmissao').AsDateTime := FDataEmissao.Valor;
  end;


  try
    try
      qConsulta.Open;

      while not qConsulta.EoF do begin

        FNumeroPedido.Valor := qConsulta.FieldByName('PED_NRPEDIDO').AsInteger;
        FDataEmissao.Valor := qConsulta.FieldByName('PED_DTEMISSAO').AsDateTime;
        FCDCliente.Valor := qConsulta.FieldByName('CLI_CDCLIENTE').AsInteger;
        FValorTotal.Valor := qConsulta.FieldByName('PED_VLTOTAL').AsCurrency;
        FUSCadastro.Valor := qConsulta.FieldByName('PED_USCADASTRO').AsString;
        FDTCadastro.Valor := qConsulta.FieldByName('PED_DTCADASTRO').AsDateTime;
        FUSAlteracao.Valor := qConsulta.FieldByName('PED_USALTERACAO').AsString;
        FDTAlteracao.Valor := qConsulta.FieldByName('PED_DTALTERACAO').AsDateTime;



        if FNumeroPedido.Valor > 0 then begin
          qConsulta.SQL.Clear;
          qConsulta.SQL.Add(
            'SELECT ITE_SEQ, '        + #13 + #10 +
            '       PED_NRPEDIDO, '   + #13 + #10 +
            '       PRO_CDPRODUTO, '  + #13 + #10 +
            '       ITE_QTDE, '       + #13 + #10 +
            '       ITE_VLUNITARIO, ' + #13 + #10 +
            '       ITE_VLTOTAL '     + #13 + #10 +
            '  FROM ITEMPEDIDO_ITE '  + #13 + #10 +
            ' WHERE PED_NRPEDIDO = :NrPedido '
          );
          qConsulta.ParamByName('NrPedido').AsInteger := FNumeroPedido.Valor;

          with qConsulta do begin
            Open;
            while not Eof do begin
              AdicionarItem(TItemPedido.Create(
                FieldByName('ITE_SEQ').AsInteger,
                FieldByName('PED_NRPEDIDO').AsInteger,
                FieldByName('PRO_CDPRODUTO').AsInteger,
                FieldByName('ITE_QTDE').AsFloat,
                FieldByName('ITE_VLUNITARIO').AsCurrency
              ));

              Next;
            end;
          end;
        end;
      end;
    except
      on E: Exception do
        ShowMessage(MSG_DB_ERROR + E.Message);
    end;
  finally
    qConsulta.Free;
  end;
end;

function TPedido.AlterarPedido: TList<string>;
var
  vItem: TItemPedido;
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction; // Inicia a transação

    try
      qProcessa.Connection := FConnection;

      // Primeiro, exclui os itens antigos
      qProcessa.SQL.Add('DELETE FROM ITEMPEDIDO_ITE WHERE PED_NRPEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido.Valor;
      qProcessa.ExecSQL;

      // Atualiza o pedido
      qProcessa.SQL.Clear;
      qProcessa.SQL.Add(
        'UPDATE PEDIDO_PED SET '        + #13 + #10 +
        '  CLI_CDCLIENTE = :Cliente, '   + #13 + #10 +
        '  PED_VLTOTAL = :ValorTotal '  + #13 + #10 +
        ' WHERE PED_NRPEDIDO = :NumeroPedido '
      );

      qProcessa.ParamByName('Cliente').AsInteger := CDCliente.Valor;
      qProcessa.ParamByName('ValorTotal').AsFloat := ValorTotal.Valor;
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido.Valor;
      qProcessa.ExecSQL;

      if ( qProcessa.RowsAffected > 0) then begin
        // Adiciona os novos itens do pedido
        for vItem in Itens do begin
          qProcessa.SQL.Clear;
          qProcessa.SQL.Add(
            'INSERT INTO ITEMPEDIDO_ITE ( ' + #13 + #10 +
            '  ITE_SEQ, '                   + #13 + #10 +
            '  PED_NRPEDIDO, '              + #13 + #10 +
            '  PRO_CDPRODUTO, '             + #13 + #10 +
            '  ITE_QTDE, '                  + #13 + #10 +
            '  ITE_VLUNITARIO'              + #13 + #10 +
            ') VALUES ( '                   + #13 + #10 +
            '  :Sequencial, '               + #13 + #10 +
            '  :NumeroPedido, '             + #13 + #10 +
            '  :CDProduto, '                + #13 + #10 +
            '  :Quantidade, '               + #13 + #10 +
            '  :VLUnitario)'
          );

          qProcessa.ParamByName('Sequencial').AsInteger := vItem.Sequencial;
          qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido.Valor;
          qProcessa.ParamByName('CDProduto').AsInteger := vItem.CDProduto;
          qProcessa.ParamByName('Quantidade').AsFloat := vItem.Quantidade;
          qProcessa.ParamByName('VLUnitario').AsFloat := vItem.VLUnitario;

          qProcessa.ExecSQL;
        end;

        FConnection.Commit; // Commit na transação
        Messages.Add(MSG_UPDATE_SUCESSO);
      end
      else
        Messages.Add(MSG_RECORD_NOT_FOUND);
    except
      on E: Exception do begin
        FConnection.Rollback; // Reverte a transação em caso de erro
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qProcessa.Free;
  end;

  Result := Messages;
end;

function TPedido.ExcluirPedido: TList<string>;
var
  qProcessa: TFDQuery;
  Messages: TList<string>;
begin
  Messages := TList<string>.Create;
  qProcessa := TFDQuery.Create(nil);

  try
    FConnection.StartTransaction; // Inicia a transação

    try
      qProcessa.Connection := FConnection;

      // Exclui os itens do pedido
      qProcessa.SQL.Add('DELETE FROM ITEMPEDIDO_ITE WHERE PED_NRPEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido.Valor;
      qProcessa.ExecSQL;

      qProcessa.SQL.Clear;

      qProcessa.SQL.Add('DELETE FROM PEDIDO_PED WHERE PED_NRPEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido.Valor;
      qProcessa.ExecSQL;

      if not (qProcessa.RowsAffected > 0) then
        Messages.Add(MSG_RECORD_NOT_FOUND);

      FConnection.Commit; // Commit na transação
      Messages.Add(MSG_DELETE_SUCESSO);

    except
      on E: Exception do begin
        FConnection.Rollback; // Reverte a transação em caso de erro
        Messages.Add(MSG_DB_ERROR + E.Message);
      end;
    end;
  finally
    qProcessa.Free;
  end;

  Result := Messages;
end;

function TPedido.BuscarPedido(const pValue: string; pCampoBusca: Integer):  TObjectList<TPedido>;
var
  qConsulta: TFDQuery;
  Pedido: TPedido;
  ItemPedido: TItemPedido;
  PedidoList: TObjectList<TPedido>;
begin
  PedidoList := TObjectList<TPedido>.Create;

  qConsulta := TFDQuery.Create(nil);
  qConsulta.Connection := FConnection;
  qConsulta.SQL.Add(
    'SELECT PED_NRPEDIDO, ' + #13 + #10 +
    '       PED_DTEMISSAO, ' + #13 + #10 +
    '       CLI_CDCLIENTE,' + #13 + #10 +
    '       PED_VLTOTAL,' + #13 + #10 +
    '       PED_USCADASTRO,' + #13 + #10 +
    '       PED_DTCADASTRO,' + #13 + #10 +
    '       PED_USALTERACAO,' + #13 + #10 +
    '       PED_DTALTERACAO ' + #13 + #10 +
    '  FROM PEDIDO_PED ' + #13 + #10 +
    ' WHERE 1 = 1 '
  );

  case pCampoBusca of
    TPB_NRPEDIDO: begin
      qConsulta.SQL.Add(' AND PED_NRPEDIDO = :NrPedido');
      qConsulta.ParamByName('NrPedido').AsInteger := StrToInt(pValue);
    end;

    TPB_CDCLIENTE: begin
      qConsulta.SQL.Add(' AND CLI_CDCLIENTE = :CdCliente');
      qConsulta.ParamByName('CdCliente').AsInteger := StrToInt(pValue);
    end;

    TPB_DTEMISSAO: begin
      qConsulta.SQL.Add(' AND PED_DTEMISSAO = :DtEmissao');
      qConsulta.ParamByName('DtEmissao').AsDateTime := StrToDate(pValue);
    end;
  end;

  try
    try
      qConsulta.Open;
      if not qConsulta.IsEmpty then begin
        Pedido := TPedido.Create(FConnection);
        with Pedido do begin
          FNumeroPedido.Valor := qConsulta.FieldByName('PED_NRPEDIDO').AsInteger;
          FDataEmissao.Valor := qConsulta.FieldByName('PED_DTEMISSAO').AsDateTime;
          FCDCliente.Valor := qConsulta.FieldByName('CLI_CDCLIENTE').AsInteger;
          FValorTotal.Valor := qConsulta.FieldByName('PED_VLTOTAL').AsCurrency;
          FUSCadastro.Valor := qConsulta.FieldByName('PED_USCADASTRO').AsString;
          FDTCadastro.Valor := qConsulta.FieldByName('PED_DTCADASTRO').AsDateTime;
          FUSAlteracao.Valor := qConsulta.FieldByName('PED_USALTERACAO').AsString;
          FDTAlteracao.Valor := qConsulta.FieldByName('PED_DTALTERACAO').AsDateTime;
        end;


        if Pedido <> nil then begin
          qConsulta.SQL.Clear;
          qConsulta.SQL.Add(
            'SELECT ITE_SEQ, '        + #13 + #10 +
            '       PED_NRPEDIDO, '   + #13 + #10 +
            '       PRO_CDPRODUTO, '  + #13 + #10 +
            '       ITE_QTDE, '       + #13 + #10 +
            '       ITE_VLUNITARIO, ' + #13 + #10 +
            '       ITE_VLTOTAL '     + #13 + #10 +
            '  FROM ITEMPEDIDO_ITE '  + #13 + #10 +
            ' WHERE PED_NRPEDIDO = :NrPedido '
          );
          qConsulta.ParamByName('NrPedido').AsInteger := Pedido.FNumeroPedido.Valor;

          with qConsulta do begin
            Open;
            while not Eof do begin
              ItemPedido := TItemPedido.Create(
                FieldByName('ITE_SEQ').AsInteger,
                FieldByName('PED_NRPEDIDO').AsInteger,
                FieldByName('PRO_CDPRODUTO').AsInteger,
                FieldByName('ITE_QTDE').AsFloat,
                FieldByName('ITE_VLUNITARIO').AsCurrency
              );

              ItemPedido.CalcularValorTotal;
              Pedido.AdicionarItem(ItemPedido);

              Next;
            end;
          end;
        end;

        PedidoList.Add(Pedido);
      end;
    except
      on E: Exception do
        ShowMessage(MSG_DB_ERROR + E.Message);
    end;
  finally
    qConsulta.Free;
  end;

  Result := PedidoList;
end;

end.

