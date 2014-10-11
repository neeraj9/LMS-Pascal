uses Dos;
var
 DirInfo: SearchRec;
procedure modify(t:string);
var
 r,f:file of byte;
 P: PathStr;
 D: DirStr;
 N: NameStr;
 E: ExtStr;
 b1,b2:byte;
begin
 FSplit(t, D, N, E);
 p:= D+N+'.scr';
 assign(r,p);
 rewrite(r);
 assign(f,t);
 reset(f);
 while not eof(f) do
 begin
     read(f,b1,b2);
     write(r,b1);
 end;
 close(f);
 close(r);
end;
begin
 FindFirst('*.SCN', Archive, DirInfo); { Same as DIR *.PAS }
 while DosError = 0 do
 begin
   modify(DirInfo.name);
   FindNext(DirInfo);
 end;
end.