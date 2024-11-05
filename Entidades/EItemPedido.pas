unit EItemPedido;

interface

uses
  System.SysUtils;

type
  TItemPedido = class
  private
    FSequencial: Integer;
    FNumeroPedido: Integer;
    FCDProduto: Integer;
    FQuantidade: Double;
    FVLUnitario: Double;
    FVLTotal: Double;

  public
    constructor Create(ASequencial: Integer; ANumeroPedido, ACDProduto: Integer; AQuantidade: Double; AVLUnitario: Double);

    property Sequencial: Integer read FSequencial;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property CDProduto: Integer read FCDProduto write FCDProduto;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property VLUnitario: Double read FVLUnitario write FVLUnitario;
    property VLTotal: Double read FVLTotal write FVLTotal;

    procedure CalcularValorTotal;
  end;

implementation

{ TItemPedido }

constructor TItemPedido.Create(ASequencial: Integer; ANumeroPedido, ACDProduto: Integer; AQuantidade: Double; AVLUnitario: Double);
begin
  FSequencial := ASequencial;
  FNumeroPedido := ANumeroPedido;
  FCDProduto := ACDProduto;
  FQuantidade := AQuantidade;
  FVLUnitario := AVLUnitario;
  CalcularValorTotal;
end;

procedure TItemPedido.CalcularValorTotal;
begin
  FVLTotal := FQuantidade * FVLUnitario;
end;

end.

