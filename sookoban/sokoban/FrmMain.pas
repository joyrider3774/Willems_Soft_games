unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, misc, MPlayer, mmsystem, inifiles;

type
  Tmainform = class(TForm)
    PaintBox1: TPaintBox;
    muur: TImage;
    dooszetter: TImage;
    playerdown: TImage;
    playerleft: TImage;
    playerright: TImage;
    playerup: TImage;
    Bevel1: TBevel;
    OpenDialog1: TOpenDialog;
    player: TImage;
    menu: TMainMenu;
    file1: TMenuItem;
    Openlevel1: TMenuItem;
    blok: TImage;
    doos: TImage;
    RestartLevel1: TMenuItem;
    About1: TMenuItem;
    HowToPlay1: TMenuItem;
    About: TMenuItem;
    MediaPlayer1: TMediaPlayer;
    Audio1: TMenuItem;
    music1: TMenuItem;
    Soundon1: TMenuItem;
    procedure PaintBox1Paint(Sender: TObject);
    procedure Openlevel1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure RestartLevel1Click(Sender: TObject);
    procedure HowToPlay1Click(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure music1Click(Sender: TObject);
    procedure Soundon1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    procedure setupfield(filename: Tfilename);
    procedure moveplayer;
    procedure checkforwin;
    function sizeoffile(filename: tfilename): integer;
  end;

var
  mainform: Tmainform;
  playfield: array[1..10, 1..10] of integer;
  gamestarted, soundon, musicon: boolean;
  playerX, playerY: integer;

implementation

uses FrmAbout, FrmHelp;

{$R *.DFM}

function tmainform.sizeoffile(filename: tfilename): integer;
var
  F: file of integer;
begin
  assignfile(f, filename);
  reset(f);
  sizeoffile := filesize(f);
  closefile(f);
end;

procedure Tmainform.moveplayer;
begin
  player.left := paintbox1.left + (playerx - 1) * 40;
  player.Top := paintbox1.top + (playerY - 1) * 40;
end;

procedure Tmainform.PaintBox1Paint(Sender: TObject);
var
  tel1, tel2: integer;
begin
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
      case playfield[tel2, tel1] of
        1: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), muur.canvas,
              rect(0, 0, 39, 39));
        3: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), doos.canvas,
              rect(0, 0, 39, 39));
        4: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), blok.canvas,
              rect(0, 0, 39, 39));
        5: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), dooszetter.canvas,
              rect(0, 0, 39, 39));
        6: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), doos.canvas,
              rect(0, 0, 39, 39));
      end;
end;

procedure tmainform.setupfield(filename: Tfilename);
var
  tel1, tel2, buf: integer;
  level: file of integer;
begin
  assignfile(level, filename);
  reset(level);
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
    begin
      read(level, buf);
      if buf = 2 then
      begin
        playerX := tel2;
        playerY := tel1;
        buf := 1;
      end;
      playfield[tel2, tel1] := buf;
    end;
  closefile(level);
  paintbox1paint(nil);
  player.Picture := playerright.picture;
  moveplayer;
  gamestarted := true;
end;

procedure Tmainform.Openlevel1Click(Sender: TObject);
begin
  if opendialog1.execute then
  begin
    opendialog1.initialdir := getpaddir(opendialog1.filename);
    if sizeoffile(opendialog1.filename) = 100 then
    begin
      setupfield(opendialog1.filename);
      if musicon then
      begin
        mediaplayer1.position := 0;
        mediaplayer1.play;
      end;
    end
    else
      application.messagebox(pchar(opendialog1.filename +
        ' is not a valid sookoban level'), 'Error', MB_ok);
  end;
end;

procedure tmainform.checkforwin;
var
  tel1, tel2, doos, dooszetter: integer;
begin
  doos := 0;
  dooszetter := 0;
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
      case playfield[tel2, tel1] of
        3: inc(doos);
        5: inc(dooszetter);
      end;
  if (doos = 0) and (dooszetter = 0) then
  begin
    gamestarted := false;
    mediaplayer1.stop;
    mediaplayer1.rewind;
    if soundon then
      sndplaysound('congrats.wav', snd_nodefault + snd_async);
    application.messagebox('You have Succesfully completed this level',
      'Congratulations', MB_OK);
  end;
end;

procedure Tmainform.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  playermoved: boolean;
begin
  if gamestarted then
  begin
    playermoved := false;
    case key of
      vk_up: if (playerY - 1 >= 1) then
        begin
          if (playfield[playerx, playerY - 1] = 4) then
            if soundon then
              sndplaysound('hu.wav', snd_nodefault + snd_async);

          if (playfield[playerX, PLayerY - 1] = 3) and (playfield[playerX,
            PlayerY - 2] <> 4) and (playfield[playerX, PlayerY - 2] <> 3) and
            (playfield[playerX, PlayerY - 2] <> 5) and (playfield[playerX, PlayerY
            - 2] <> 6) and (playerY - 2 >= 1) then
            if not playermoved then
            begin
              playfield[playerX, playerY - 2] := 3;
              playfield[playerX, PlayerY - 1] := 1;
              paintbox1paint(nil);
              dec(playery);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY - 1] = 6) and (playfield[playerX,
            PlayerY - 2] <> 4) and (playfield[playerX, PlayerY - 2] <> 3) and
            (playfield[playerX, PlayerY - 2] <> 5) and (playfield[playerX, PlayerY
            - 2] <> 6) and (playerY - 2 >= 1) then
            if not playermoved then
            begin
              playfield[playerX, playerY - 2] := 3;
              playfield[playerX, PlayerY - 1] := 5;
              paintbox1paint(nil);
              dec(playery);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY - 1] = 6) and (playfield[playerX,
            PlayerY - 2] <> 4) and (playfield[playerX, PlayerY - 2] <> 3) and
            (playfield[playerX, PlayerY - 2] = 5) then
            if not playermoved then
            begin
              playfield[playerX, playerY - 2] := 6;
              playfield[playerX, PlayerY - 1] := 5;
              paintbox1paint(nil);
              dec(playery);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY - 1] = 3) and (playfield[playerX,
            PlayerY - 2] <> 4) and (playfield[playerX, PlayerY - 2] <> 3) and
            (playfield[playerX, PlayerY - 2] = 5) then
            if not playermoved then
            begin
              playfield[playerX, playerY - 2] := 6;
              playfield[playerX, PlayerY - 1] := 1;
              paintbox1paint(nil);
              dec(playery);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY - 1] = 1) or (playfield[playerx, playerY
            - 1] = 5) then
            if not playermoved then
            begin
              dec(playery);
              moveplayer;
            end;

          player.picture := playerup.picture;
        end;

      vk_left: if (playerX - 1 >= 1) then
        begin
          if (playfield[playerX - 1, playerY] = 4) then
            if soundon then
              sndplaysound('hu.wav', snd_nodefault + snd_async);

          if (playfield[playerX - 1, PLayerY] = 3) and (playfield[playerX - 2,
            PlayerY] <> 4) and (playfield[playerX - 2, PlayerY] <> 3) and
            (playfield[playerX - 2, PlayerY] <> 5) and (playfield[playerX - 2,
            PlayerY] <> 6) and (playerx - 2 >= 1) then
            if not playermoved then
            begin
              playfield[playerX - 2, playerY] := 3;
              playfield[playerX - 1, PlayerY] := 1;
              paintbox1paint(nil);
              dec(playerX);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX - 1, PLayerY] = 6) and (playfield[playerX - 2,
            PlayerY] <> 4) and (playfield[playerX - 2, PlayerY] <> 3) and
            (playfield[playerX - 2, PlayerY] <> 5) and (playfield[playerX - 2,
            PlayerY] <> 6) and (playerx - 2 >= 1) then
            if not playermoved then
            begin
              playfield[playerX - 2, playerY] := 3;
              playfield[playerX - 1, PlayerY] := 5;
              paintbox1paint(nil);
              dec(playerX);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX - 1, PLayerY] = 6) and (playfield[playerX - 2,
            PlayerY] <> 4) and (playfield[playerX - 2, PlayerY] <> 3) and
            (playfield[playerX - 2, PlayerY] = 5) then
            if not playermoved then
            begin
              playfield[playerX - 2, playerY] := 6;
              playfield[playerX - 1, PlayerY] := 5;
              paintbox1paint(nil);
              dec(playerX);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX - 1, PLayerY] = 3) and (playfield[playerX - 2,
            PlayerY] <> 4) and (playfield[playerX - 2, PlayerY] <> 3) and
            (playfield[playerX - 2, PlayerY] = 5) then
            if not playermoved then
            begin
              playfield[playerX - 2, playerY] := 6;
              playfield[playerX - 1, PlayerY] := 1;
              paintbox1paint(nil);
              dec(playerX);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX - 1, PLayerY] = 1) or (playfield[playerx - 1,
            playerY] = 5) then
            if not playermoved then
            begin
              dec(playerX);
              moveplayer;
            end;

          player.picture := playerleft.picture;
        end;
      vk_down: if (playerY + 1 <= 10) then
        begin
          if (playfield[playerx, playerY + 1] = 4) then
            if soundon then
              sndplaysound('hu.wav', snd_nodefault + snd_async);
          if (playfield[playerX, PLayerY + 1] = 3) and (playfield[playerX,
            PlayerY + 2] <> 4) and (playfield[playerX, PlayerY + 2] <> 3) and
            (playfield[playerX, PlayerY + 2] <> 5) and (playfield[playerX, PlayerY
            + 2] <> 6) and (plaYerY + 2 <= 10) then
            if not playermoved then
            begin
              playfield[playerX, playerY + 2] := 3;
              playfield[playerX, PlayerY + 1] := 1;
              paintbox1paint(nil);
              inc(playerY);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY + 1] = 6) and (playfield[playerX,
            PlayerY + 2] <> 4) and (playfield[playerX, PlayerY + 2] <> 3) and
            (playfield[playerX, PlayerY + 2] <> 5) and (playfield[playerX, PlayerY
            + 2] <> 6) and (plaYerY + 2 <= 10) then
            if not playermoved then
            begin
              playfield[playerX, playerY + 2] := 3;
              playfield[playerX, PlayerY + 1] := 5;
              paintbox1paint(nil);
              inc(playerY);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY + 1] = 6) and (playfield[playerX,
            PlayerY + 2] <> 4) and (playfield[playerX, PlayerY + 2] <> 3) and
            (playfield[playerX, PlayerY + 2] = 5) then
            if not playermoved then
            begin
              playfield[playerX, playerY + 2] := 6;
              playfield[playerX, PlayerY + 1] := 5;
              paintbox1paint(nil);
              inc(playerY);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY + 1] = 3) and (playfield[playerX,
            PlayerY + 2] <> 4) and (playfield[playerX, PlayerY + 2] <> 3) and
            (playfield[playerX, PlayerY + 2] = 5) then
            if not playermoved then
            begin
              playfield[playerX, playerY + 2] := 6;
              playfield[playerX, PlayerY + 1] := 1;
              paintbox1paint(nil);
              inc(playerY);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX, PLayerY + 1] = 1) or (playfield[playerx, playerY
            + 1] = 5) then
            if not playermoved then
            begin
              inc(playerY);
              moveplayer;
            end;

          player.picture := playerdown.picture;
        end;

      vk_right: if (playerX + 1 <= 10) then
        begin
          if (playfield[playerx + 1, playerY] = 4) then
            if soundon then
              sndplaysound('hu.wav', snd_nodefault + snd_async);
          if (playfield[playerX + 1, PLayerY] = 3) and (playfield[playerX + 2,
            PlayerY] <> 4) and (playfield[playerX + 2, PlayerY] <> 3) and
            (playfield[playerX + 2, PlayerY] <> 5) and (playfield[playerX + 2,
            PlayerY] <> 6) and (playerX + 2 <= 10) then
            if not playermoved then
            begin
              playfield[playerX + 2, playerY] := 3;
              playfield[playerX + 1, PlayerY] := 1;
              paintbox1paint(nil);
              inc(playerX);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX + 1, PLayerY] = 6) and (playfield[playerX + 2,
            PlayerY] <> 4) and (playfield[playerX + 2, PlayerY] <> 3) and
            (playfield[playerX + 2, PlayerY] <> 5) and (playfield[playerX + 2,
            PlayerY] <> 6) and (playerX + 2 <= 10) then
            if not playermoved then
            begin
              playfield[playerX + 2, playerY] := 3;
              playfield[playerX + 1, PlayerY] := 5;
              paintbox1paint(nil);
              inc(playerX);
              moveplayer;
              if soundon then
                sndplaysound('blip.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX + 1, PLayerY] = 6) and (playfield[playerX + 2,
            PlayerY] <> 4) and (playfield[playerX + 2, PlayerY] <> 3) and
            (playfield[playerX + 2, PlayerY] = 5) then
            if not playermoved then
            begin
              playfield[playerX + 2, playerY] := 6;
              playfield[playerX + 1, PlayerY] := 5;
              paintbox1paint(nil);
              inc(playerX);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX + 1, PLayerY] = 3) and (playfield[playerX + 2,
            PlayerY] <> 4) and (playfield[playerX + 2, PlayerY] <> 3) and
            (playfield[playerX + 2, PlayerY] = 5) then
            if not playermoved then
            begin
              playfield[playerX + 2, playerY] := 6;
              playfield[playerX + 1, PlayerY] := 1;
              paintbox1paint(nil);
              inc(playerX);
              moveplayer;
              if soundon then
                sndplaysound('click.wav', snd_nodefault + snd_async);
              checkforwin;
              playermoved := true;
            end;

          if (playfield[playerX + 1, PLayerY] = 1) or (playfield[playerx + 1,
            playerY] = 5) then
            if not playermoved then
            begin
              inc(playerX);
              moveplayer;
            end;

          player.picture := playerright.picture;
        end;
    end;
    moveplayer;
  end;
end;

procedure Tmainform.FormCreate(Sender: TObject);
var
  settingsfile: tinifile;
begin
  settingsfile := tinifile.create('sookoban.ini');
  musicon := settingsfile.readbool('sookoban', 'music', true);
  soundon := settingsfile.readbool('sookoban', 'sound', true);
  opendialog1.initialdir := settingsfile.readstring('sookoban', 'path', 'c:\');
  settingsfile.free;
  music1.checked := musicon;
  soundon1.checked := soundon;
  mainform.Left := (screen.width div 2) - (mainform.width div 2);
  mainform.top := (screen.height div 2) - (mainform.height div 2);
  DoubleBuffered := true;
end;

procedure Tmainform.RestartLevel1Click(Sender: TObject);
begin
  if gamestarted then
  begin
    setupfield(opendialog1.filename);
    if musicon then
    begin
      mediaplayer1.position := 0;
      mediaplayer1.play;
    end;
  end
  else
    application.messagebox('No Level Loaded!', 'Error', MB_OK);
end;

procedure Tmainform.HowToPlay1Click(Sender: TObject);
begin
  howtoplay.showmodal;
end;

procedure Tmainform.AboutClick(Sender: TObject);
begin
  aboutbox.showmodal;
end;

procedure Tmainform.music1Click(Sender: TObject);
begin
  music1.checked := not music1.checked;
  musicon := not musicon;
  case musicon of
    true: mediaplayer1.play;
    false: mediaplayer1.stop;
  end;
end;

procedure Tmainform.Soundon1Click(Sender: TObject);
begin
  soundon1.Checked := not soundon1.checked;
  soundon := not soundon;
end;

procedure Tmainform.FormDestroy(Sender: TObject);
var
  settingsfile: tinifile;
begin
  settingsfile := tinifile.create(ExtractFilePath(paramstr(0)) +
    'sookoban.ini');
  settingsfile.writebool('sookoban', 'music', musicon);
  settingsfile.writebool('sookoban', 'sound', soundon);
  settingsfile.writestring('sookoban', 'path', opendialog1.initialdir);
  settingsfile.free;
end;

end.

