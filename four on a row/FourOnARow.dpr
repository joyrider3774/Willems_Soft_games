program FourOnARow;

uses
  Forms,
  Sysutils,
  FrmMain in 'FrmMain.pas' {Form1},
  FrmAbout in 'FrmAbout.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Four on a row';
  Application.HelpFile := ExtractFilePath(Paramstr(0)) +  '\4ONAROW.HLP';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
