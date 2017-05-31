object aboutbox: Taboutbox
  Left = 333
  Top = 257
  BorderStyle = bsToolWindow
  Caption = 'aboutbox'
  ClientHeight = 283
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 96
    Top = 16
    Width = 233
    Height = 20
    Caption = 'About Sookoban Level editor'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 46
    Height = 13
    Caption = 'Creator:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 88
    Width = 305
    Height = 13
    Caption = 'Sookoban Level editor was created by Willems Davy in Delphi 5.'
  end
  object Label4: TLabel
    Left = 16
    Top = 144
    Width = 86
    Height = 13
    Caption = 'Contacting me:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object Label5: TLabel
    Left = 16
    Top = 168
    Width = 27
    Height = 13
    Caption = '- Site:'
  end
  object Label6: TLabel
    Left = 16
    Top = 192
    Width = 28
    Height = 13
    Caption = '- Mail:'
  end
  object Label7: TLabel
    Left = 16
    Top = 104
    Width = 324
    Height = 13
    Caption = 
      'Levels with raptor mentioned in the name were created by Tharapt' +
      'or.'
  end
  object Label8: TLabel
    Left = 16
    Top = 120
    Width = 273
    Height = 13
    Caption = 'Sookoban is FREEWARE , no money may be asked for it.'
  end
  object Button1: TButton
    Left = 136
    Top = 232
    Width = 113
    Height = 33
    Caption = 'OK'
    TabOrder = 0
    OnClick = Button1Click
  end
end
