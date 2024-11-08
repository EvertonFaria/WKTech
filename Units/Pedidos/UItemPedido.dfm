object frmIncluirItemPedido: TfrmIncluirItemPedido
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Incluir item no pedido'
  ClientHeight = 174
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBotoes: TPanel
    Left = 0
    Top = 133
    Width = 645
    Height = 41
    Align = alBottom
    Color = clMaroon
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      645
      41)
    object btnInserir: TButton
      Left = 482
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight, akBottom]
      Caption = '&Inserir'
      ImageIndex = 0
      Images = dtmImagensEIcones.vilIcones
      TabOrder = 0
      OnClick = btnInserirClick
    end
    object btnCancelar: TButton
      Left = 562
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight, akBottom]
      Caption = '&Cancelar'
      ImageIndex = 7
      Images = dtmImagensEIcones.vilIcones
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 133
    Align = alClient
    TabOrder = 0
    object lblProduto: TLabel
      Left = 16
      Top = 16
      Width = 38
      Height = 13
      Caption = 'Produto'
    end
    object lblQuantidade: TLabel
      Left = 16
      Top = 64
      Width = 56
      Height = 13
      Caption = 'Quantidade'
    end
    object lblValorUnitario: TLabel
      Left = 143
      Top = 64
      Width = 63
      Height = 13
      Caption = 'Valor unit'#225'rio'
    end
    object lblValorTotal: TLabel
      Left = 270
      Top = 64
      Width = 48
      Height = 13
      Caption = 'ValorTotal'
    end
    object edtCodProduto: TEdit
      Left = 16
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 0
      OnExit = edtCodProdutoExit
      OnKeyDown = edtCodProdutoKeyDown
    end
    object edtDescricaoProduto: TEdit
      Left = 168
      Top = 32
      Width = 457
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtQuantidade: TEdit
      Left = 16
      Top = 80
      Width = 121
      Height = 21
      NumbersOnly = True
      TabOrder = 3
      OnExit = edtQuantidadeExit
    end
    object edtValorUnitario: TEdit
      Left = 143
      Top = 80
      Width = 121
      Height = 21
      TabOrder = 4
      OnExit = edtValorUnitarioExit
      OnKeyPress = edtValorUnitarioKeyPress
    end
    object edtValorTotal: TEdit
      Left = 270
      Top = 80
      Width = 121
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 5
      OnChange = edtValorTotalChange
    end
    object btnBuscaProduto: TButton
      Left = 140
      Top = 30
      Width = 25
      Height = 25
      ImageIndex = 4
      Images = dtmImagensEIcones.vilIcones
      TabOrder = 1
      OnClick = btnBuscaProdutoClick
    end
  end
end
