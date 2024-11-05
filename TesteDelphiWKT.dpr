program TesteDelphiWKT;

uses
  Vcl.Forms,
  UMenu in 'Units\Menu\UMenu.pas' {frmMenu},
  UPedidos in 'Units\Pedidos\UPedidos.pas' {frmPedidoVenda},
  UBusca in 'Units\Busca\UBusca.pas' {frmBuscar},
  UImagensEIcones in 'DM\Imagens\UImagensEIcones.pas' {dtmImagensEIcones: TDataModule},
  EPedido in 'Entidades\EPedido.pas',
  EClientes in 'Entidades\EClientes.pas',
  EProdutos in 'Entidades\EProdutos.pas',
  EItemPedido in 'Entidades\EItemPedido.pas',
  ETipos in 'Entidades\ETipos.pas',
  UItemPedido in 'Units\Pedidos\UItemPedido.pas' {frmIncluirItemPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMenu, frmMenu);
  Application.CreateForm(TfrmIncluirItemPedido, frmIncluirItemPedido);
  Application.Run;
end.
