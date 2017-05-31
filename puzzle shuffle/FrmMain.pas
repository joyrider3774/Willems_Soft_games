{*
***************************************************
*          Puzzle shuffle main code               *
***************************************************
* Copyright Willems Soft 2000-2001                *
*                                                 *
* Legal notices:                                  *
*   -You may modify anything in the code AS LONG  *
*    AS YOU DON'T REBUILD IT AND DISTRIBUTE IT    *
*    AROUND UNDER YOUR NAME!                      *
*   -You may use parts of this code for your game *
*    AS LONG AS YOU CREDIT ME IN YOUR GAME WITH A *
*    LINK TO MY SITE !                            *
*   -All images are copyrighted and may NOT be    *
*    used somewhere else!                         *
*                                                 *
* Created by:                                     *
*   -Willems Davy                                 *
*   -Http://www.willemssoft.be                    *
*                                                 *
* Using:                                          *
*   -Borland Delphi 6                             *
*   -Jasc's Paint Shop Pro 7                      *
***************************************************
*}
unit FrmMain;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, Dialogs,
  ImgList, Menus, ShellApi, jpeg, ExtCtrls, ExtDlgs, Classes, Graphics,
  System.ImageList;

const
  PartHeight = 100; //height van 1 stukje puzzel
  PartWidth = 100; //width van 1 stukje puzzle
  ImageWidth = 400; //width van de tekening
  ImageHeight = 400; //height van de tekening
  PreviewWidth = 150; //width van de preview image
  PreviewHeight = 150; //height van de preview image
  NrHorizontal = 4; //hoeveel puzzel stukjes horizontaal
  NrVertical = 4; //hoeveel verticaal
  MaxShuffling = 50; //aantal keer dat stukjes door verzet worden
  //voor je speelt
type
  TFrm_Puzzle_Shuffle = class(TForm)
    PreviewImg: TImage;
    OpenPictureDialog1: TOpenPictureDialog;
    ShuffleImg: TImage;
    ShufflePartImgLst: TImageList;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    LoadBitmap1: TMenuItem;
    ShufflePieces1: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    BackgroundImg: TImage;
    ShuffleinImg: TImage;
    ShuffleButtonImg: TImage;
    ShuffleOutImg: TImage;
    LoadButtonImg: TImage;
    LoadInImg: TImage;
    LoadOutImg: TImage;
    EmptyAboutImg: TImage;
    Showhelpfile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShuffleImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadBitmap1Click(Sender: TObject);
    procedure ShufflePieces1Click(Sender: TObject);
    procedure LoadButtonImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure LoadButtonImgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ShuffleButtonImgMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShuffleButtonImgMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EmptyAboutImgClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Showhelpfile1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Loadedimage: Tbitmap;
    Puzzle: array[0..NrHorizontal - 1, 0..NrVertical - 1] of integer;
    GameStarted, Pictureloaded: Boolean;
    function Won: boolean;
    procedure DoShuffling;
    procedure ShufflePuzzle;
    procedure initializePuzzle;
    procedure DrawPuzzle();
    procedure CreateShuffleParts();
    procedure LoadBitmap();
    { Public declarations }
  end;

var
  Frm_Puzzle_Shuffle: TFrm_Puzzle_Shuffle;

implementation

uses frmabout;

{$R *.DFM}

//Functie die gaat controleren of de puzzel is opgelost

function TFrm_Puzzle_Shuffle.Won: boolean;
var
  x, y: integer;
  buf: boolean;
begin
  buf := true;
  for y := 0 to NrVertical - 1 do
    for x := 0 to NrHorizontal - 1 do
      buf := buf and (puzzle[x, y] = (y * 4) + x);
  Won := buf;
end;

//procedure die de procedure voor de puzzel stukjes
//te mengen bij aanvang van het spel zal oproepe en
//het spel initializeren en starten
//als er een foto geladen is en het spel gestart is
//anders geeft hij de nodige berichten

procedure TFrm_Puzzle_Shuffle.DoShuffling;
begin
  if PictureLoaded then
  begin
    if not gamestarted then
    begin
      gamestarted := true;
      initializePuzzle;
      shufflePuzzle;
    end
    else if application.messagebox('You have already Shuffled the puzzle,' +
      chr(13) + 'Shuffling the puzzle again, will restart the game.' + chr(13) +
      'Are you sure you wish to shuffle the puzzle?', 'Confirmation', MB_YESNO +
      MB_ICONQUESTION) = IDYES then
    begin
      initializePuzzle;
      shufflePuzzle;
    end;
  end
  else
  begin
    Application.messagebox('There is no image loaded,' + chr(13) +
      'before you can shuffle the puzzle you have to load an image.', 'Warning',
      MB_OK + MB_ICONEXCLAMATION);
    loadbitmap();
  end;
end;

//procedure voor de stukjes te mengen in het begin van het spel

procedure TFrm_Puzzle_Shuffle.ShufflePuzzle;
var
  x, y, px, py, tel, temp: integer;
begin
  x := 3;
  Y := 3;
  px := 3;
  py := 3;
  tel := 0;
  while (tel < MaxShuffling) do
  begin
    if random(2) = 0 then
    begin
      if random(2) = 0 then
      begin
        if (X - 1 >= 0) and (X - 1 <> px) then
        begin
          px := x;
          py := y;
          temp := Puzzle[x - 1, y];
          Puzzle[x, y] := temp;
          x := X - 1;
          Puzzle[x, y] := 15;
          DrawPuzzle;
          tel := tel + 1;
          sleep(50);
        end;
      end
      else
      begin
        if (X + 1 < NrHorizontal) and (X + 1 <> px) then
        begin
          px := x;
          py := y;
          temp := Puzzle[x + 1, y];
          Puzzle[x, y] := temp;
          x := X + 1;
          Puzzle[x, y] := 15;
          DrawPuzzle;
          tel := tel + 1;
          sleep(50);
        end;
      end;
    end
    else
    begin
      if random(2) = 0 then
      begin
        if (Y - 1 >= 0) and (Y - 1 <> py) then
        begin
          px := x;
          py := y;
          temp := Puzzle[x, y - 1];
          Puzzle[x, y] := temp;
          Y := Y - 1;
          Puzzle[x, y] := 15;
          DrawPuzzle;
          tel := tel + 1;
          sleep(50);
        end;
      end
      else
      begin
        if (Y + 1 < NrVertical) and (Y + 1 <> py) then
        begin
          px := x;
          py := y;
          temp := Puzzle[x, y + 1];
          Puzzle[x, y] := temp;
          Y := Y + 1;
          Puzzle[x, y] := 15;
          DrawPuzzle;
          tel := tel + 1;
          sleep(50);
        end;
      end;
    end;
  end;
end;

//procedure voor het initializeren van het spel (array krijgt de juiste waarden)

procedure TFrm_Puzzle_Shuffle.initializePuzzle;
var
  x, y: integer;
begin
  for y := 0 to NrVertical - 1 do
    for x := 0 to NrHorizontal - 1 do
      Puzzle[x, y] := (y * 4) + x;
end;

//procedure om de puzzel te tekenen

procedure TFrm_Puzzle_Shuffle.DrawPuzzle();
var
  x, y: integer;
begin
  for y := 0 to 3 do
    for x := 0 to 3 do
    begin
      if Puzzle[x, y] <> 15 then
        ShufflePartImgLst.draw(ShuffleImg.canvas, x * PartWidth, y * PartHeight,
          puzzle[x, y])
      else
        shuffleimg.canvas.Rectangle(x * PartWidth, Y * PartWidth, (x + 1) *
          PartWidth, (Y + 1) * PartWidth);
    end;
  ShuffleImg.Refresh;
end;

//procedure die van een geladen image de puzzelstukjes zal maken
//en in een image list zal plaatsen

procedure TFrm_Puzzle_Shuffle.CreateShuffleParts();
var
  x, y: integer;
  tempBitmap: Tbitmap;
begin
  ShufflePartImgLst.clear;
  TempBitmap := Tbitmap.create;
  // tempBitmap.PixelFormat := loadedimage.PixelFormat;
  TempBitmap.Width := 100;
  TempBitmap.Height := 100;
  for y := 0 to 3 do
    for x := 0 to 3 do
    begin
      TempBitmap.Canvas.CopyRect(rect(0, 0, PartWidth, PartHeight),
        LoadedImage.Canvas, rect(x * PartWidth, y * Partheight, (x + 1) *
        PartWidth, (y + 1) * PartHeight));
      ShufflePartImgLst.add(TempBitmap, nil);
    end;
  tempBitmap.free;
end;

//Deze procedure zal de image laden en de preview tekenen,

procedure TFrm_Puzzle_Shuffle.LoadBitmap();
var
  TempBitmap: Tbitmap;
  TempJpg: Tjpegimage;
  TempWmf: Tmetafile;
begin
  if openpicturedialog1.execute then
  begin
    TempBitmap := Tbitmap.Create();
    if uppercase(extractfileext(openpicturedialog1.FileName)) = '.BMP' then
    begin
      TempBitmap.LoadFromFile(openpicturedialog1.filename);
    end
    else if uppercase(extractfileext(openpicturedialog1.FileName)) = '.JPG' then
    begin
      TempJpg := TJpegimage.Create;
      TempJpg.LoadFromFile(openpicturedialog1.filename);
      TempBitmap.Assign(TempJpg);
      TempJpg.Free;
    end
    else if (uppercase(extractfileext(openpicturedialog1.FileName)) = '.EMF') or
      (uppercase(extractfileext(openpicturedialog1.FileName)) = '.WMF') then
    begin
      TempWmf := TMetaFile.Create;
      TempWmf.LoadFromFile(openpicturedialog1.filename);
      TempBitmap.Width := TempWmf.width;
      TempBitmap.Height := TempWmf.height;
      TempBitmap.canvas.stretchdraw(rect(0, 0, TempWmf.width, TempWmf.height +
        1), TempWmf);
      TempWmf.Free;
    end
    else
    begin
      application.messagebox('Only "JPG", "BMP", "EMF" or "WMF" images are supported!', 'Error', MB_OK + MB_ICONEXCLAMATION);
      exit;
    end;
    Loadedimage.canvas.stretchdraw(rect(0, 0, imagewidth, imageheight),
      TempBitmap);
    TempBitmap.free;
    previewImg.canvas.StretchDraw(rect(0, 0, PreviewWidth, PreviewHeight),
      loadedimage);
    createShuffleParts();
    DrawPuzzle;
    PictureLoaded := true;
  end;
end;

//Wat standaardwaarden ingeven bij het laden van het spel
//(eigenlijk de form)
//Bitmaps voor de puzzel worden aangemaakt puzzel geinitializeerd
//etc

procedure TFrm_Puzzle_Shuffle.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  Loadedimage := Tbitmap.create();
  Loadedimage.Width := imagewidth;
  Loadedimage.Height := imageheight;
  InitializePuzzle;
  gamestarted := false;
  PictureLoaded := false;
  randomize;
end;

//De aangemaakte bitmaps worden vrijgemaakt

procedure TFrm_Puzzle_Shuffle.FormDestroy(Sender: TObject);
begin
  Loadedimage.free;
end;

//procedure die de waarden in de puzzle array zal aanpassen
//aan de hand van de coordinaten van de muis, waar deze in geduwd
//werd. Nadien wordt de puzzel hertekend

procedure TFrm_Puzzle_Shuffle.ShuffleImgMouseDown(Sender: TObject; Button:
  TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Xpos, Ypos: integer;
begin
  if Gamestarted and PictureLoaded then
  begin
    Xpos := X div 100;
    Ypos := Y div 100;
    if Puzzle[xpos, ypos] <> 15 then
    begin
      if ((xpos + 1) < NrHorizontal) and (Puzzle[xpos + 1, ypos] = 15) then
      begin
        Puzzle[xpos + 1, ypos] := Puzzle[xpos, ypos];
        Puzzle[xpos, ypos] := 15;
      end
      else if ((xpos - 1) >= 0) and (Puzzle[xpos - 1, ypos] = 15) then
      begin
        Puzzle[xpos - 1, ypos] := Puzzle[xpos, ypos];
        Puzzle[xpos, ypos] := 15;
      end
      else if ((ypos + 1) < NrVertical) and (Puzzle[xpos, ypos + 1] = 15) then
      begin
        Puzzle[xpos, ypos + 1] := Puzzle[xpos, ypos];
        Puzzle[xpos, ypos] := 15;
      end
      else if ((ypos - 1) >= 0) and (Puzzle[xpos, ypos - 1] = 15) then
      begin
        Puzzle[xpos, ypos - 1] := Puzzle[xpos, ypos];
        Puzzle[xpos, ypos] := 15;
      end;
      DrawPuzzle;
    end;
    if won then
      if Application.messagebox('Congratulations,' + chr(13) +
        'You have Solved the Puzzle!' + chr(13) +
        'Do you want to shuffle the puzzle again ?', 'Congratulations', MB_YESNO +
        MB_ICONQUESTION) = IDYES then
      begin
        application.processmessages;
        ShufflePuzzle
      end
      else
        gamestarted := false;
  end;
end;

//wat er gebeurd als je op de loadbutton (eigenlijk image) duwd

procedure TFrm_Puzzle_Shuffle.LoadBitmap1Click(Sender: TObject);
begin
  loadbitmap();
end;

//wat er gebeurd als je op de shuffle = mengen butoon (eigenlijk image) duwd

procedure TFrm_Puzzle_Shuffle.ShufflePieces1Click(Sender: TObject);
begin
  Doshuffling;
end;

//Procedure die zorgt voor het effect van de ingeduwd button
//de foto wordt gewoon veranderd met de foto van een ingeduwde knop

procedure TFrm_Puzzle_Shuffle.LoadButtonImgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
    LoadButtonImg.Canvas.copyrect(rect(0, 0, 166, 44), LoadinImg.canvas, rect(0,
      0, 166, 44));
end;

//Zelfde als hierboven maar voor uitgeduwde button (as muis knop gelost wordt)

procedure TFrm_Puzzle_Shuffle.LoadButtonImgMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
  begin
    LoadButtonImg.Canvas.copyrect(rect(0, 0, 166, 44), LoadOutImg.canvas,
      rect(0, 0, 166, 44));
    application.processmessages; // nodig anders button nie goe getekend
    LoadBitmap;
  end;
end;

//Procedure die zorgt voor het effect van de ingeduwd button
//de foto wordt gewoon veranderd met de foto van een ingeduwde knop

procedure TFrm_Puzzle_Shuffle.ShuffleButtonImgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
    ShuffleButtonImg.canvas.copyrect(rect(0, 0, 165, 45), ShuffleInImg.Canvas,
      rect(0, 0, 165, 45));
end;

//Zelfde als hierboven maar voor uitgeduwde button (as muis knop gelost wordt)

procedure TFrm_Puzzle_Shuffle.ShuffleButtonImgMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
  begin
    ShuffleButtonImg.canvas.copyrect(rect(0, 0, 165, 45), ShuffleOutImg.Canvas,
      rect(0, 0, 165, 45));
    application.processmessages; // nodig anders button nie goe getekend
    Doshuffling;
  end;
end;

//Klein imageke (die willemssoft) als iemand er per toeval op klikt
//worden ze naar men site gestuurd ! (voor wat hits te krijgen)

procedure TFrm_Puzzle_Shuffle.EmptyAboutImgClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'Http://www.willemssoft.be', nil,
    nil, SW_SHOWMAXIMIZED);
end;

//Als je exit kiest in menu wordt het spel afgesloten

procedure TFrm_Puzzle_Shuffle.Exit1Click(Sender: TObject);
begin
  application.terminate;
end;

//als je about kiest in het menu wordt het about venster modaal getoond

procedure TFrm_Puzzle_Shuffle.About1Click(Sender: TObject);
begin
  aboutbox.showmodal;
end;

//als je help kiest in het menu wordt de help (txt file) getoond
//wordt nog gechecked of deze help wel bestaat !

procedure TFrm_Puzzle_Shuffle.Showhelpfile1Click(Sender: TObject);
begin
  if not fileexists(extractfilepath(application.exename) + 'help.txt') then
    application.messagebox('Error: help.txt was not found,' + chr(13) +
      'the help file can not be displayed!', 'Error', MB_OK + MB_ICONEXCLAMATION)
  else
    ShellExecute(Application.Handle, 'open',
      pchar(extractfilepath(application.exename) + 'help.txt'), nil, nil,
      SW_SHOWNORMAL);
end;

end.

