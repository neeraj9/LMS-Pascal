UNIT U_TOOL;
INTERFACE
TYPE
     KIND_TYPE   =(SINGLE_TYPE,DOUBLE_TYPE);
     ERROR_TYPE  =(RECORD_NOT_FOUND,
                   RECORD_ALREADY_PRESENT,
                   KEY_NOT_APPLICABLE,
                   FILE_IS_EMPTY,
                   DATE_ERROR  );
CONST     DISPLAY_CHAR:ARRAY[KIND_TYPE,1..8]OF CHAR=(
('�','�','�', '�', '�','�',' ',' '),

('�','�','�','�', '�','�',' ',' '));

TYPE
     DISPLAY_RECORD=RECORD
                    X,Y,XI,YI:INTEGER;
                    TOTAL:INTEGER;
                    A:ARRAY [1..8] OF STRING;
                    CURRENT:INTEGER;
                    END;
      DATE_TYPE    =RECORD
                 DATE,MONTH,YEAR:INTEGER;
                 END;
     KEYTYPE=(ENTER,TAB,ALPHABETS,NUMBERS,ESC,BKSPACE,SPACE,DEL,
              RIGHT,LEFT,UP,DOWN,ENDKEY,HOME,PGDN,PGUP,F1,F2,F3,OTHER);
VAR
 SCREEN:POINTER;
PROCEDURE BEEP;
FUNCTION  VALID_DATE(D:DATE_TYPE):BOOLEAN;
FUNCTION  CHECK_DATE(D1,D2:DATE_TYPE;VAR INFO:CHAR):BOOLEAN;
PROCEDURE FIND_DATE(VAR D:DATE_TYPE;NUM:INTEGER);
FUNCTION SAME_STRING(S1,S2:STRING):BOOLEAN;
FUNCTION  ASK(VAR S:STRING;PX,PY,NUM:INTEGER):BOOLEAN;
FUNCTION  DT2ST(D:DATE_TYPE):STRING;
FUNCTION  ST2DT(S:STRING;VAR D:DATE_TYPE):BOOLEAN;
PROCEDURE COPYFILE(SOURCE,TARGET:STRING);
FUNCTION  PRESENT(FNAME:STRING):BOOLEAN;
FUNCTION  READXY(X,Y,XI:INTEGER;VAR ST:STRING):BOOLEAN;
PROCEDURE SAVESCREEN(N:BYTE);
PROCEDURE RESTORESCREEN(N:BYTE);
FUNCTION  UPSTRING(S:STRING):STRING;
PROCEDURE BAR(X,Y,XI,YI:INTEGER;COLOR:WORD);
PROCEDURE IDENTIFICATION;
PROCEDURE BOX(X,Y,XI,YI:INTEGER;KIND:KIND_TYPE);
PROCEDURE UPARROW(VAR R:DISPLAY_RECORD);
PROCEDURE DOWNARROW(VAR R:DISPLAY_RECORD);
PROCEDURE ERASES(X,Y,XI,YI:INTEGER;{H:CHAR}COLOR:WORD);
PROCEDURE DRAWBAR(VAR R:DISPLAY_RECORD);
PROCEDURE PRINT_ERROR(ERROR:ERROR_TYPE);
FUNCTION  CODES(D:CHAR):KEYTYPE;
PROCEDURE ABOUT;

IMPLEMENTATION
USES CRT,CURSOR;
VAR T:TEXT;
    NAME:STRING;
    SCREEN1,SCREEN2,SCREEN3:POINTER;

PROCEDURE BEEP;
BEGIN
   SOUND(1267); DELAY(100);NOSOUND;SOUND(2000);DELAY(80);NOSOUND;
END;

FUNCTION SAME_STRING(S1,S2:STRING):BOOLEAN;
VAR
  SAME:BOOLEAN;
  I:INTEGER;
BEGIN  I:=0;
   SAME:=TRUE; S1:=UPSTRING(S1);
               S2:=UPSTRING(S2);
  WHILE (I<LENGTH(S1))AND (I<LENGTH(S2))AND (SAME) DO
  BEGIN
      I:=I+1;
      SAME:=(S1[I]=S2[I]);
  END;
  SAME_STRING:=SAME;
END;
FUNCTION LEAPYEAR(Y:INTEGER):BOOLEAN;
BEGIN
        LEAPYEAR:=FALSE;
   IF Y MOD 100=0 THEN
     BEGIN
       IF Y MOD 400=0 THEN
       LEAPYEAR:=TRUE;
     END
       ELSE
       IF Y MOD 4=0 THEN
       LEAPYEAR:=TRUE;
END;

FUNCTION VALID_DATE(D:DATE_TYPE):BOOLEAN;

BEGIN
   VALID_DATE:=TRUE;
   IF D.MONTH>12 THEN VALID_DATE:=FALSE    ELSE
   IF D.DATE<1 THEN VALID_DATE:=FALSE      ELSE
   IF D.YEAR<1700 THEN VALID_DATE:=FALSE   ELSE
BEGIN
   CASE D.MONTH OF
 1,3,5,7,8,10,12:IF D.DATE>31 THEN VALID_DATE:=FALSE;
               2:IF LEAPYEAR(D.YEAR) THEN
                 BEGIN IF D.DATE>29 THEN VALID_DATE:=FALSE;  END
                       ELSE  IF D.DATE>28 THEN VALID_DATE:=FALSE;
        4,6,9,11:IF D.DATE>30 THEN VALID_DATE:=FALSE;
        END;     {CASE}
END;{ELSE}
END;{FUNCTION}

FUNCTION CHECK_DATE(D1,D2:DATE_TYPE;VAR INFO:CHAR):BOOLEAN;
BEGIN
      CHECK_DATE:=(D1.DATE=D2.DATE) AND (D1.MONTH=D2.MONTH)
                                    AND (D1.YEAR=D2.YEAR);
   IF D1.YEAR<D2.YEAR THEN INFO:='L' ELSE
   IF D1.YEAR>D2.YEAR THEN INFO:='G' ELSE
   BEGIN
     IF D1.MONTH<D2.MONTH THEN INFO:='L' ELSE
     IF D1.MONTH>D2.MONTH THEN INFO:='G' ELSE
     BEGIN
       IF D1.DATE<D2.DATE THEN INFO:='L' ELSE
       IF D1.DATE>D2.DATE THEN INFO:='G' ELSE
       INFO:='E';
     END;
   END;
END;

PROCEDURE FIND_DATE(VAR D:DATE_TYPE;NUM:INTEGER);
VAR
    DONE:BOOLEAN;
PROCEDURE F_D(VAR D:DATE_TYPE;NUM:INTEGER);
VAR
    R,Q:INTEGER;
BEGIN
    R:=D.DATE; Q:=D.MONTH;
   CASE D.MONTH OF
 1,3,5,7,8,10,12:BEGIN
                   R:=D.DATE+NUM;
                   IF R>31 THEN   BEGIN
                   R:=R-31; Q:=D.MONTH+1;
                   IF Q>12 THEN  BEGIN Q:=1; D.YEAR:=D.YEAR+1; END;
                                  END;
                 END;
              2:BEGIN  R:=D.DATE+NUM;
                       IF LEAPYEAR(D.YEAR) THEN
                       BEGIN IF R>29 THEN
                              BEGIN R:=R-29; Q:=D.MONTH+1; END;
                       END ELSE
                       BEGIN IF R>28 THEN R:=R-28;
                             BEGIN Q:=D.MONTH+1; END;
                       END;
                   END;  {2}
          4,6,9,11:BEGIN R:=D.DATE+NUM;
                         IF R>30 THEN BEGIN  R:=R-30;  Q:=D.MONTH+1;
                    END;
                   END;
        END;     {CASE}
      D.DATE:=R;
      D.MONTH:=Q;

END;{PROCEDURE}

BEGIN {FIND_DATE}

  DONE:=FALSE;

    WHILE (NOT DONE) DO
   BEGIN

    IF NUM>28 THEN  BEGIN NUM:=NUM-28;
     F_D(D,28);
     END
     ELSE BEGIN
             DONE:=TRUE;
             F_D(D,NUM);
          END;
   END;

END;

FUNCTION FIND_DAYS(D1,D2:DATE_TYPE):INTEGER;
VAR
      I:INTEGER;
      N:CHAR;
      D:DATE_TYPE;
      DONE:BOOLEAN;
BEGIN
          I:=0;
          DONE:=FALSE;

     IF NOT CHECK_DATE(D1,D2,N) THEN
     BEGIN
       IF N='L' THEN D:=D1 ELSE D:=D2;
        WHILE NOT DONE DO
        BEGIN
        I:=I+1;
         FIND_DATE(D,1);
         IF CHECK_DATE(D,D2,N) THEN DONE:=TRUE;
        END;
    END;
     FIND_DAYS:=I;
END;

FUNCTION DT2ST(D:DATE_TYPE):STRING;
VAR S1,S2,S3:STRING;
BEGIN
      IF D.DATE=0 THEN  DT2ST:=''
      ELSE
      BEGIN
      STR(D.DATE,S1);
      STR(D.MONTH,S2);
      STR(D.YEAR,S3);
      IF S1='' THEN S1:='  ' ELSE
      IF LENGTH(S1)=1 THEN S1:=' '+S1;
      IF S2='' THEN S2:='  ' ELSE
      IF LENGTH(S1)=1 THEN S1:=' '+S1;
      IF S3='' THEN S3:='  ' ELSE
   DT2ST:=CONCAT(S1,'/',S2,'/',S3);
      END;
END;

FUNCTION ST2DT(S:STRING;VAR D:DATE_TYPE):BOOLEAN;
VAR
   S1,S2,S3:STRING;
   I,ECODE1,ECODE2,ECODE3:INTEGER;
BEGIN    D.DATE:=0;D.MONTH:=0;D.YEAR:=0;
    IF LENGTH(S)>=8 THEN
    BEGIN
    ST2DT:=TRUE;
    S1:='';    S2:='';    S3:='';
    I:=1;   WHILE S[I]=' ' DO I:=I+1;
    WHILE (S[I] IN ['0'..'9']) DO
    BEGIN
      S1:=S1+S[I];
      I:=I+1;
    END; I:=I+1;  WHILE S[I]=' ' DO I:=I+1;
    WHILE (S[I]IN ['0'..'9']) DO
    BEGIN
      S2:=S2+S[I];
      I:=I+1;
    END;  I:=I+1;  WHILE S[I]=' ' DO I:=I+1;
    S3:=S[I]+S[I+1]+S[I+2]+S[I+3];
    {S1:=S[1]+S[2];
    S2:=S[4]+S[5];
    S3:=S[7]+S[8]+S[9]+S[10];}
    VAL(S1,D.DATE,ECODE1);
    VAL(S2,D.MONTH,ECODE2);
    VAL(S3,D.YEAR,ECODE3);
    IF (ECODE1<>0) OR (ECODE2<>0) OR (ECODE3<>0) THEN
       ST2DT:=FALSE;
     END ELSE ST2DT:=FALSE;
END;

PROCEDURE COPYFILE(SOURCE,TARGET:STRING);
VAR T,R:FILE OF BYTE;
    B:BYTE;
BEGIN
   ASSIGN(T,SOURCE); RESET(T);
   ASSIGN(R,TARGET); REWRITE(R);
   WHILE NOT EOF(T) DO
   BEGIN
    READ(T,B);
    WRITE(R,B);
   END;
  CLOSE(T);
  CLOSE(R);
END;

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

FUNCTION PRESENT(FNAME:STRING):BOOLEAN;
VAR
  T:TEXT;
BEGIN
      ASSIGN(T,FNAME);
      {$I-}
      RESET(T); CLOSE(T);
      {$I+}
     PRESENT:=(IORESULT=0);
END;

PROCEDURE BLANK(VAR S:STRING);
VAR I:INTEGER;
BEGIN
    FOR I:=LENGTH(S) TO 255 DO S:=S+' ';
END;

PROCEDURE REMOVE_BLANKS(VAR S:STRING;K:CHAR);
VAR I:INTEGER;
BEGIN
     IF S='' THEN EXIT;
     CASE K OF
       'S': BEGIN
            I:=1;
              WHILE (S[I]=' ') AND (I<=LENGTH(S)) DO
                I:=I+1;
                IF I<=LENGTH(S) THEN DELETE(S,1,I-1) ELSE S:='';
            END;
       'E':BEGIN
          I:=LENGTH(S);
            WHILE (S[I]=' ') AND (I>=1) DO
             I:=I-1;
              IF I>=1 THEN DELETE(S,I+1,LENGTH(S)-I);
            END;
       END;
END;

FUNCTION  READXY(X,Y,XI:INTEGER;VAR ST:STRING):BOOLEAN;
VAR
    D:CHAR;
    L:INTEGER;
    CHOICE:KEYTYPE;
BEGIN      MAKECURSOR(ON);
    READXY:=FALSE;
    GOTOXY(X,Y); WRITE(ST); GOTOXY(X,Y);
    L:=X+LENGTH(ST)-1;
       BLANK(ST);
     REPEAT
       D:=READKEY;
       CHOICE:=CODES(D);
      CASE CHOICE OF
       RIGHT:BEGIN
                    IF WHEREX=XI THEN BEEP ELSE
                          GOTOXY(WHEREX+1,WHEREY);
             END;
       LEFT:BEGIN
                    IF WHEREX=X THEN BEEP ELSE
                          GOTOXY(WHEREX-1,WHEREY);
            END;
  ALPHABETS,
   NUMBERS,
   OTHER   :BEGIN

                ST[WHEREX-X+1]:=D; WRITE(D);
                IF WHEREX=XI+1 THEN BEGIN BEEP; GOTOXY(WHEREX-1,WHEREY); END;
            END;
       DEL :BEGIN
                  WRITE(' '); GOTOXY(WHEREX-1,WHEREY);
            END;
  BKSPACE  :BEGIN

                 IF WHEREX=X THEN BEEP ELSE
                BEGIN
                  GOTOXY(WHEREX-1,WHEREY); WRITE(' ');
                  GOTOXY(WHEREX-1,WHEREY); ST[WHEREX-X+1]:=' ';
                END;
            END;
  SPACE    :BEGIN
                     IF WHEREX=XI THEN BEEP ELSE
                BEGIN ST[WHEREX-X+1]:=' ';WRITE(' '); END;
            END;
     ESC   :READXY:=TRUE;
        END;  {CASE}
    UNTIL (CHOICE=ESC) OR (CHOICE=ENTER);
    REMOVE_BLANKS(ST,'S');REMOVE_BLANKS(ST,'E');MAKECURSOR(OFF);
END;

PROCEDURE SAVESCREEN(N:BYTE);
BEGIN
  CASE N OF
     1:MOVE(SCREEN^,SCREEN1^,4000);
     2:MOVE(SCREEN^,SCREEN2^,4000);
     3:MOVE(SCREEN^,SCREEN3^,4000);
     END;
END;

PROCEDURE RESTORESCREEN(N:BYTE);
BEGIN
  CASE N OF
     1:MOVE(SCREEN1^,SCREEN^,4000);
     2:MOVE(SCREEN2^,SCREEN^,4000);
     3:MOVE(SCREEN3^,SCREEN^,4000);
     END;
END;

FUNCTION UPSTRING(S:STRING):STRING;
VAR
 I:BYTE;
BEGIN
  FOR I:=1 TO LENGTH(S) DO
  S[I]:=UPCASE(S[I]);
  UPSTRING:=S;
END;

PROCEDURE BAR(X,Y,XI,YI:INTEGER;COLOR:WORD);
BEGIN
WINDOW(X,Y,XI,YI);
TEXTBACKGROUND(COLOR);
CLRSCR;
WINDOW(1,1,80,25);
END;

PROCEDURE LINE(X,Y,XI,YI:INTEGER;KIND:KIND_TYPE);
VAR I:INTEGER;
BEGIN
  IF Y=YI THEN
  BEGIN
     FOR I:=X TO XI DO
  BEGIN GOTOXY(I,Y);
  WRITE(DISPLAY_CHAR[KIND,1]);
  GOTOXY(I,YI);
  WRITE(DISPLAY_CHAR[KIND,1]);
  END; END ELSE
  IF X=XI THEN
  BEGIN
   FOR I:=Y TO YI DO
   BEGIN
    GOTOXY(X,I);
    WRITE(DISPLAY_CHAR[KIND,2]);
    GOTOXY(XI,I);
    WRITE(DISPLAY_CHAR[KIND,2]);
   END;
     END;
END;

PROCEDURE BOX(X,Y,XI,YI:INTEGER;KIND:KIND_TYPE);
BEGIN
    LINE(X,Y,XI,Y,KIND);
    LINE(X,YI,XI,YI,KIND);
    LINE(X,Y,X,YI,KIND);
    LINE(XI,Y,XI,YI,KIND);
    GOTOXY(X,Y);WRITE(DISPLAY_CHAR[KIND,3]);
    GOTOXY(X,YI);WRITE(DISPLAY_CHAR[KIND,5]);
    GOTOXY(XI,Y);WRITE(DISPLAY_CHAR[KIND,4]);
    GOTOXY(XI,YI);WRITE(DISPLAY_CHAR[KIND,6]);
END;

PROCEDURE UPARROW(VAR R:DISPLAY_RECORD);
BEGIN
  WITH R DO
  BEGIN
        BAR(X+1,Y+CURRENT,X+(XI-X)-1,Y+CURRENT,WHITE);
        WINDOW(X+1,Y+1,XI-1,YI-1);
        TEXTCOLOR(BLACK);
        GOTOXY(2,CURRENT);
        WRITE(A[CURRENT]);
        IF CURRENT>1 THEN  CURRENT:=CURRENT-1
         ELSE
        IF CURRENT=1 THEN
           CURRENT:=TOTAL;
        BAR(X+1,Y+CURRENT,X+(XI-X)-1,Y+CURRENT,BLACK);
        WINDOW(X+1,Y+1,XI-1,YI-1);
        TEXTCOLOR(WHITE);
        GOTOXY(2,CURRENT);
        WRITE(A[CURRENT]);
       WINDOW(1,1,80,25);
  END;  { WITH }
END;

PROCEDURE DOWNARROW(VAR R:DISPLAY_RECORD);
BEGIN
  WITH R DO
  BEGIN
        BAR(X+1,Y+CURRENT,X+(XI-X)-1,Y+CURRENT,WHITE);
        WINDOW(X+1,Y+1,XI-1,YI-1);
        TEXTCOLOR(BLACK);
        GOTOXY(2,CURRENT);
        WRITE(A[CURRENT]);
        IF CURRENT<TOTAL THEN  CURRENT:=CURRENT+1
         ELSE
        IF CURRENT=TOTAL THEN
           CURRENT:=1;
        BAR(X+1,Y+CURRENT,X+(XI-X)-1,Y+CURRENT,BLACK);
        WINDOW(X+1,Y+1,XI-1,YI-1);
        TEXTCOLOR(WHITE);
        GOTOXY(2,CURRENT);
        WRITE(A[CURRENT]);
       WINDOW(1,1,80,25);
  END;  { WITH }
END;

PROCEDURE ERASES(X,Y,XI,YI:INTEGER;{H:CHAR}COLOR:WORD);
VAR
  D:CHAR;
BEGIN
   WINDOW(X,Y,XI,YI);
   TEXTBACKGROUND(COLOR);
   CLRSCR;
   WINDOW(1,1,80,25);
END;

PROCEDURE DRAWBAR(VAR  R:DISPLAY_RECORD);
VAR
     L,K,I:INTEGER;
BEGIN
  WITH R DO
BEGIN
     BAR(X,Y,XI,YI,WHITE);
     TEXTCOLOR(BLACK);
      BOX(X,Y,XI,YI,SINGLE_TYPE);
      I:=0;
   WHILE I<TOTAL DO
   BEGIN
      I:=I+1;
      GOTOXY(X+2,Y+I);WRITE(A[I]);
   END;
   IF CURRENT<>0 THEN
   BEGIN
   BAR(X+1,Y+CURRENT,X+(XI-X)-1,Y+CURRENT,BLACK);
   TEXTCOLOR(WHITE);
   GOTOXY(X+2,Y+CURRENT);
   WRITE(A[CURRENT]);
   END;
END; { WITH }
END;

FUNCTION ASK(VAR S:STRING;PX,PY,NUM:INTEGER):BOOLEAN;
VAR D:DISPLAY_RECORD;
 MX,MY,MXI,R,ECODE:INTEGER;
 K:STRING;
 DONE:BOOLEAN;
BEGIN
    WITH D DO
    BEGIN
     A[1]:=S;
     X:=PX;       XI:=PX+LENGTH(S)+20;
     Y:=PY;       YI:=PY+2;
     TOTAL:=1;    CURRENT:=0;
    END;
   DRAWBAR(D);
   MX:=PX+LENGTH(S)+3; MXI:=D.XI-1;
   MY:=PY+1;
   WINDOW(MX,MY,MXI,MY);
   TEXTBACKGROUND(BLACK);
   TEXTCOLOR(WHITE);
   CLRSCR;
   K:=' ';
    IF NUM=1 THEN
     BEGIN
      REPEAT
      DONE:=READXY(1,1,MXI-MX,K);
      VAL(K,R,ECODE);
      UNTIL (ECODE=0) OR (DONE);
      ASK:=DONE;
     END
     ELSE
     IF NUM=0 THEN
     ASK:=READXY(1,1,MXI-MX,K);
     S:=K;
     WINDOW(1,1,80,25);
END;

PROCEDURE IDENTIFICATION;
VAR
  R:DISPLAY_RECORD;
  M:STRING;
  D:CHAR;
BEGIN
     WITH R DO
     BEGIN
    A[1]:='COMPUTERISED LIBRARY MAINTANANCE SYSTEM';
    A[2]:='';
    A[3]:='Password :';
    X:=1;Y:=7;
    XI:=80;YI:=Y+6;TOTAL:=3;
    CURRENT:=0;
    END;
    DRAWBAR(R);
    REPEAT
    M:='';
    REPEAT
    D:=READKEY;
    IF (D<>#13) AND (D<>#0) THEN BEGIN
    IF D=#8 THEN BEGIN
    IF M<>'' THEN DELETE(M,LENGTH(M),1)
    ELSE BEEP;
    END
    ELSE M:=M+D;
    END;  IF D=#27 THEN HALT;
    UNTIL D=#13;  IF M<>'NEERAJ' THEN BEEP;
    UNTIL (M='NEERAJ');
END;

PROCEDURE PRINT_ERROR(ERROR:ERROR_TYPE);
VAR ST:STRING;
    D:CHAR;
BEGIN
     SAVESCREEN(3);
   BAR(15,8,52,10,BLUE);
   TEXTCOLOR(WHITE);
   CASE ERROR OF
   RECORD_NOT_FOUND           :ST:=' RECORD NOT FOUND !';
   RECORD_ALREADY_PRESENT     :ST:=' RECORD ALREADY PRESENT !';
   KEY_NOT_APPLICABLE         :ST:=' KEY NOT APPLICABLE !';
   FILE_IS_EMPTY              :ST:=' FILE IS EMPTY !';
   DATE_ERROR                 :ST:=' [FORMAT/DATE] IS INVALID !';
   END;
   GOTOXY(20,9);
   WRITE(ST);
   D:=READKEY; IF D=#0 THEN D:=READKEY;
   RESTORESCREEN(3);
   TEXTBACKGROUND(BLACK);
   TEXTCOLOR(WHITE);
END;

PROCEDURE ABOUT;
VAR
    D:CHAR;
    NAME:STRING;
    T:TEXT;
BEGIN
     BAR(1,1,77,24,LIGHTGRAY);
     BOX(1,1,77,24,SINGLE_TYPE);
     WINDOW(2,1,77,24);
     TEXTCOLOR(BLACK);
     ASSIGN(T,'ABOUT.DAT');
     RESET(T);
     WHILE NOT EOF(T) DO
     BEGIN
     GOTOXY(1,WHEREY+1);
     READLN(T,NAME);
     WRITE(NAME);
    END;
     D:=READKEY;IF D=#0 THEN D:=READKEY;
     CLOSE(T);
     WINDOW(1,1,80,25);
END;

BEGIN
SCREEN:=PTR($B000,$8000);
SCREEN1:=PTR($B000,$9000);
SCREEN2:=PTR($B000,$A000);
SCREEN3:=PTR($B000,$B000);
END.