unit misc;

interface
function getpaddir(s: string): string;
function getpadfilename(s: string): string;
function Exist(FileName: string): boolean;
implementation

function getpaddir(s: string): string;
var
  posi: integer;
  buf: string;
begin
  posi := 0;
  buf := s;
  while pos('\', buf) <> 0 do
  begin
    posi := posi + pos('\', buf);
    delete(buf, 1, pos('\', buf));
  end;
  delete(s, posi, length(s) - posi + 1);
  getpaddir := s + '\';
end;

function getpadfilename(s: string): string;
var
  buf: string;
begin
  buf := s;
  while pos('\', buf) <> 0 do
  begin
    delete(buf, 1, pos('\', buf));
  end;
  getpadfilename := buf;
end;

function Exist(FileName: string): Boolean;

var
  f: file;
begin
{$I-}
  Assignfile(f, FileName);
  Reset(f);
  Closefile(f);
{$I+}
  Exist := (IOResult = 0) and
    (FileName <> '');
end;

end.

