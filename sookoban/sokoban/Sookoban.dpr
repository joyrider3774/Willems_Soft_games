program Sookoban;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {mainform},
  misc in 'misc.pas',
  FrmHelp in 'FrmHelp.pas' {howtoplay},
  FrmAbout in 'FrmAbout.pas' {aboutbox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Sookoban';
  Application.CreateForm(Tmainform, mainform);
  Application.CreateForm(Thowtoplay, howtoplay);
  Application.CreateForm(Taboutbox, aboutbox);
  Application.Run;
end.
