var
  x:real;
  n:integer;
function power(x:real;n:integer):real;
begin
  if x=0 then
  power:=0.0 else
  if n=0 then
  power:=1.0 else
  if n>0 then
   power:=x*power(x,n-1) else
   if n<0 then
   power:=power(x,n+1)/x;
end;
begin
x:=0;
 while x<>999 do
 begin
 write('x :');readln(x);
 write('n :');readln(n);
 write(power(x,n):30:12);
 readln;
 end;
end.