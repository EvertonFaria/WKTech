object frmMenu: TfrmMenu
  Left = 0
  Top = 0
  Caption = 'Teste t'#233'cnico WK Delphi'
  ClientHeight = 677
  ClientWidth = 1048
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = mmnMenu
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object stbMenu: TStatusBar
    Left = 0
    Top = 658
    Width = 1048
    Height = 19
    Panels = <
      item
        Text = 'Desenvolvido por Everton Oliveira'
        Width = 50
      end>
    ExplicitLeft = 112
    ExplicitTop = 632
    ExplicitWidth = 0
  end
  object pnlAcessoRapido: TPanel
    Left = 0
    Top = 0
    Width = 105
    Height = 658
    Align = alLeft
    Color = clMaroon
    ParentBackground = False
    TabOrder = 1
    object btnPedidos: TButton
      Left = 16
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Pedidos'
      TabOrder = 0
      OnClick = mniPedidosClick
    end
  end
  object mmnMenu: TMainMenu
    Left = 1000
    Top = 536
    object mniCadastros: TMenuItem
      Caption = '&Cadastros'
      object mniClientes: TMenuItem
        Caption = 'C&lientes'
      end
      object mniProdutos: TMenuItem
        Caption = 'P&rodutos'
      end
    end
    object mniProcessos: TMenuItem
      Caption = '&Processos'
      object mniPedidos: TMenuItem
        Caption = 'P&edidos'
        OnClick = mniPedidosClick
      end
    end
    object mniUtilitarios: TMenuItem
      Caption = '&Utilit'#225'rios'
      object mniParametrosGerais: TMenuItem
        Caption = 'Par'#226'metros &gerais'
      end
    end
    object mniSair: TMenuItem
      Caption = '&Sair'
      OnClick = mniSairClick
    end
  end
  object fdcMySQLConnection: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'Database=WKTeste'
      'Password=mysql'
      'User_Name=root'
      'Server=localhost')
    LoginPrompt = False
    AfterConnect = fdcMySQLConnectionAfterConnect
    Left = 904
    Top = 8
  end
  object dvrMySQLDriverLink: TFDPhysMySQLDriverLink
    VendorLib = 'E:\projetos\WK Technology\libs\libmysql.dll'
    Left = 904
    Top = 64
  end
  object wcrMySQLWaytCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 904
    Top = 120
  end
end
