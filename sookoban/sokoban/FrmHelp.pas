unit FrmHelp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Thowtoplay = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  howtoplay: Thowtoplay;

implementation

{$R *.DFM}


procedure Thowtoplay.Button1Click(Sender: TObject);
begin
modalresult := MROK;
end;

procedure Thowtoplay.FormCreate(Sender: TObject);
begin
howtoplay.Left := (screen.width div 2) - (howtoplay.width div 2);
howtoplay.top :=  (screen.height div 2) - (howtoplay.height div 2);

end;

end.
