﻿object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  Caption = 'Pedido de venda'
  ClientHeight = 548
  ClientWidth = 996
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlPedidoVenda: TPanel
    Left = 0
    Top = 0
    Width = 996
    Height = 548
    Align = alClient
    TabOrder = 0
    object gbxBuscaPedido: TGroupBox
      Left = 1
      Top = 1
      Width = 994
      Height = 56
      Align = alTop
      TabOrder = 0
      object lblPedido: TLabel
        Left = 8
        Top = 8
        Width = 32
        Height = 13
        Caption = 'Pedido'
      end
      object lblDataEmissao: TLabel
        Left = 856
        Top = 8
        Width = 79
        Height = 13
        Caption = 'Data de emiss'#227'o'
      end
      object lblOrientação: TLabel
        Left = 171
        Top = 27
        Width = 541
        Height = 13
        Caption = 
          'Pressione "Enter" para iniciar um novo pedido. Para alterar um p' +
          'edido, digite o  c'#243'digo ou fa'#231'a a busca no bot'#227'o!'
      end
      object edtPedido: TEdit
        Left = 8
        Top = 24
        Width = 121
        Height = 21
        BorderStyle = bsNone
        NumbersOnly = True
        TabOrder = 0
        OnExit = edtPedidoExit
        OnKeyDown = edtPedidoKeyDown
      end
      object btnBuscaPedido: TButton
        Left = 132
        Top = 22
        Width = 29
        Height = 25
        Hint = 'Buscar pedido'
        ImageAlignment = iaCenter
        ImageIndex = 4
        Images = dtmImagensEIcones.vilIcones
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnBuscaPedidoClick
      end
      object dtpEmissao: TDateTimePicker
        Left = 856
        Top = 24
        Width = 121
        Height = 21
        Hint = 'Data de emiss'#227'o'
        Date = 45599.000000000000000000
        Time = 45599.000000000000000000
        Enabled = False
        MaxDate = 73050.999988425930000000
        MinDate = 28856.000000000000000000
        TabOrder = 2
        OnChange = dtpEmissaoChange
      end
    end
    object gbxDadosGerais: TGroupBox
      Left = 1
      Top = 57
      Width = 994
      Height = 88
      Align = alTop
      Caption = ' Dados gerais '
      Enabled = False
      TabOrder = 1
      object lblCliente: TLabel
        Left = 24
        Top = 29
        Width = 33
        Height = 13
        Caption = 'Cliente'
      end
      object lblCidade: TLabel
        Left = 652
        Top = 29
        Width = 33
        Height = 13
        Caption = 'Cidade'
      end
      object lblUF: TLabel
        Left = 936
        Top = 29
        Width = 13
        Height = 13
        Caption = 'UF'
      end
      object edtCodigoCliente: TEdit
        Left = 24
        Top = 48
        Width = 105
        Height = 21
        BorderStyle = bsNone
        TabOrder = 0
        OnExit = edtCodigoClienteExit
        OnKeyDown = edtCodigoClienteKeyDown
      end
      object edtNomeCliente: TEdit
        Left = 164
        Top = 48
        Width = 485
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        ReadOnly = True
        TabOrder = 2
      end
      object edtCidadeCliente: TEdit
        Left = 652
        Top = 48
        Width = 281
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        ReadOnly = True
        TabOrder = 3
      end
      object edtUFCliente: TEdit
        Left = 936
        Top = 48
        Width = 41
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        ReadOnly = True
        TabOrder = 4
      end
      object btnBuscaCliente: TButton
        Left = 132
        Top = 46
        Width = 29
        Height = 25
        Hint = 'Buscar cliente'
        ImageAlignment = iaCenter
        ImageIndex = 3
        Images = dtmImagensEIcones.vilIcones
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnBuscaClienteClick
      end
    end
    object gbxItensPedido: TGroupBox
      Left = 1
      Top = 145
      Width = 994
      Height = 361
      Align = alClient
      Caption = 'Itens do pedido'
      Enabled = False
      TabOrder = 2
      object pnlIncluirAlterarRemoverItens: TPanel
        Left = 2
        Top = 15
        Width = 990
        Height = 34
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        DesignSize = (
          990
          34)
        object btnIncluirItem: TButton
          Left = 706
          Top = 5
          Width = 75
          Height = 25
          Hint = 'Incluir item'
          Anchors = [akTop, akRight, akBottom]
          Caption = 'Incluir'
          ImageIndex = 0
          Images = dtmImagensEIcones.vilIcones
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnIncluirItemClick
        end
        object btnAlterarItem: TButton
          Left = 797
          Top = 5
          Width = 75
          Height = 25
          Hint = 'Alterar item'
          Anchors = [akTop, akRight, akBottom]
          Caption = 'Alterar'
          ImageIndex = 1
          Images = dtmImagensEIcones.vilIcones
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = stgItensPedidoDblClick
        end
        object btnRemoverItem: TButton
          Left = 888
          Top = 5
          Width = 75
          Height = 25
          Hint = 'Remover item'
          Anchors = [akTop, akRight, akBottom]
          Caption = 'Remover'
          ImageIndex = 2
          Images = dtmImagensEIcones.vilIcones
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnRemoverItemClick
        end
      end
      object stgItensPedido: TStringGrid
        Left = 2
        Top = 49
        Width = 990
        Height = 310
        Align = alClient
        FixedCols = 0
        RowCount = 2
        Options = [goFixedHorzLine, goHorzLine, goRangeSelect, goEditing, goRowSelect]
        TabOrder = 1
        OnDblClick = stgItensPedidoDblClick
        OnKeyDown = stgItensPedidoKeyDown
        ColWidths = (
          130
          437
          127
          129
          124)
      end
    end
    object pnlPersistir: TPanel
      Left = 1
      Top = 506
      Width = 994
      Height = 41
      Align = alBottom
      Enabled = False
      TabOrder = 3
      DesignSize = (
        994
        41)
      object lblTotalPedido: TLabel
        Left = 8
        Top = 11
        Width = 78
        Height = 13
        Caption = 'Total do pedido:'
      end
      object btnGravarAlterar: TButton
        Left = 740
        Top = 6
        Width = 75
        Height = 25
        Anchors = [akTop, akRight, akBottom]
        Caption = '&Gravar'
        ImageIndex = 8
        Images = dtmImagensEIcones.vilIcones
        TabOrder = 0
        OnClick = btnGravarAlterarClick
      end
      object btnExcluir: TButton
        Left = 902
        Top = 6
        Width = 75
        Height = 25
        Anchors = [akTop, akRight, akBottom]
        Caption = '&Excluir'
        ImageIndex = 9
        Images = dtmImagensEIcones.vilIcones
        TabOrder = 2
        OnClick = btnExcluirClick
      end
      object btnCancelar: TButton
        Left = 821
        Top = 6
        Width = 75
        Height = 25
        Anchors = [akTop, akRight, akBottom]
        Caption = '&Cancelar'
        ImageIndex = 7
        Images = dtmImagensEIcones.vilIcones
        TabOrder = 1
        OnClick = btnCancelarClick
      end
      object edtTotalPedido: TEdit
        Left = 94
        Top = 8
        Width = 121
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 3
      end
    end
  end
end
