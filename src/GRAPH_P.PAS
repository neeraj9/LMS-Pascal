program graph_plotter(input,output);
uses crt,graph;
const
   conversion=50;
   smallest_value=1/conversion;
type
  display_record=record
                    x,y,xi,yi:integer;
                    total:integer;
                    a:array [1..9] of string;
                    current:integer;
                    end;
     KEYTYPE=(ENTER,TAB,ALPHABETS,NUMBERS,ESC,BKSPACE,SPACE,DEL,
              RIGHT,LEFT,UP,DOWN,ENDKEY,HOME,PGDN,PGUP,F1,F2,F3,OTHER);

var
 centerx,centery:integer;
  d:char;
 minx,maxx:real;
function tan(x:real):real;
begin
 tan:=sin(x)/cos(x);
end;

FUNCTION CODES(D:CHAR):KEYTYPE;
BEGIN
     CASE D OF
       #13:CODES:=ENTER;
       #27:CODES:=ESC;
       #8 :CODES:=BKSPACE;
       #9 :CODES:=TAB;
       #32:CODES:=SPACE;
 'A'..'Z',
 'a'..'z' :CODES:=ALPHABETS;
  '0'..'9':CODES:=NUMBERS;
       #0 :BEGIN  D:=READKEY;
               CASE D OF
       #77:CODES:=RIGHT;
       #75:CODES:=LEFT;
       #80:CODES:=DOWN;
       #72:CODES:=UP;
       #59:CODES:=F1;
       #60:CODES:=F2;
       #61:CODES:=F3;
       #79:CODES:=ENDKEY;
       #81:CODES:=PGDN;
       #71:CODES:=HOME;
       #73:CODES:=PGUP;
       #83:CODES:=DEL;
                END;
           END;
     ELSE
      CODES:=OTHER;
     END;  { CASE }
END;


function cot(x:real):real;
begin
 cot:=cos(x)/sin(x);
end;
function sec(x:real):real;
begin
 sec:=1/cos(x);
end;
function cosec(x:real):real;
begin
 cosec:=1/sin(x);
end;

procedure initialize;
var
 grDriver: Integer;
 grMode: Integer;
 ErrCode: Integer;
begin
 grDriver := Detect;
 InitGraph(grDriver, grMode,'c:\tp\bgi');
 ErrCode := GraphResult;
 if ErrCode <> grOk then
   begin
   Writeln('Graphics error:', GraphErrorMsg(ErrCode));
   halt(1);
   end;
end;
PROCEDURE LOADFONT(FILENAME:STRING);
 VAR
  FONTFILE:FILE;
  FONTPOINTER:POINTER;
 BEGIN
  ASSIGN(FONTFILE,FILENAME);
  RESET(FONTFILE,1);
  GETMEM(FONTPOINTER,FILESIZE(FONTFILE));
  BLOCKREAD(FONTFILE,FONTPOINTER^,FILESIZE(FONTFILE));
  CLOSE(FONTFILE);
  IF REGISTERBGIFONT(FONTPOINTER)<0 THEN
  BEGIN
   WRITELN('ERROR IN REGESTERING FONT:',GRAPHERRORMSG(GRAPHRESULT));
   HALT(1);
   END;
  END;

procedure uparrow(var r:display_record);
begin
  with r do
  begin
      setfillstyle(solidfill,white);
        {bar(x+1,y+current,x+(xi-x)-1,y+current);}
   bar(x+4,y+4+(current*textheight('1'))-textheight('1'),xi-5,y+current*textheight('1')+5);
        setcolor(black);
        {}
        moveto(x+10,y+current*textheight('1'));
        outtext(a[current]);
        if current>1 then  current:=current-1
         else
        if current=1 then
           current:=total;
       setfillstyle(solidfill,black);
        {bar(x+1,y+current,x+(xi-x)-1,y+current);}
   bar(x+4,y+4+(current*textheight('1'))-textheight('1'),xi-5,y+current*textheight('1')+5);
       { WINDOW(X+1,Y+1,XI-1,YI-1);}
        setcolor(white);
        moveto(x+10,y+current*textheight('1'));
        outtext(a[current]);
  end;  { with }
end;
procedure downarrow(var r:display_record);
begin
  with r do
  begin
       setfillstyle(solidfill,white);
        {bar(x+1,y+current,x+(xi-x)-1,y+current);}
   bar(x+4,y+4+(current*textheight('1'))-textheight('1'),xi-5,y+current*textheight('1')+5);
        setcolor(black);
        {}
        moveto(x+10,y+current*textheight('1'));
        outtext(a[current]);
        if current<total then  current:=current+1
         else
        if current=total then
           current:=1;
       setfillstyle(solidfill,black);
        {bar(x+1,y+current,x+(xi-x)-1,y+current);}
   bar(x+4,y+4+(current*textheight('1'))-textheight('1'),xi-5,y+current*textheight('1')+5);
       { WINDOW(X+1,Y+1,XI-1,YI-1);}
        setcolor(white);
        moveto(x+10,y+current*textheight('1'));
        outtext(a[current]);
  end;  { with }
end;


procedure drawbar(var  r:display_record);
var
     l,k,i:integer;
begin
  with r do
begin
     settextstyle(triplexfont,horizdir,2);
     setlinestyle(solidln,0,normwidth);

     settextjustify(lefttext,bottomtext);
     setfillstyle(solidfill,white);
     bar(x,y,xi,yi);
     setcolor(black);
     setlinestyle(solidln,0,normwidth);
      rectangle(x+2,y+2,xi-2,yi-2);
      i:=0;
   while i<total do
   begin
      i:=i+1;
      moveto(x+10,y+i*textheight('1'));outtext(a[i]);
   end;

   if current<>0 then
   begin
       setfillstyle(solidfill,black);
   bar(x+4,y+4+(current*textheight('1'))-textheight('1'),xi-5,y+current*textheight('1')+5);
   setcolor(white);
   moveto(x+10,y+current*textheight('1'));
   outtext(a[current]);
   end;
end; { WITH }
end;


{****************************************}
procedure mark_scale;
var
  i,x,y,xi,yi,k:integer;
  st:string;
begin
  loadfont('c:\tp\bgi\litt.chr');
  loadfont('c:\tp\bgi\trip.chr');
  centerx:=getmaxx div 2;
  centery:=getmaxy div 2;
  setcolor(white);
  setlinestyle(solidln,0,thickwidth);
  line(0,centery,getmaxx,centery);
  line(centerx,0,centerx,getmaxy);
        x:=centerx;
        y:=centery;
  settextstyle(smallfont,horizdir,1);
  setlinestyle(solidln,0,normwidth);
  settextjustify(centertext,toptext);
  moveto(x+13,y+10);outtext('0');
  i:=0;
  {plot x axis}
  xi:=x;
  while (i<>5) do
  begin
     i:=i+1; x:=x+(getmaxx div 10);
             xi:=xi-(getmaxx div 10);
     line(x,y-12,x,y+12);   moveto(x,y+12);  str(i,st);   outtext(st);
     line(xi,y-12,xi,y+12); moveto(xi,y+12); k:=-1*i;str(k,st); outtext(st);
  end;
  i:=0;
  x:=centerx;
  {plot y axis}
  yi:=y;
  while (i<>6) do
  begin
     i:=i+1; y:=y-(getmaxy div 10);
             yi:=yi+(getmaxy div 10);
     line(x-12,y,x+12,y);   moveto(x+18,y-9);  str(i,st);   outtext(st);
     line(x-12,yi,x+12,yi); moveto(x+18,yi-20); k:=-1*i;str(k,st); outtext(st);
  end;
end;
{*****************************************}


procedure mark_scale_1;
var
  i,x,y,xi,yi,k:integer;
  st:string;
begin


  setcolor(white);
  setlinestyle(solidln,0,thickwidth);
  line(0,centery,getmaxx,centery);
  line(centerx,0,centerx,getmaxy);
        x:=centerx;
        y:=centery;
  settextstyle(smallfont,horizdir,4);
  setlinestyle(solidln,0,normwidth);
  settextjustify(centertext,toptext);
  moveto(x+10,y);outtext('0');
  i:=0;
  {plot x axis}
  xi:=x;
  while (x+conversion)<= getmaxx do
  begin
     i:=i+1; x:=x+conversion;
             xi:=xi-conversion;
     line(x,y-5,x,y+5);   moveto(x,y+5);  str(i,st);   outtext(st);
     line(xi,y-5,xi,y+5); moveto(xi,y+5); k:=-1*i;str(k,st); outtext(st);
  end;
  i:=0;
  x:=centerx;
  {plot y axis}
  settextjustify(toptext,centertext);
  y:=centery;
  yi:=y;
  while (y+conversion)<=getmaxy do
  begin
     i:=i+1; y:=y-conversion;
             yi:=yi+conversion;
     line(x-5,y,x+5,y);   moveto(x+20,y);  str(i,st);   outtext(st);
     line(x-5,yi,x+5,yi); moveto(x+20,yi); k:=-1*i;str(k,st); outtext(st);
  end;
  maxx:=centerx/conversion;
  minx:=-1*maxx;
end;
procedure plot(x,y:real;color:word);
var
   xi,yi:longint;
begin
     xi:=round(x*conversion)+centerx;
     if (y<32767)and (y>-32768) then
     begin yi:=centery-round(y*conversion);
     putpixel(xi,yi,color);
     end;
end;


procedure line_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=x;
       plot(x,y,white);
     end;
end;

procedure sine_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=sin(x);
       plot(x,y,white);
     end;
end;

procedure cossine_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=cos(x);
       plot(x,y,white);
     end;
end;

procedure tan_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=tan(x);
       plot(x,y,white);
     end;
end;
procedure cot_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=cot(x);
       plot(x,y,white);
     end;
end;
procedure sec_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=sec(x);
       plot(x,y,white);
     end;
end;
procedure cosec_plot;
var x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
       x:=x+smallest_value;
       y:=cosec(x);
       plot(x,y,white);
     end;
end;


procedure circle_plot(radius:real);
var z,x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
     x:=x+smallest_value;
     z:=sqr(radius)-sqr(x);
     if z>=0 then
     begin
       y:=sqrt(z);
       plot(x,y,white);
       y:=-1*y;
       plot(x,y,white);
      end;
     end;
end;
procedure ellipse_plot(xradius,yradius:real);
var z,x,y:real;
begin
     x:=minx-smallest_value;
     while  (x<=maxx) do
     begin
     x:=x+smallest_value;
     z:=sqr(yradius)*(1-sqr(x/xradius));
     if z>=0 then
     begin
       y:=sqrt(z);
       plot(x,y,white);
       y:=-1*y;
       plot(x,y,white);
      end;
     end;
end;

procedure menue;
var
choice:keytype;
r:display_record;
begin
  loadfont('c:\tp\bgi\litt.chr');
  loadfont('c:\tp\bgi\trip.chr');

  settextstyle(triplexfont,horizdir,2);
  setlinestyle(solidln,0,normwidth);
  settextjustify(lefttext,toptext);
  with r do
  begin
  a[1]:='Plot Circle';
  a[2]:='Plot Line';
  a[3]:='Plot Ellipse';
  a[4]:='Plot Sine Curve';
  a[5]:='Plot Cos Curve';
  a[6]:='Plot Tan Curve';
  a[7]:='Plot Cot Curve';
  a[8]:='Plot Sec Curve';
  a[9]:='Plot cosec Curve';
  total:=9;
  current:=1;
  x:=12;
  y:=12;
  xi:=x+18+textwidth(a[9]);
  yi:=y+8+total*textheight('1');
  end;
  drawbar(r);

          repeat
            d:=readkey;
            choice:=codes(d);
          WITH r DO
          BEGIN
             CASE CHOICE OF
             UP    :UPARROW(r);
             DOWN  :DOWNARROW(r);
             ESC   :{exit};
             ENTER :BEGIN
                    cleardevice;
                    mark_scale_1;
                    case current of
                    1:Circle_plot(5.00);
                    2:Line_plot;
                    3:Ellipse_plot(5.00,3.00);
                    4:Sine_plot;
                    5:Cossine_plot;
                    6:tan_plot;
                    7:cot_plot;
                    8:Sec_plot;
                    9:cosec_plot;
                   end;
                   d:=readkey;
                   cleardevice;
                   drawbar(r);
                   end;
             end;
          end;
  until choice=esc;
end;

begin

initialize;
  loadfont('c:\tp\bgi\litt.chr');
  loadfont('c:\tp\bgi\trip.chr');
  centerx:=getmaxx div 2;
  centery:=getmaxy div 2;
  maxx:=centerx/conversion;
  minx:=-1*maxx;
menue;
{mark_scale_1;}
{circle_plot(5.00);}
{line_plot;}
{ellipse_plot(3.00,6.00);}
{sine_plot;}
{cossine_plot;}
{tan_plot;}
{cot_plot;}
{sec_plot;}
{cosec_plot;}
closegraph;
end.