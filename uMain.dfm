object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'HarvesterDrivers'
  ClientHeight = 86
  ClientWidth = 171
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnStartCapture: TButton
    Left = 8
    Top = 59
    Width = 75
    Height = 25
    Caption = #1047#1072#1093#1074#1072#1090
    TabOrder = 0
    OnClick = btnStartCaptureClick
  end
  object btnStopCapture: TButton
    Left = 89
    Top = 59
    Width = 75
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Enabled = False
    TabOrder = 1
    OnClick = btnStopCaptureClick
  end
  object rbgTariff: TRadioGroup
    Left = 8
    Top = 8
    Width = 156
    Height = 41
    Caption = #1058#1072#1088#1080#1092
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Primer'
      'Elete')
    TabOrder = 2
  end
end
