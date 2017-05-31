program puzzleshuffle;

uses
  Forms,
  FrmMain in 'FrmMain.pas' {Frm_Puzzle_Shuffle},
  FrmAbout in 'FrmAbout.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Puzzle Shuffle';
  Application.CreateForm(TFrm_Puzzle_Shuffle, Frm_Puzzle_Shuffle);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
