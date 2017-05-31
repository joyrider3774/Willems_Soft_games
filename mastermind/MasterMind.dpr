program MasterMind;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {Form1},
  FrmAbout in 'FrmAbout.pas' {AboutBox},
  misc in '..\units\misc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Master Mind';
  Application.HelpFile := 'C:\Program Files\Borland\Delphi5\davy\mastermind\MasterMind.hlp';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
