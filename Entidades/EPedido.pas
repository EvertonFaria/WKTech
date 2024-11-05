unit EPedido;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, System.Generics.Collections, EProdutos, EClientes, EItemPedido,
  FireDAC.Stan.Param, Data.DB, Dialogs;

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
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCDCliente: Integer;
    FValorTotal: Double;
    FItens: TObjectList<TItemPedido>;
    FUSCadastro: string;
    FDTCadastro: TDateTime;
    FUSAlteracao: string;
    FDTAlteracao: TDateTime;

  protected
    procedure SetCDCliente(Value: Integer);
    procedure AtualizarValorTotal;

  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;

    property NumeroPedido: Integer read FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao;
    property CDCliente: Integer read FCDCliente write SetCDCliente;
    property ValorTotal: Double read FValorTotal;
    property Itens: TObjectList<TItemPedido> read FItens;

    procedure AdicionarItem(AItem: TItemPedido);
    procedure RemoverItem(AItem: TItemPedido);
    function InserirPedido: TList<string>;
    function AlterarPedido: TList<string>;
    function ExcluirPedido: TList<string>;
    function BuscarPedido(const pValue: string; pCampoBusca: Integer): TObjectList<TPedido>;
  end;

implementation

{ TPedido }

constructor TPedido.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
  FItens := TObjectList<TItemPedido>.Create;
  FValorTotal := 0; // Inicializa o valor total
end;

destructor TPedido.Destroy;
begin
  FItens.Free;
  inherited;
end;

procedure TPedido.SetCDCliente(Value: Integer);
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
  FValorTotal := 0; // Reinicia o valor total
  for Item in FItens do
    FValorTotal := FValorTotal + Item.VLTotal; // Soma os valores totais dos itens
end;

function TPedido.InserirPedido: TList<string>;
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
      qProcessa.SQL.Add(
        'INSERT INTO PEDIDO_FAT ( ' + #13 + #10 +
        '  DATA_EMISSAO, '          + #13 + #10 +
        '  CD_CLIENTE, '            + #13 + #10 +
        '  VALOR_TOTAL '            + #13 + #10 +
        ') VALUES ( '               + #13 + #10 +
        '  :DataEmissao, '          + #13 + #10 +
        '  :CDCliente, '            + #13 + #10 +
        '  :ValorTotal)'
      );

      qProcessa.ParamByName('DataEmissao').AsDateTime := DataEmissao;
      qProcessa.ParamByName('CDCliente').AsInteger := CDCliente;
      qProcessa.ParamByName('ValorTotal').AsFloat := ValorTotal;

      qProcessa.ExecSQL;

      // Adiciona os itens do pedido
      for vItem in Itens do begin
        qProcessa.SQL.Clear;
        qProcessa.SQL.Add(
          'INSERT INTO ITEMPEDIDO_ITE ( ' + #13 + #10 +
          '  NUMERO_PEDIDO, '             + #13 + #10 +
          '  CD_PRODUTO, '                + #13 + #10 +
          '  QUANTIDADE, '                + #13 + #10 +
          '  VL_UNITARIO, '               + #13 + #10 +
          '  VL_TOTAL '                   + #13 + #10 +
          ') VALUES ( '                   + #13 + #10 +
          '  :NumeroPedido, '             + #13 + #10 +
          '  :CDProduto, '                + #13 + #10 +
          '  :Quantidade, '               + #13 + #10 +
          '  :VLUnitario, '               + #13 + #10 +
          '  :VLTotal)'
        );

        qProcessa.ParamByName('NumeroPedido').AsInteger := FNumeroPedido; // Use o número do pedido gerado
        qProcessa.ParamByName('CDProduto').AsInteger := vItem.CDProduto;
        qProcessa.ParamByName('Quantidade').AsFloat := vItem.Quantidade;
        qProcessa.ParamByName('VLUnitario').AsFloat := vItem.VLUnitario;
        qProcessa.ParamByName('VLTotal').AsFloat := vItem.VLTotal;

        qProcessa.ExecSQL;
      end;

      FConnection.Commit; // Commit na transação
      Messages.Add(MSG_INSERT_SUCESSO);
      Messages.Add(MSG_NEW_ID + IntToStr(FNumeroPedido));
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
      qProcessa.SQL.Add('DELETE FROM ITEMPEDIDO_ITE WHERE NUMERO_PEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      qProcessa.ExecSQL;

      // Atualiza o pedido
      qProcessa.SQL.Add(
        'UPDATE PEDIDO_FAT SET '        + #13 + #10 +
        '  VALOR_TOTAL = :ValorTotal '  + #13 + #10 +
        ' WHERE NUMERO_PEDIDO = :NumeroPedido '
      );

      qProcessa.ParamByName('ValorTotal').AsFloat := ValorTotal;
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      qProcessa.ExecSQL;

      if ( qProcessa.RowsAffected > 0) then begin
        // Adiciona os novos itens do pedido
        for vItem in Itens do begin
          qProcessa.SQL.Clear;
          qProcessa.SQL.Add(
            'INSERT INTO ITEMPEDIDO_ITE (' + #13 + #10 +
            '  NUMERO_PEDIDO, ' + #13 + #10 +
            '  CD_PRODUTO, ' + #13 + #10 +
            '  QUANTIDADE, ' + #13 + #10 +
            '  VL_UNITARIO, ' + #13 + #10 +
            '  VL_TOTAL ' + #13 + #10 +
            ') VALUES ( ' + #13 + #10 +
            '  :NumeroPedido, ' + #13 + #10 +
            '  :CDProduto, ' + #13 + #10 +
            '  :Quantidade, ' + #13 + #10 +
            '  :VLUnitario, ' + #13 + #10 +
            '  :VLTotal)'
          );

          qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
          qProcessa.ParamByName('CDProduto').AsInteger := vItem.CDProduto;
          qProcessa.ParamByName('Quantidade').AsFloat := vItem.Quantidade;
          qProcessa.ParamByName('VLUnitario').AsFloat := vItem.VLUnitario;
          qProcessa.ParamByName('VLTotal').AsFloat := vItem.VLTotal;

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
      qProcessa.SQL.Add('DELETE FROM ITEMPEDIDO_ITE WHERE NUMERO_PEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
      qProcessa.ExecSQL;

      qProcessa.SQL.Clear;
      qProcessa.SQL.Add('DELETE FROM PEDIDO_FAT WHERE NUMERO_PEDIDO = :NumeroPedido');
      qProcessa.ParamByName('NumeroPedido').AsInteger := NumeroPedido;

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
    '       PED_CDCLIENTE,' + #13 + #10 +
    '       PED_VLTOTAL,' + #13 + #10 +
    '       PED_USCADASTRO,' + #13 + #10 +
    '       PED_DTCADASTRO,' + #13 + #10 +
    '       PED_USALTERACAO,' + #13 + #10 +
    '       PED_DTALTERACAO' + #13 + #10 +
    '  FROM PEDIDO_FAT '
  );

  case pCampoBusca of
    TPB_NRPEDIDO: begin
      qConsulta.SQL.Add(' WHERE PED_NRPEDIDO = :NrPedido');
      qConsulta.ParamByName('NrPedido').AsInteger := StrToInt(pValue);
    end;

    TPB_CDCLIENTE: begin
      qConsulta.SQL.Add(' WHERE PED_CDCLIENTE = :CdCliente');
      qConsulta.ParamByName('CdCliente').AsInteger := StrToInt(pValue);
    end;

    TPB_DTEMISSAO: begin
      qConsulta.SQL.Add(' WHERE PED_DTEMISSAO = :DtEmissao');
      qConsulta.ParamByName('DtEmissao').AsDateTime := StrToDate(pValue);
    end;
  end;

  try
    try
      qConsulta.Open;
      if not qConsulta.IsEmpty then begin
        Pedido := TPedido.Create(FConnection);
        with Pedido do begin
          FNumeroPedido := qConsulta.FieldByName('PED_NRPEDIDO').AsInteger;
          FDataEmissao := qConsulta.FieldByName('PED_DTEMISSAO').AsDateTime;
          FCDCliente := qConsulta.FieldByName('PED_CDCLIENTE').AsInteger;
          FValorTotal := qConsulta.FieldByName('PED_VLTOTAL').AsCurrency;
          FUSCadastro := qConsulta.FieldByName('PED_USCADASTRO').AsString;
          FDTCadastro := qConsulta.FieldByName('PED_DTCADASTRO').AsDateTime;
          FUSAlteracao := qConsulta.FieldByName('PED_USALTERACAO').AsString;
          FDTAlteracao := qConsulta.FieldByName('PED_DTALTERACAO').AsDateTime;
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
          qConsulta.ParamByName('NrPedido').AsInteger := Pedido.FNumeroPedido;

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
              pedido.FItens.Add(ItemPedido);

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

  Result := PedidoList;
end;

end.

