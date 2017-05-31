unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ShellApi, MMSystem, inifiles, misc, UItypes;

type
  TForm1 = class(TForm)
    Panel2: TPanel;
    PlayfieldPanel: TPanel;
    PlayFieldImage: TImage;
    Panel1: TPanel;
    AboutImage: TImage;
    Button1: TButton;
    ColorButtonPanel: TPanel;
    PurpleButtonPanel: TPanel;
    PurpleButtonImage: TImage;
    LightblueButtonPanel: TPanel;
    LightblueButtonImage: TImage;
    BlueButtonPanel: TPanel;
    BlueButtonImage: TImage;
    BlackButtonPanel: TPanel;
    BlackButtonImage: TImage;
    YellowButtonPanel: TPanel;
    YellowButtonImage: TImage;
    GreenButtonPanel: TPanel;
    GreenButtonImage: TImage;
    RedButtonPanel: TPanel;
    RedButtonImage: TImage;
    WhiteButtonPanel: TPanel;
    WhiteButtonImage: TImage;
    BackupPlayFieldImage: TImage;
    SmallButtonWhiteImage: TImage;
    SmallButtonBlackImage: TImage;
    WinnerImage: TImage;
    Lozerimage: TImage;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    NewGame1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Handimage: TImage;
    Settings1: TMenuItem;
    AllowDoubles1: TMenuItem;
    Soundon1: TMenuItem;
    Howtoplay1: TMenuItem;
    procedure BlackButtonClick(Sender: TObject);
    procedure WhiteButtonClick(Sender: TObject);
    procedure BlueButtonClick(Sender: TObject);
    procedure RedButtonClick(Sender: TObject);
    procedure LightBlueButtonClick(Sender: TObject);
    procedure GreenButtonClick(Sender: TObject);
    procedure PurpleButtonClick(Sender: TObject);
    procedure YellowButtonClick(Sender: TObject);
    procedure PlayFieldImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure AboutImageClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AllowDoubles1Click(Sender: TObject);
    procedure Soundon1Click(Sender: TObject);
    procedure Howtoplay1Click(Sender: TObject);
  private
    { Private declarations }
    Function CheckValidGuess:boolean;
    Function CheckForWin:Boolean;
    procedure ResetPanelColor;
    procedure ResetSmallButtonsArray;
    Procedure ResetPlayfieldArray;
    Procedure ResetPlayfieldImage;
    procedure SetComputerButtons;
    Procedure DrawComputerButtons;
    Procedure SetHandPosition;
    procedure InitializeGame;
    procedure DrawAndSetButtons(X,Y:integer);
    Procedure DrawSmallButtons;
    Procedure CheckGuess;
    Procedure DoFirstRun;
    Procedure LoadSettings;
    Procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  SelectedButton : integer;
  GuessNr : integer;
  Playfield : array [0..10,0..3] of integer;
  SmallButtons : array[0..9,0..3] of integer;
  BackupPlayFieldImage : Tpicture;
  gamestarted,soundenabled,Allowdoubles: boolean;
const
  Empty = 0;
  Black = 1;
  White = 2;
  Blue = 3;
  Red = 4;
  LightBlue = 5;
  Green = 6;
  Purple = 7;
  Yellow = 8;
  SmallBlack = 1;
  SmallWhite = 2;
  PanelColorInactive = $0019698B;
  PanelColorActive = CLNavy;
  MaxGuess=10;

implementation

uses FrmAbout;

{$R *.DFM}

Function Tform1.CheckValidGuess:boolean;
var
 Counter: integer;
 Value : Boolean;
begin
 Value := True;
 for Counter := 0 to 3 do
  if playfield[GuessNr,Counter]=empty then Value := False;
 CheckValidGuess := value;
end;

Function Tform1.CheckForWin:Boolean;
var
 Counter: integer;
 Temp:Array[0..3] of boolean;
begin
 for Counter := 0 to 3 do
  if playfield[GuessNr,Counter]=Playfield[10,Counter] then temp[counter]:= true else temp[Counter] := false;
 CheckForwin := temp[0] and temp[1] and temp[2] and temp[3];
end;

procedure Tform1.ResetPanelColor;
begin
 BlackButtonPanel.Color := PanelColorInactive;
 WhiteButtonPanel.Color := PanelColorInactive;
 BlueButtonPanel.Color := PanelColorInactive;
 RedButtonPanel.Color := PanelColorInactive;
 LightBlueButtonPanel.Color := PanelColorInactive;
 GreenButtonPanel.Color := PanelColorInactive;
 PurpleButtonPanel.Color := PanelColorInactive;
 YellowButtonPanel.Color := PanelColorInactive;
end;

Procedure Tform1.ResetSmallButtonsArray;
Var
X,Y:integer;
Begin
 For Y := 0 to 9 do
  For X := 0 To 3 do
   SmallButtons[Y,X] := Empty;
End;

Procedure Tform1.ResetPlayfieldArray;
Var
X,Y:integer;
Begin
 For Y := 0 to 10 do
  For X := 0 To 3 do
   PlayField[Y,X] := Empty;
End;

Procedure Tform1.ResetPlayfieldImage;
begin
 Playfieldimage.Canvas.CopyRect(rect(0,0,199,399),BackupPlayFieldImage.Canvas,rect(0,0,199,399));
end;

Procedure Tform1.SetComputerButtons;
var
 Counter,counter1,value : integer;
 add:boolean;
begin
 if Allowdoubles then
 begin
  For Counter := 0 to 3 do
   Playfield[10,Counter] := Random(8)+1;
 end
 else
 begin
  counter:=0;
  While counter <=3 do
  begin
   add := false;
   value := Random(8)+1;
   while (counter >=1) and  (not add) do
   begin
    add := true;
    for counter1 := counter downto 0 do
     if  value = playfield[10,counter1] then
     begin
      add := false;
      value := Random(8)+1;
     end;
   end;
   playfield[10,Counter] := value;
   counter := counter +1;
  end;
 end;
end;

Procedure Tform1.DrawComputerButtons;
var
Counter : integer;
begin
 For counter := 0 to 3 do
 begin
  case Playfield[10,Counter] of
   Black:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),BlackButtonImage.Canvas,rect(0,0,29,29));
    end;
   White:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),WhiteButtonImage.Canvas,rect(0,0,29,29));
    end;
   Blue:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),BlueButtonImage.Canvas,rect(0,0,29,29));
    end;
   Red:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),RedButtonImage.Canvas,rect(0,0,29,29));
    end;
   LightBlue:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),LightBlueButtonImage.Canvas,rect(0,0,29,29));
    end;
   Green:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),GreenButtonImage.Canvas,rect(0,0,29,29));
    end;
   Purple:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),PurpleButtonImage.Canvas,rect(0,0,29,29));
    end;
   Yellow:
    begin
     PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),18,45+(30*counter),47),YellowButtonImage.Canvas,rect(0,0,29,29));
    end;
  end;
 end;
end;

Procedure Tform1.SetHandPosition;
begin
 If gamestarted then Handimage.top := 370-(32*Guessnr);
end;

procedure Tform1.InitializeGame;
begin
 LozerImage.visible := false;
 WinnerImage.visible := false;
 Randomize;
 GuessNr := 0;
 SelectedButton := Black;
 GameStarted := true;
 Button1.enabled := true;
 ResetPanelColor;
 BlackButtonPanel.color := PanelColorActive;
 ResetSmallButtonsArray;
 ResetPlayfieldArray;
 ResetPlayFieldImage;
 SetcomputerButtons;
 Sethandposition;
 if soundenabled then sndplaysound('restart.wav',snd_nodefault + snd_async);
end;


Procedure Tform1.DrawAndSetButtons(X,Y :integer);
var
 Counter : integer;
begin
 if SelectedButton <> Empty then
 begin
  For counter := 0 to 3 do
  begin
   if (X >= 16+(30*counter)) and (X <= 45+(30*counter)) and (Y >= 350-(32*GuessNr)) and (Y <= 379-(32*GuessNr)) then
   begin
    case Selectedbutton of
     Black:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),BlackButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Black;
      end;
     White:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),WhiteButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := White;
      end;
     Blue:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),BlueButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Blue;
      end;
     Red:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),RedButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Red;
      end;
     LightBlue:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),LightBlueButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := LightBlue;
      end;
     Green:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),GreenButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Green;
      end;
     Purple:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),PurpleButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Purple;
      end;
     Yellow:
      begin
       PlayFieldImage.Canvas.CopyRect(rect(16+(30*counter),350-(32*Guessnr),45+(30*counter),379-(32*guessnr)),YellowButtonImage.Canvas,rect(0,0,29,29));
       PlayField[GuessNr,Counter] := Yellow;
      end;
    end;
    if soundenabled then sndplaysound('blip1.wav',snd_nodefault + snd_async);
   end;
  end;
 end;
end;

Procedure SortSmallButtons;
var
 Counter1,Counter2,temp : integer;

begin
 for Counter1 := 0 to 3 do
 for Counter2 := Counter1 to 3 do
 begin
  if SmallButtons[GuessNr,Counter1] < SmallButtons[GuessNr,Counter2] then
  begin
   temp := SmallButtons[GuessNr,Counter1];
   SmallButtons[GuessNr,Counter1]:= SmallButtons[GuessNr,Counter2];
   SmallButtons[GuessNr,Counter2]:= temp;
  end;
 end;
end;

Procedure Tform1.DrawSmallButtons;
Var
Counter1,Counter2 : integer;
begin
 For counter1 := 0 to 1 do
  For Counter2 := 0 to 1 do
  begin
   case Smallbuttons[Guessnr,counter1+counter2+(1*counter1)] of
    SmallBlack :
    begin
     Playfieldimage.Canvas.CopyRect(rect(153+(counter1*15),350+(counter2*14)-guessnr*32,167+(counter1*15),364+(counter2*15)-guessnr*32),SmallbuttonBlackImage.canvas,rect(0,0,14,14));
    end;
    SmallWhite:
    begin
     Playfieldimage.Canvas.CopyRect(rect(153+(counter1*15),350+(counter2*14)-guessnr*32,167+(counter1*15),364+(counter2*15)-guessnr*32),SmallbuttonWhiteImage.canvas,rect(0,0,14,14));
    end;
   end;
  end;
end;

Procedure Tform1.CheckGuess;
Var
 Counter1,Counter2:integer;
 CodeToFind,GuessCode : Array[0..3] of integer;
begin
 For counter1 := 0 to 3 do
 begin
  CodeToFind[counter1] := Playfield[10,Counter1];
  Guesscode[counter1] := Playfield[Guessnr,Counter1];
 end;

 for Counter1 := 0 to 3 do
 begin
  if guesscode[counter1]<> empty then
  if Guesscode[Counter1]=CodeToFind[Counter1] then
  begin
   Smallbuttons[Guessnr,Counter1] := smallBlack;
   CodeToFind[Counter1] := empty;
   Guesscode[Counter1] := empty;
  end;
 end;

 for Counter1 := 0 to 3 do
 begin
  if guesscode[counter1]<> empty then
  for Counter2 := 0 to 3 do
   if (Guesscode[Counter1] = CodeToFind[Counter2]) and (smallbuttons[guessnr,Counter2] <> SmallBlack) then
   begin
    Smallbuttons[Guessnr,Counter2] := SmallWhite;
    CodeTofind[Counter2]:=empty;
    guesscode[counter1] := empty;
   end;
  end;
end;

Procedure Tform1.DoFirstRun;
begin
 IF messagedlg('I noticed this is the first time you run Master Mind,'+chr(13)+'so we will set some settings (wich you can also change later).'+chr(13)+'Do you want to enable possible double colors in the color code to find ?' ,mtConfirmation,[MByes,Mbno],-1) = IDyes then
 begin
  Allowdoubles:=true;
  Allowdoubles1.checked := true;
 end
 else
 begin
  Allowdoubles:=false;
  Allowdoubles1.checked := false;
 end;
 IF messagedlg('One last question,'+chr(13)+'Do you want to enable sound ?' ,mtConfirmation,[MByes,Mbno],-1) = IDyes then
 begin
  soundenabled:=true;
  soundon1.checked := true;
 end
 else
 begin
  soundenabled:=false;
  soundon1.checked  := false;
 end;
end;

Procedure Tform1.LoadSettings;
Var
inifile : tinifile;
begin
 inifile := tinifile.create(extractfilepath(paramstr(0)) + 'MasterMind.ini');
 SoundEnabled := inifile.readbool('MasterMind','SoundOn',True);
 AllowDoubles := inifile.readbool('MasterMind','AllowDoubles',True);
 soundon1.Checked := SoundEnabled;
 AllowDoubles1.checked := AllowDoubles;
 inifile.free;
end;

Procedure Tform1.SaveSettings;
Var
inifile : tinifile;
begin
 inifile := tinifile.create('./MasterMind.ini');
 inifile.writebool('MasterMind','SoundOn',SoundEnabled);
 inifile.writebool('MasterMind','AllowDoubles',AllowDoubles);
 inifile.free;
end;


procedure TForm1.BlackButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  BlackButtonPanel.Color := PanelColorActive;
  SelectedButton := Black;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.WhiteButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  WhiteButtonPanel.Color := PanelColorActive;
  SelectedButton := White;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.BlueButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  BlueButtonPanel.Color := PanelColorActive;
  SelectedButton := Blue;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.RedButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  RedButtonPanel.Color := PanelColorActive;
  SelectedButton := Red;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.LightBlueButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  LightBlueButtonPanel.Color := PanelColorActive;
  SelectedButton := LightBlue;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.GreenButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  GreenButtonPanel.Color := PanelColorActive;
  SelectedButton := Green;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.PurpleButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  PurpleButtonPanel.Color := PanelColorActive;
  SelectedButton := Purple;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.YellowButtonClick(Sender: TObject);
begin
 if gamestarted then
 begin
  ResetPanelColor;
  YellowButtonPanel.Color := PanelColorActive;
  SelectedButton := Yellow;
  if soundenabled then sndplaysound('blip2.wav',snd_nodefault + snd_async);
 end;
end;

procedure TForm1.PlayFieldImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 If Gamestarted then DrawAndSetButtons(x,y);
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
 if (CheckValidGuess) then
 begin
  CheckGuess;
  sortSmallbuttons;
  Drawsmallbuttons;
  If CheckForwin then
  begin
   Gamestarted := False;
   ResetPanelColor;
   Button1.enabled := false;
   WinnerImage.Visible := true;
   drawcomputerButtons;
   if soundenabled then sndplaysound('winner.wav',snd_nodefault + snd_async);
  end;
  GuessNr := GuessNr + 1;
  if (GuessNr = MaxGuess) and gamestarted then
  begin
   Gamestarted := False;
   ResetPanelColor;
   Button1.enabled := false;
   LozerImage.Visible := true;
   drawcomputerButtons;
   if soundenabled then sndplaysound('Loser.wav',snd_nodefault + snd_async);
  end;
  if gamestarted and soundenabled then sndplaysound('blip3.wav',snd_nodefault + snd_async);
  Sethandposition;
 end
 else messagedlg('You have to set Four Colored pegs on'+chr(13)+'the board in order to end your Guess!',mtConfirmation,[MbOk],-1);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 form1.doublebuffered := true;
 if not exist('./MasterMind.ini') then dofirstrun else loadsettings;
 if soundenabled then sndplaysound('dummy.wav',snd_nodefault + snd_async);
 InitializeGame;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 Application.terminate;
end;

procedure TForm1.NewGame1Click(Sender: TObject);
begin
 Initializegame;
end;

procedure TForm1.AboutImageClick(Sender: TObject);
begin
 ShellExecute(Application.Handle,'open','Http://www.willemssoft.be',nil,nil,SW_SHOWMAXIMIZED);
end;

procedure TForm1.About1Click(Sender: TObject);
begin
 Aboutbox.Showmodal;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
 Savesettings;
 if soundenabled then sndplaysound('goodbye.wav',snd_nodefault + SND_SYNC);
end;

procedure TForm1.AllowDoubles1Click(Sender: TObject);
begin
 if messagedlg('You can Only change the allow doubles setting if you start a new game!'+chr(13)+'Do you want to change the allow doubles setting and start a new game ?',Mtwarning,[MbYes,MbNo],-1)=IDYes then
 begin
  AllowDoubles := not AllowDoubles;
  AllowDoubles1.checked := not AllowDoubles1.checked;
  initializegame;
 end;
end;

procedure TForm1.Soundon1Click(Sender: TObject);
begin
 soundenabled := not soundenabled;
 SoundOn1.checked := not SoundOn1.checked;
 if soundenabled then sndplaysound('dummy.wav',snd_nodefault + snd_async); //needed to get rid of small sound delay
end;

procedure TForm1.Howtoplay1Click(Sender: TObject);
begin
 application.HelpContext(1);
end;

end.
