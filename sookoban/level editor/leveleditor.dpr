program leveleditor;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {Form1},
  FrmAbout in 'FrmAbout.pas' {aboutbox},
  misc in 'misc.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sookoban level editor';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Taboutbox, aboutbox);
  Application.Run;
end.
