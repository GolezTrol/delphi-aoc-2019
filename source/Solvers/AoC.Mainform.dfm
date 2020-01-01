object FrmAoC: TFrmAoC
  Left = 0
  Top = 0
  ActiveControl = btnGoGoGo
  Caption = 'Advent Of Code 2019'
  ClientHeight = 417
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mmoSolutions: TMemo
    Left = 8
    Top = 66
    Width = 201
    Height = 327
    TabOrder = 0
  end
  object btnGoGoGo: TButton
    Left = 8
    Top = 35
    Width = 73
    Height = 25
    Caption = 'Solve'
    Default = True
    TabOrder = 1
    OnClick = btnGoGoGoClick
  end
  object edtPath: TEdit
    Left = 8
    Top = 8
    Width = 368
    Height = 21
    TabOrder = 2
    Text = '../../../../input/GolezTrol'
  end
end
