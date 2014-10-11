unit cursor;
interface
type kind=(on,off,upsmall,dnsmall,fullblink,uphalfblink,dnhalfblink);

procedure SetCursor(NewCursor : word);
procedure makecursor(t:kind);

implementation
uses dos;
var m:word;


procedure SetCursor(NewCursor : word);
var
  Reg : Registers;
begin
  with Reg do
  begin
    AH := 1;
    BH := 0;
    CX := NewCursor;{ ch:=hi(newcursor);cl:=lo(newcursor);}
    Intr($10, Reg); {eg. $0103= $01(hi) $03(lo) }
                    {eg. $0f0a= $0f(hi) $0a(lo) }
                    { ch tells the upper part of cursor line}
                    { cl tells the lower part of cursor line}
  end;
end;
procedure makecursor(t:kind);
var newc:word;
begin
    case t of
    on         :newc:=$0607;
    off        :newc:=$2020;
    upsmall    :newc:=$0000;
    dnsmall    :newc:=$1919;
    fullblink  :newc:=$0019;
    uphalfblink:newc:=$0003;
    dnhalfblink:newc:=$0519;
    else newc:=$0607;
    end;
   setcursor(newc);
end;
end.