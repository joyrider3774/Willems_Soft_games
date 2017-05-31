unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, Inifiles, ShellApi;

type
  TForm1 = class(TForm)
    MainPanel: TPanel;
    Panel1: TPanel;
    Boardimg: TImage;
    HandImg: TImage;
    OtherPanel: TPanel;
    PlayerPanel: TPanel;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    New1: TMenuItem;
    Quit1: TMenuItem;
    Settings1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Player21: TMenuItem;
    Humanplayer1: TMenuItem;
    PCplayer1: TMenuItem;
    BoardBackupImg: TImage;
    ButtonRedImg: TImage;
    ButtonBlueImg: TImage;
    H1: TMenuItem;
    AboutBoxIMg: TImage;
    PlayerPanelBackground: TImage;
    PlayerLabel: TLabel;
    procedure BoardimgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BoardimgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure PCplayer1Click(Sender: TObject);
    procedure Humanplayer1Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AboutBoxIMgClick(Sender: TObject);
    procedure H1Click(Sender: TObject);
  private
    { Private declarations }
  public
   function is4onarow():boolean;
   function IsGameOver:boolean;
   function IsValidMove(Column:integer):boolean;
   function CheckField(X:integer;Y:integer;NRonRow:integer;player:integer):boolean;
   Function Setpiece(column : integer;sort : integer;draw:boolean):integer;
   procedure loadsettings();
   procedure savesettings();
   procedure ClearBoardImg();
   procedure PcPlayerMove;
   procedure DoSwitchPlayer;
   procedure Drawpiece(x:integer;y:integer);
   procedure initializePlayfield;
   procedure initializegame;

    { Public declarations }
  end;

const
 NrHorizontal = 7;
 NrVertical = 6;

var
  Form1: TForm1;
  Playfield : Array[0..NrHorizontal,0..NrVertical] of integer;
  gamestarted : boolean;
  player: integer;

implementation

uses FrmAbout;

{$R *.DFM}

function Tform1.is4onarow():boolean;
var
x,y:integer;
buf:boolean;
begin
 buf := false;
 for y := 0 to NrVertical - 1 do
  for x := 0 to NrHorizontal - 1 do
   if checkfield(x,y,4,1) or checkfield(x,y,4,2) then buf := true;
 is4onarow := buf;
end;

function Tform1.IsGameOver:boolean;
var
 x,y : integer;
 buf : boolean;
begin
 buf := true;
 for y := 0 to NrVertical -1 do
  for x := 0 to NrHorizontal -1 do
   buf := buf and (playfield[x,y]<>0);
 IsGameOver := buf;
end;

function Tform1.IsValidMove(Column:integer):boolean;
begin
 IsValidMove := not (playfield[Column,0]<>0);
end;

function Tform1.CheckField(X:integer;Y:integer;NRonRow:integer;player:integer):boolean;
var
dx,dy,Piece,NrEqual : integer;
Buf: boolean;

begin
 Buf := false;
 begin
   if Playfield[x,y] =player then
   begin
    Piece := PlayField[x,y];

    // check from current piece to left
    NrEqual := 0;
    for dx := 0 to NRonRow-1 do
     if x-dx >= 0 then
      if playfield[x-dx,y]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to right
    NrEqual := 0;
    for dx := 0 to NRonRow-1 do
     if x+dx < NrHorizontal then
      if playfield[x+dx,y]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to bottom
    NrEqual := 0;
    for dy := 0 to NRonRow-1 do
     if y+dy < NrVertical then
      if playfield[x,y+dy]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to upperleft
    NrEqual := 0;
    for dy := 0 to NRonRow-1 do
     if (y-dy >= 0) and (x-dy >= 0) then
      if playfield[x-dy,y-dy]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to lowerright
    NrEqual := 0;
    for dy := 0 to NRonRow-1 do
     if (y+dy < nrvertical) and (x+dy < nrhorizontal) then
      if playfield[x+dy,y+dy]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to lowerleft
    NrEqual := 0;
    for dy := 0 to NRonRow-1 do
     if (y+dy < nrvertical) and (x-dy >=0) then
      if playfield[x-dy,y+dy]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

    // check from current piece to upperright
    NrEqual := 0;
    for dy := 0 to NRonRow-1 do
     if (y-dy >= 0) and (x+dy <nrhorizontal) then
      if playfield[x+dy,y-dy]=Piece then
       NrEqual := NrEqual+1;
    buf := buf or (NrEqual >= NronRow);

   end;
  end;
 checkfield := buf;
end;

function Tform1.Setpiece(column : integer;sort:integer;draw:boolean):integer;
var
pos :integer;
begin
 pos := 0;
 while((playfield[column,pos]=0) and (pos < NrVertical)) do
 begin
  pos := pos +1;
 end;
 playfield[column,pos-1] := sort;
 if draw then drawpiece(column,pos-1);
 Setpiece := pos-1;
end;

procedure Tform1.loadsettings();
var
ini :Tinifile;
begin
 if FileExists('./4onarow.ini') then
 begin
  ini := Tinifile.create('./4onarow.ini');
  pcplayer1.checked := ini.ReadBool('Four on a row','PCplayer',false);
  humanplayer1.checked := ini.ReadBool('Four on a row','HumanPlayer',true);
  ini.free;
 end;
end;

procedure Tform1.savesettings();
var
ini :Tinifile;
begin
  ini := Tinifile.create('./4onarow.ini');
  ini.WriteBool('Four on a row','PCplayer',pcplayer1.checked);
  ini.WriteBool('Four on a row','HumanPlayer',humanplayer1.checked);
  ini.free;
end;

procedure Tform1.ClearboardImg();
begin
 Boardimg.canvas.copyrect(rect(0,0,410,385),BoardBackupImg.canvas,rect(0,0,410,385));
end;

procedure Tform1.PcPlayerMove;
Var
x : integer;
Y : integer;
ColumnToSet,tel : integer;
begin
 ColumnToSet:=-1;

 //check if pc player can do for on a row if so that move is used
 for x := 0 to NrHorizontal - 1 do
 begin
  y := setpiece(x,2,false);
  if is4onarow then columnToSet := X;
  playfield[x,y] := 0;
 end;

 //Else check if other player can do for on a row if so set piece there
 if ColumnToSet=-1 then
 for x := 0 to NrHorizontal - 1 do
 begin
  y := setpiece(x,1,false);
  if is4onarow then
  begin
   playfield[x,y] := 0;
   if isvalidmove(x) then columnToSet := X;
  end;
  playfield[x,y] := 0;
 end;

 //else if other player can do 3 on a row if so set there
 if ColumnToSet=-1 then
 for x := 0 to NrHorizontal - 1 do
  begin
   y := setpiece(x,1,false);
   if checkfield(x,y,3,1) then
   begin
    playfield[x,y] := 0;
    if isvalidmove(x) then
    begin
     ColumnToSet := x;
    end;
   end;
   playfield[x,y] := 0;
  end;

 //else check if pc player can do 3 or 2 on a row if not choose random place
 //the check is not complete io it will not see RED empty RED RED as a thread
 tel := 3;
 while (ColumnToSet = -1) do
 begin
  if tel = 1 then
  begin
   ColumnToSet := random(NrHorizontal);
   while not isvalidmove(ColumnToSet) do
    ColumnToSet := random(NrHorizontal);
  end
  else
  for x := 0 to NrHorizontal - 1 do
  begin
   y := setpiece(x,player,false);
   if checkfield(x,y,tel,player) then
   begin
    playfield[x,y] := 0;
    if isvalidmove(x) then
    begin
     ColumnToSet := x;
    end;
   end;
   playfield[x,y] := 0;
  end;
  tel := tel -1;
 end;
 setpiece(ColumnToSet,player,true);
end;

procedure Tform1.DoSwitchPlayer;
begin
 if gamestarted then
 If Player = 1 then
 begin
  Player := 2;
  PlayerLabel.caption := 'Player 2';
  if pcplayer1.checked then
  begin
   PcPlayerMove;
   if is4onarow then
    begin
     gamestarted := False;
     if Player = 1 then
      PlayerLabel.caption := 'Player 1 Wins'
     else
      PlayerLabel.caption := 'Player 2 Wins';
     Handimg.visible := false;
    end
    else
    if IsGameOver then
    begin
     gamestarted := False;
     PlayerLabel.caption := 'Game over';
     Handimg.visible := false;
    end
    else
    begin
     Player := 1;
     PlayerLabel.caption := 'Player 1';
    end;
  end;
 end
 else
 begin
  Player := 1;
  PlayerLabel.caption := 'Player 1';
 end;
end;

procedure Tform1.Drawpiece(x:integer;y:integer);
begin
 case player of
  1: boardimg.Canvas.copyrect(rect(27+(x*50),33+(y*50),27+((x+1)*50),33+((y+1)*50)),ButtonRedImg.canvas,rect(0,0,50,50));
  2: boardimg.Canvas.copyrect(rect(27+(x*50),33+(y*50),27+((x+1)*50),33+((y+1)*50)),ButtonBlueImg.canvas,rect(0,0,50,50));
 end;
end;

procedure Tform1.initializePlayfield;
var
 x,y:integer;
begin
 for y := 0 to NrVertical -1 do
  for x := 0 to NrHorizontal -1 do
   Playfield[x,y] := 0;
end;

procedure Tform1.initializegame;
begin
 randomize;
 initializePlayfield;
 ClearBoardImg;
 Player := 1;
 PlayerLabel.caption := 'Player 1';
 gamestarted := true;
 handImg.visible := true;
end;

procedure TForm1.BoardimgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
tel : integer;
begin
 if gamestarted then
 begin
  for tel := 0 to NrHorizontal-1 do
  if (X > 27+tel*50) and (X < 27+(tel+1)*50) then
   if HandImg.left <> 60+Tel*50 then
    HandImg.left := 60+Tel*50;
 end;
end;

procedure TForm1.BoardimgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
Var
Position : integer;
begin
 if gamestarted then
 begin
  position :=(handimg.left div 50)-1;
  if IsValidMove(position) then
  begin
   Setpiece(position,player,true);
   if is4onarow then
   begin
    gamestarted := False;
    if Player = 1 then
     PlayerLabel.caption := 'Player 1 Wins'
    else
     PlayerLabel.caption := 'Player 2 Wins';
    Handimg.visible := false;
   end
   else
   if IsGameOver then
   begin
    gamestarted := False;
    PlayerLabel.caption := 'Game over';
    Handimg.visible := false;
   end;
   DoSwitchplayer;
  end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 mainpanel.DoubleBuffered := true;
 loadsettings;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
 if gamestarted then
 begin
  if application.messagebox('You are already playing a game,'+chr(13)+'Are you sure you want to start a new game and stop the current one?','Confirmation',MB_YESNO+MB_ICONQUESTION) = IDYES then
   initializegame;
 end
 else
 initializegame;
end;

procedure TForm1.PCplayer1Click(Sender: TObject);
begin
 if gamestarted and not pcplayer1.checked then
 begin
  if application.messagebox('You are already playing a game,'+chr(13)+'setting player 2 to PC Player will restart the current game'+chr(13)+'Are you sure you want to set player 2 to PC Player and start a new game?','Confirmation',MB_YESNO +MB_ICONQUESTION) = IDYES then
  begin
   pcplayer1.checked := true;
   humanplayer1.checked := false;
   initializegame;
  end;
 end
 else
 begin
  pcplayer1.checked := true;
  humanplayer1.checked := false;
 end;
end;

procedure TForm1.Humanplayer1Click(Sender: TObject);
begin
 if gamestarted and pcplayer1.checked then
 begin
  if application.messagebox('You are already playing a game,'+chr(13)+'setting player 2 to Human Player will restart the current game'+chr(13)+'Are you sure you want to set player 2 to Human Player and start a new game?','Confirmation',MB_YESNO +MB_ICONQUESTION) = IDYES then
  begin
   pcplayer1.checked := false;
   humanplayer1.checked := true;
   initializegame;
  end;
 end
 else
 begin
  pcplayer1.checked := false;
  humanplayer1.checked := true;
 end;
end;

procedure TForm1.Quit1Click(Sender: TObject);
begin
 application.terminate;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
 aboutbox.showmodal;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 savesettings();
end;

procedure TForm1.AboutBoxIMgClick(Sender: TObject);
begin
 ShellExecute(Application.Handle,'open','Http://www.willemssoft.be',nil,nil,SW_SHOWMAXIMIZED);
end;

procedure TForm1.H1Click(Sender: TObject);
begin
 application.HelpContext(1);
end;

end.
