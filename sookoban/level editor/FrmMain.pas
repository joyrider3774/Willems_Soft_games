unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Menus, ExtCtrls, misc, inifiles;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    muur: TImage;
    start: TImage;
    dooszetter: TImage;
    blok: TImage;
    doos: TImage;
    OpenDialog1: TOpenDialog;
    menu: TMainMenu;
    file1: TMenuItem;
    Openlevel1: TMenuItem;
    cursor: TImage;
    Saveleve1: TMenuItem;
    Newlevel1: TMenuItem;
    N1: TMenuItem;
    Label1: TLabel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    SaveDialog1: TSaveDialog;
    help1: TMenuItem;
    About1: TMenuItem;
    procedure startClick(Sender: TObject);
    procedure muurClick(Sender: TObject);
    procedure doosClick(Sender: TObject);
    procedure blokClick(Sender: TObject);
    procedure dooszetterClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Saveleve1Click(Sender: TObject);
    procedure Openlevel1Click(Sender: TObject);
    procedure Newlevel1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  playfield: array[1..10, 1..10] of integer;
  selection: integer;
  Form1: TForm1;

implementation

uses FrmAbout;

{$R *.DFM}

procedure TForm1.PaintBox1Paint(Sender: TObject);
var
  tel1, tel2: integer;
begin
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
    begin
      case playfield[tel2, tel1] of
        1: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), muur.canvas,
              rect(0, 0, 39, 39));
        2: paintbox1.canvas.copyrect(rect((tel2 - 1) * 40, (tel1 - 1) * 40,
            ((tel2 - 1) * 40) + 40, ((tel1 - 1) * 40) + 40), start.canvas,
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

      end;
    end;
end;

procedure TForm1.startClick(Sender: TObject);
begin
  cursor.picture := start.picture;
  selection := 2
end;

procedure TForm1.muurClick(Sender: TObject);
begin
  cursor.picture := muur.picture;
  selection := 1;
end;

procedure TForm1.doosClick(Sender: TObject);
begin
  cursor.picture := doos.picture;
  selection := 3;
end;

procedure TForm1.blokClick(Sender: TObject);
begin
  cursor.picture := blok.picture;
  selection := 4;
end;

procedure TForm1.dooszetterClick(Sender: TObject);
begin
  cursor.picture := dooszetter.picture;
  selection := 5;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  playfield[(x div 40) + 1, (y div 40) + 1] := selection;

  form1.paintbox1paint(nil);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  settingsfile: tinifile;
begin
  settingsfile := tinifile.create('sookoban.ini');
  opendialog1.InitialDir := settingsfile.readstring('Sookoban level editor',
    'openpath', 'c:\');
  savedialog1.initialdir := settingsfile.readstring('Sookoban level editor',
    'savepath', 'c:\');
  settingsfile.free;
  form1.Left := (screen.width div 2) - (form1.width div 2);
  form1.top := (screen.height div 2) - (form1.height div 2);
  doublebuffered := true;
  cursor.picture := muur.picture;
  selection := 1;
end;

procedure TForm1.Saveleve1Click(Sender: TObject);
var
  tel1, tel2, nothing, start, doos, dooszetter: integer;
  maysave: boolean;
  filename: string;
  level: file of integer;
begin
  nothing := 0;
  start := 0;
  doos := 0;
  dooszetter := 0;
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
      case playfield[tel2, tel1] of
        0: inc(nothing);
        2: inc(start);
        3: inc(doos);
        5: inc(dooszetter);
      end;
  maysave := true;
  if nothing > 0 then
  begin
    application.messagebox('Error: There are still empty spaces!', 'Save Error',
      MB_OK);
    maysave := false;
  end;
  if start <> 1 then
  begin
    application.messagebox('Error: No start position set or too many set!',
      'Save Error', MB_OK);
    maysave := false;
  end;
  if doos <> dooszetter then
  begin
    application.messagebox('Error: Number of boxes are not equal to number of places where boxes need to come', 'Save Error', MB_OK);
    maysave := false;
  end;
  if (doos = 0) or (dooszetter = 0) then
  begin
    application.messagebox('Error: There must be at least one box and one place where a box need to come', 'Save Error', MB_OK);
    maysave := false;
  end;

  if maysave then
    if savedialog1.execute then
    begin
      savedialog1.InitialDir := getpaddir(savedialog1.filename);
      filename := savedialog1.filename;
      if pos('.lev', filename) = 0 then
        filename := filename + '.lev';
      assignfile(level, filename);
      rewrite(level);
      for tel1 := 1 to 10 do
        for tel2 := 1 to 10 do
          write(level, playfield[tel2, tel1]);
      closefile(level);
    end;
end;

procedure TForm1.Openlevel1Click(Sender: TObject);
var
  tel1, tel2, buf: integer;
  level: file of integer;
begin
  if opendialog1.execute then
  begin
    opendialog1.initialdir := getpaddir(opendialog1.filename);
    assignfile(level, opendialog1.filename);
    reset(level);
    for tel1 := 1 to 10 do
      for tel2 := 1 to 10 do
      begin
        read(level, buf);
        playfield[tel2, tel1] := buf;
      end;
    closefile(level);
    paintbox1paint(nil);
  end;
end;

procedure TForm1.Newlevel1Click(Sender: TObject);
var
  tel1, tel2: integer;
begin
  for tel1 := 1 to 10 do
    for tel2 := 1 to 10 do
      playfield[tel2, tel1] := 0;
  paintbox1.visible := false;
  paintbox1.visible := true;
end;

procedure TForm1.About1Click(Sender: TObject);
begin
  aboutbox.showmodal;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  settingsfile: tinifile;
begin
  settingsfile := tinifile.create(ExtractFilePath(paramstr(0)) +
    'sookoban.ini');
  settingsfile.writestring('Sookoban level editor', 'openpath',
    opendialog1.InitialDir);
  settingsfile.writestring('Sookoban level editor', 'savepath',
    savedialog1.initialdir);
  settingsfile.free;
end;

end.

