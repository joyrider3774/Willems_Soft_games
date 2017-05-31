{*
***************************************************
*          Puzzle shuffle about box code          *
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
*    Willems Davy                                 *
*    Http://www.willemssoft.be                    *
*                                                 *
* Using:                                          *
*   -Borland Delphi 6                             *
*   -Jasc's Paint Shop Pro 7                      *
***************************************************
*}
unit FrmAbout;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, shellapi;

type
  TAboutBox = class(TForm)
    Aboutboximg: TImage;
    AboutboxText: TImage;
    TextMoveTimer: TTimer;
    procedure TextMoveTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AboutboxTextClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;
  textposY: integer; //houdt de positie van de tekst bij

  //tekst die zal gescorlled worden in about venster
const
  Nrlines = 22; //aantal lijnen tekst
  Abouttext: array[0..Nrlines] of string = ('About Puzzle Shuffle',
    'Puzzle Suffle is freeware wich ',
    'means that you can not ask any',
    'money for it, you can not ',
    'modify any part from it and you',
    'may distribute it around freely',
    'in any way you like!',
    '',
    'If you put this software on a',
    'site you MUST put a link back',
    'to the Willems Soft Homepage',
    '(Http://www.willemssoft.be)',
    '',
    'If you like this game please',
    'come to the Willems Soft site',
    'and press on one of the banners',
    'so i can pay for my webspace',
    'and keep my software free!',
    'You can also help me by putting',
    'a link to my site on your site!',
    '',
    '   http://www.willemssoft.be',
    '   willems.davy@willemssoft.be');
implementation

{$R *.DFM}

//de timer functie die na bepaalde tijd telkens de tekst
//wat naar boven schuift

procedure TAboutBox.TextMoveTimerTimer(Sender: TObject);
var
  tel: integer;
begin
  with aboutboxtext.canvas do
  begin
    copyrect(rect(0, 0, 190, 169), aboutboximg.canvas, rect(32, 16, 222, 185));
    font.Size := 12;
    font.style := [fsbold, fsUnderline];
    TextOut(7, textposy, abouttext[0]);
    font.size := 10;
    font.style := [];
    for tel := 1 to Nrlines do
    begin
      TextOut(0, textposy + 15 + tel * 14, abouttext[tel]);
    end;
  end;
  textposy := textposy - 1;
  if textposy = round(-14.87 * Nrlines) then
    textposy := 169;
end;

//instellingen bij aanmaak formulier

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  doublebuffered := true; // nodig om 'flickering' tege te gaan
  aboutboxtext.Canvas.brush.style := bsClear;
    // transparante achtergrond voor tekst
end;

//timer wordt ingeschakeld bij het zien van het venster
//tekst wordt gezet en de startY positie wordt ook ingesteld

procedure TAboutBox.FormShow(Sender: TObject);
begin
  aboutboxtext.canvas.copyrect(rect(0, 0, 185, 169), aboutboximg.canvas,
    rect(32, 16, 217, 185));
  textposy := 169; // start positie van de tekst buiten het zichtbare veld !!
  textMoveTimer.enabled := true;
end;

//als ze in de about box duwen worden de mensen naar men site geleid.
//shellexecute is API functie voor normaal openen van programma's
//Maar je kan er dus ook sites als ook normale files mee openen
//als ze maar gelinkt zijn (http://wwww.......) altijd gelinkt

procedure TAboutBox.AboutboxTextClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open', 'Http://www.willemssoft.be', nil,
    nil, SW_SHOWMAXIMIZED);
end;

end.

