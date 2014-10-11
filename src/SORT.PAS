UNIT SORT;
INTERFACE
USES CRT,U_TOOL,LIBS;

PROCEDURE SORT_MEMBER;
PROCEDURE SORT_BOOK;
PROCEDURE SORT_ISSUE;
PROCEDURE SORT_EXPIRY;
PROCEDURE SET_OPTION;

VAR
I,J:INTEGER;
R:DISPLAY_RECORD;

IMPLEMENTATION
VAR
N,D:CHAR;
CHOICE:KEYTYPE;
ASCENDING,CASE_SENSITIVE:BOOLEAN;
{*****************MEMBER***************************}
PROCEDURE PROMPT;
VAR ST:STRING;
    D:CHAR;
BEGIN
   BAR(15,8,47,10,BLUE);
   TEXTCOLOR(WHITE);
   ST:='SORTING.......';
   GOTOXY(20,9);
   WRITE(ST);
END;

PROCEDURE SORT_MEMBER;
VAR
REC:MEMBER_RECORD;
FUNCTION CONDITION(REC,R1,R2:MEMBER_RECORD):BOOLEAN;
BEGIN
    CONDITION:=FALSE;
  WITH REC DO
  BEGIN
      IF NAME<>'' THEN
      BEGIN
       IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.NAME:=UPSTRING(R1.NAME);
           R2.NAME:=UPSTRING(R2.NAME);
        END;
       IF ASCENDING THEN CONDITION:=(R1.NAME>R2.NAME) ELSE
                         CONDITION:=(R1.NAME<R2.NAME);
      END
      ELSE
      IF DOB.DATE<>0 THEN
      BEGIN
      IF NOT CHECK_DATE(R1.DOB,R2.DOB,N) THEN
      IF ASCENDING THEN CONDITION:=(N='G') ELSE CONDITION:=(N='L');
      END
      ELSE
      IF ID<>0 THEN
      IF ASCENDING THEN CONDITION:=(R1.ID>R2.ID) ELSE
                        CONDITION:=(R1.ID<R2.ID);
  END;
END;

PROCEDURE SORT(REC:MEMBER_RECORD);
VAR
   R1,R2:MEMBER_RECORD;
BEGIN
   RESET(MEMBER_FILE);
   IF FILESIZE(MEMBER_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT; END;

FOR I:=1 TO FILESIZE(MEMBER_FILE)-1 DO
FOR J:=I+1 TO FILESIZE(MEMBER_FILE) DO
BEGIN
  SEEK(MEMBER_FILE,I-1);
  READ(MEMBER_FILE,R1);
  SEEK(MEMBER_FILE,J-1);
  READ(MEMBER_FILE,R2);

IF CONDITION(REC,R1,R2) THEN
BEGIN
  SEEK(MEMBER_FILE,I-1);
  WRITE(MEMBER_FILE,R2);
  SEEK(MEMBER_FILE,J-1);
  WRITE(MEMBER_FILE,R1);
END;
END;
END;
BEGIN      { MAIN MEMBER }
 WITH R DO
      BEGIN
       A[1]:='By Name Of Member';
       A[2]:='By Member ID';
       A[3]:='By Date Of Birth';
       CURRENT:=1;
       TOTAL:=3;
       X:=12;
       Y:=10;
       XI:=X+LENGTH(A[1])+7;
       YI:=Y+TOTAL+1;
       END;
   DRAWBAR(R);
   D:=READKEY;
   CHOICE:=CODES(D);
   WHILE CHOICE<>ESC DO
   BEGIN
   CASE CHOICE OF
        UP    :UPARROW(R);
        DOWN  :DOWNARROW(R);
        ENTER :BEGIN
                SAVESCREEN(2);
                INITIALIZE_MEMBER(REC);
              CASE R.CURRENT OF
                1:REC.NAME:='YES';
                2:REC.ID:=1;
                3:REC.DOB.DATE:=1;
                END;   PROMPT;
                 SORT(REC);
                RESTORESCREEN(2);
                END;
        END;
        D:=READKEY;
        CHOICE:=CODES(D);
   END;
END; {PROCEDURE}
{************************BOOK****************************}
PROCEDURE SORT_BOOK;
VAR
REC:BOOK_RECORD;
FUNCTION CONDITION(REC,R1,R2:BOOK_RECORD):BOOLEAN;
BEGIN
   CONDITION:=FALSE;
   WITH REC DO
   BEGIN
      IF NAME<>'' THEN
      BEGIN
       IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.NAME:=UPSTRING(R1.NAME);
           R2.NAME:=UPSTRING(R2.NAME);
        END;
      IF ASCENDING THEN CONDITION:=(R1.NAME>R2.NAME) ELSE
                        CONDITION:=(R1.NAME<R2.NAME);
      END
      ELSE
      IF AUTHOR<>'' THEN
      BEGIN
      IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.AUTHOR:=UPSTRING(R1.AUTHOR);
           R2.AUTHOR:=UPSTRING(R2.AUTHOR);
        END;
      IF ASCENDING THEN CONDITION:=(R1.AUTHOR>R2.AUTHOR) ELSE
                        CONDITION:=(R1.AUTHOR<R2.AUTHOR);
      END
      ELSE
      IF ID<>0 THEN
      IF ASCENDING THEN CONDITION:=(R1.ID>R2.ID ) ELSE
                        CONDITION:=(R1.ID<R2.ID);
   END;
END;

PROCEDURE SORT(REC:BOOK_RECORD);
VAR
   R1,R2:BOOK_RECORD;
BEGIN
   RESET(BOOK_FILE);
   IF FILESIZE(BOOK_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT; END;

FOR I:=1 TO FILESIZE(BOOK_FILE)-1 DO
FOR J:=I+1 TO FILESIZE(BOOK_FILE) DO
BEGIN
  SEEK(BOOK_FILE,I-1);
  READ(BOOK_FILE,R1);
  SEEK(BOOK_FILE,J-1);
  READ(BOOK_FILE,R2);
IF CONDITION(REC,R1,R2) THEN
BEGIN
  SEEK(BOOK_FILE,I-1);
  WRITE(BOOK_FILE,R2);
  SEEK(BOOK_FILE,J-1);
  WRITE(BOOK_FILE,R1);

END;
END;
END;

BEGIN      { MAIN BOOK }
 WITH R DO
      BEGIN
       A[1]:='By Name Of Book';
       A[2]:='By Book ID';
       A[3]:='By Auther''s Name';
       CURRENT:=1;
       TOTAL:=3;
       X:=12;
       Y:=10;
       XI:=X+LENGTH(A[3])+7;
       YI:=Y+TOTAL+1;
       END;
   DRAWBAR(R);
   D:=READKEY;
   CHOICE:=CODES(D);
   WHILE CHOICE<>ESC DO
   BEGIN
   CASE CHOICE OF
        UP    :UPARROW(R);
        DOWN  :DOWNARROW(R);
        ENTER :BEGIN
                SAVESCREEN(2);
                INITIALIZE_BOOK(REC);
              CASE R.CURRENT OF
                1:REC.NAME:='YES';
                2:REC.ID:=1;
                3:REC.AUTHOR:='YES';
                END;   PROMPT;
                 SORT(REC);
                RESTORESCREEN(2);
                END;
        END;
        D:=READKEY;
        CHOICE:=CODES(D);
       END;
END; {PROCEDURE}
{***********************ISSUE***********************}
PROCEDURE SORT_ISSUE;
VAR
REC:ISSUE_RECORD;
FUNCTION CONDITION(REC,R1,R2:ISSUE_RECORD):BOOLEAN;
BEGIN
   CONDITION:=FALSE;
   WITH REC DO
   BEGIN
      IF M_NAME<>'' THEN
      BEGIN
      IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.M_NAME:=UPSTRING(R1.M_NAME);
           R2.M_NAME:=UPSTRING(R2.M_NAME);
        END;
      IF ASCENDING THEN CONDITION:=(R1.M_NAME>R2.M_NAME) ELSE
                        CONDITION:=(R1.M_NAME<R2.M_NAME);
      END
      ELSE
      IF M_ID<>0 THEN
      BEGIN
      IF ASCENDING THEN CONDITION:=(R1.M_ID>R2.M_ID) ELSE
                        CONDITION:=(R1.M_ID<R2.M_ID);
      END
      ELSE
      IF B_NAME<>'' THEN
      BEGIN
      IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.B_NAME:=UPSTRING(R1.B_NAME);
           R2.B_NAME:=UPSTRING(R2.B_NAME);
        END;
      IF ASCENDING THEN CONDITION:=(R1.B_NAME>R2.B_NAME) ELSE
                        CONDITION:=(R1.B_NAME<R2.B_NAME);
      END
      ELSE
      IF DOI.DATE<>0 THEN
      BEGIN
      IF NOT CHECK_DATE(R1.DOI,R2.DOI,N) THEN
      IF ASCENDING THEN CONDITION:=(N='G') ELSE CONDITION:=(N='L');
      END
      ELSE
      IF B_ID<>0 THEN
      IF ASCENDING THEN CONDITION:=(R1.B_ID>R2.B_ID) ELSE
                        CONDITION:=(R1.B_ID<R2.B_ID);
   END;
END;

PROCEDURE SORT(REC:ISSUE_RECORD);
VAR
   R1,R2:ISSUE_RECORD;
BEGIN
   RESET(ISSUE_FILE);
   IF FILESIZE(ISSUE_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT; END;
FOR I:=1 TO FILESIZE(ISSUE_FILE)-1 DO
FOR J:=I+1 TO FILESIZE(ISSUE_FILE) DO
BEGIN
  SEEK(ISSUE_FILE,I-1);
  READ(ISSUE_FILE,R1);
  SEEK(ISSUE_FILE,J-1);
  READ(ISSUE_FILE,R2);
IF CONDITION(REC,R1,R2) THEN
BEGIN
  SEEK(ISSUE_FILE,I-1);
  WRITE(ISSUE_FILE,R2);
  SEEK(ISSUE_FILE,J-1);
  WRITE(ISSUE_FILE,R1);

END;
END;

END;
BEGIN      { MAIN ISSUE }
 WITH R DO
      BEGIN
       A[1]:='By Name Of Member';
       A[2]:='By Member ID';
       A[3]:='By Name Of Book';
       A[4]:='By Book ID';
       A[5]:='By Date Of Issue';
       CURRENT:=1;
       TOTAL:=5;
       X:=12;
       Y:=10;
       XI:=X+LENGTH(A[1])+7;
       YI:=Y+TOTAL+1;
       END;
   DRAWBAR(R);
   D:=READKEY;
   CHOICE:=CODES(D);
  WHILE CHOICE<>ESC DO
  BEGIN
   CASE CHOICE OF
        UP    :UPARROW(R);
        DOWN  :DOWNARROW(R);
        ENTER :BEGIN
                SAVESCREEN(2);
                INITIALIZE_ISSUE(REC);
              CASE R.CURRENT OF
                1:REC.M_NAME:='YES';
                2:REC.M_ID:=1;
                3:REC.B_NAME:='YES';
                4:REC.B_ID:=1;
                5:REC.DOI.DATE:=1;
                END;   PROMPT;
                SORT(REC);
               RESTORESCREEN(2);
                END;
        END;
     D:=READKEY;
     CHOICE:=CODES(D);
    END;
END; {PROCEDURE}
{***********************EXPIRY***********************}
PROCEDURE SORT_EXPIRY;
VAR
REC:EXPIRY_RECORD;
FUNCTION CONDITION(REC,R1,R2:EXPIRY_RECORD):BOOLEAN;
BEGIN
    CONDITION:=FALSE;
   WITH REC DO
   BEGIN
      IF M_NAME<>'' THEN
      BEGIN
      IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.M_NAME:=UPSTRING(R1.M_NAME);
           R2.M_NAME:=UPSTRING(R2.M_NAME);
        END;
      IF ASCENDING THEN CONDITION:=(R1.M_NAME>R2.M_NAME) ELSE
                        CONDITION:=(R1.M_NAME<R2.M_NAME);
      END
      ELSE
      IF M_ID<>0 THEN
      BEGIN
      IF ASCENDING THEN CONDITION:=(R1.M_ID>R2.M_ID) ELSE
                        CONDITION:=(R1.M_ID<R2.M_ID);
      END
      ELSE
      IF B_NAME<>'' THEN
      BEGIN
      IF NOT CASE_SENSITIVE THEN
        BEGIN
           R1.B_NAME:=UPSTRING(R1.B_NAME);
           R2.B_NAME:=UPSTRING(R2.B_NAME);
        END;
      IF ASCENDING THEN CONDITION:=(R1.B_NAME>R2.B_NAME) ELSE
                        CONDITION:=(R1.B_NAME<R2.B_NAME);
      END
      ELSE
      IF DOE.DATE<>0 THEN
      BEGIN
      IF NOT CHECK_DATE(R1.DOE,R2.DOE,N) THEN
      IF ASCENDING THEN CONDITION:=(N='G') ELSE CONDITION:=(N='L');
      END
      ELSE
      IF B_ID<>0 THEN
      IF ASCENDING THEN CONDITION:=(R1.B_ID>R2.B_ID) ELSE
                        CONDITION:=(R1.B_ID<R2.B_ID);

  END;
END;

PROCEDURE SORT(REC:EXPIRY_RECORD);
VAR
   R1,R2:EXPIRY_RECORD;
BEGIN
   RESET(EXPIRY_FILE);
   IF FILESIZE(EXPIRY_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT; END;
FOR I:=1 TO FILESIZE(EXPIRY_FILE)-1 DO
FOR J:=I+1 TO FILESIZE(EXPIRY_FILE) DO
BEGIN
  SEEK(EXPIRY_FILE,I-1);
  READ(EXPIRY_FILE,R1);
  SEEK(EXPIRY_FILE,J-1);
  READ(EXPIRY_FILE,R2);
IF CONDITION(REC,R1,R2) THEN
BEGIN
  SEEK(EXPIRY_FILE,I-1);
  WRITE(EXPIRY_FILE,R2);
  SEEK(EXPIRY_FILE,J-1);
  WRITE(EXPIRY_FILE,R1);

END;
END;
END;

BEGIN      { MAIN EXPIRY }
     WITH R DO
      BEGIN
       A[1]:='By Name Of Member';
       A[2]:='By Member ID';
       A[3]:='By Name Of Book';
       A[4]:='By Book ID';
       A[5]:='By Date Of Expiry';
       CURRENT:=1;
       TOTAL:=5;
       X:=12;
       Y:=10;
       XI:=X+LENGTH(A[1])+7;
       YI:=Y+TOTAL+1;
       END;
   DRAWBAR(R);
   D:=READKEY;
   CHOICE:=CODES(D);
   WHILE CHOICE<>ESC DO
   BEGIN
    CASE CHOICE OF
        UP    :UPARROW(R);
        DOWN  :DOWNARROW(R);
        ENTER :BEGIN
                SAVESCREEN(2);
                INITIALIZE_EXPIRY(REC);
              CASE R.CURRENT OF
                1:REC.M_NAME:='YES';
                2:REC.M_ID:=1;
                3:REC.B_NAME:='YES';
                4:REC.B_ID:=1;
                5:REC.DOE.DATE:=1;
                END;   PROMPT;
                 SORT(REC);
                 RESTORESCREEN(2);
                END;
        END;
      D:=READKEY;
      CHOICE:=CODES(D);
   END;
END; {PROCEDURE}

PROCEDURE SET_OPTION;
TYPE
    REC=RECORD
        X,Y,XI,YI:INTEGER;
        END;
      R=RECORD
        X,Y:INTEGER;
        END;

VAR
     SHADED_BAR:ARRAY[1..3] OF REC;
     A,S,B:R;
     CURRENT:INTEGER;
     CH:CHAR;
     OLD_ASCEN,OLD_CASE:BOOLEAN;
PROCEDURE SHOW(CURRENT:INTEGER;COLOR:WORD);
BEGIN
  WITH SHADED_BAR[CURRENT] DO
                 BEGIN
                  BAR(X,Y,XI,YI,COLOR);
                TEXTCOLOR(BLACK);
           IF (COLOR=GREEN) AND (CURRENT<>3) THEN BOX(X,Y,XI,YI,SINGLE_TYPE);
                  CASE CURRENT OF
                  1:BEGIN
                      TEXTCOLOR(BLACK);
                      GOTOXY(A.X,A.Y);
                      WRITE('( )  Ascending Order');
                      GOTOXY(A.X,A.Y+1);
                      WRITE('( ) Descending Order');
                      IF ASCENDING THEN GOTOXY(A.X+1,A.Y) ELSE
                      GOTOXY(A.X+1,A.Y+1);
                      WRITE(CH);
                    END;
                  2:BEGIN
                     TEXTCOLOR(BLACK);
                     GOTOXY(S.X,S.Y);
                     WRITE('[ ] Case Sensitive');
                     IF CASE_SENSITIVE THEN BEGIN GOTOXY(S.X+1,S.Y);
                                                  WRITE('X'); END;
                     END;
                  3:BEGIN
                     TEXTCOLOR(BLACK);
                     GOTOXY(B.X,B.Y);
                     WRITE('OK');
                    END;
                  END;
           END;
END;
BEGIN
     OLD_ASCEN:=ASCENDING;
     OLD_CASE:=CASE_SENSITIVE;

     BAR(12,7,60,19,LIGHTGRAY);
     TEXTCOLOR(WHITE);
     BOX(12,7,60,19,DOUBLE_TYPE);
     GOTOXY(28,7); WRITE('SET SORT OPTIONS');
     WITH SHADED_BAR[1] DO
     BEGIN
        X:=14; Y:=8; XI:=50; YI:=12;
     A.X:=X+1;
     A.Y:=Y+1;
     END;
     CH:=#232;

     WITH SHADED_BAR[2] DO
     BEGIN
       X:=14; Y:=14; XI:=50; YI:=16;
     S.X:=X+1;
     S.Y:=Y+1;
     END;

     WITH SHADED_BAR[3] DO
     BEGIN
        X:=30; Y:=18; XI:=36; YI:=18;
    B.X:=X+2;
    B.Y:=Y;
    END;
      CURRENT:=1;
     SHOW(1,GREEN);
     SHOW(2,LIGHTCYAN);
     SHOW(3,LIGHTCYAN);
     REPEAT
     D:=READKEY;
     CHOICE:=CODES(D);
       CASE CHOICE OF
       TAB     :BEGIN          {TO EXIT OLD OPTION}
                   SHOW(CURRENT,LIGHTCYAN);
                  IF CURRENT=3 THEN CURRENT:=1 ELSE CURRENT:=CURRENT+1;
                   {TO SELECT NEW}
                   SHOW(CURRENT,GREEN);
                END;
       DOWN,UP :IF CURRENT=1 THEN
                 BEGIN
                 ASCENDING:=NOT(ASCENDING);
                 GOTOXY(A.X+1,A.Y); WRITE(' ');
                 GOTOXY(A.X+1,A.Y+1); WRITE(' ');
                 IF ASCENDING THEN  GOTOXY(A.X+1,A.Y)
                 ELSE GOTOXY(A.X+1,A.Y+1);
                 WRITE(CH);
                 END ELSE BEEP;
       SPACE   :IF CURRENT=2 THEN
                 BEGIN
                   CASE_SENSITIVE:=NOT(CASE_SENSITIVE);
                   GOTOXY(S.X+1,S.Y);
                   WRITE(' '); GOTOXY(S.X+1,S.Y);
                   IF CASE_SENSITIVE THEN  WRITE('X');
                 END ELSE BEEP;
       ENTER   :IF CURRENT=3 THEN EXIT ELSE BEEP;
       ESC     :BEGIN ASCENDING:=OLD_ASCEN;
                      CASE_SENSITIVE:=OLD_CASE;
                END;
       END;
    UNTIL (CHOICE=ESC);
END;
BEGIN
  ASCENDING:=TRUE; CASE_SENSITIVE:=TRUE;
END.