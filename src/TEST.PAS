USES CRT;
VAR
 S:INTEGER;  LST:TEXT;
BEGIN                  CLRSCR;
S:=0;
ASSIGN(LST,'PRN');
REWRITE(LST);
REPEAT
INC(S);
WRITELN(LST,S);
UNTIL KEYPRESSED;
CLOSE(LST);
END.