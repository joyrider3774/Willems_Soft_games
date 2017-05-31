unit FrmAbout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Taboutbox = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button1: TButton;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  aboutbox: Taboutbox;

implementation

{$R *.DFM}

procedure Taboutbox.Button1Click(Sender: TObject);
begin
modalresult := mrok;
end;

procedure Taboutbox.FormCreate(Sender: TObject);
begin
aboutbox.Left := (screen.width div 2) - (aboutbox.width div 2);
aboutbox.top :=  (screen.height div 2) - (aboutbox.height div 2);
end;

end.
