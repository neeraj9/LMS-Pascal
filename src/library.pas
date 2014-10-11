PROGRAM LIBRARY_MANAGEMENT_SYSTEM(INPUT,OUTPUT);
USES CRT,DOS,U_TOOL,LIBS,LIB2,SORT,U_VIEW,CURSOR;
CONST COL=22;
      HEI=1;
      BKCOLOR=BLACK;
      MX=3;
      BX=15;
      IX=25;
      VX=36;
      SEARCHX=46;
      SORTX=58;
      EXITX=68;
      MAX_OPTIONS=7;
      COMMON_Y=5;
TYPE
    OPTION_RECORD=RECORD
                  NAME:STRING;
                  X,XI:INTEGER;
                  END;
VAR
   MEMBER_REC,BOOK_REC,ISSUE_REC,
   VIEW_REC,SEARCH_REC,SORT_REC,OTHER_REC:DISPLAY_RECORD;
   D:CHAR;
   ECODE,OLD_OPTION,COPTION:INTEGER;
   CHOICE:KEYTYPE;
   K:STRING;
   V:INTEGER;
   J:ARRAY[1..MAX_OPTIONS] OF OPTION_RECORD;
   SFILE:FILE;
   OLD_CURSOR:ARRAY [1..2] OF INTEGER;
PROCEDURE ERASE_OLD(H:INTEGER);
BEGIN
  BAR(J[H].X,2,J[H].XI,2,WHITE);
  TEXTCOLOR(BLACK);
  GOTOXY(J[H].X+1,2);
  WRITE(J[H].NAME);
END;

PROCEDURE SHOW_NEW(H:INTEGER);
BEGIN
    BAR(J[H].X,2,J[H].XI,2,BLACK);
  TEXTCOLOR(WHITE);
  GOTOXY(J[H].X+1,2);
  WRITE(J[H].NAME);
END;

PROCEDURE DATES;
VAR
 T,ST:STRING;
   DT:DATE_TYPE;
   D:BOOLEAN;
BEGIN
     ST:='ENTER DATE  (DD/MM/YYYY) :';
     REPEAT T:=ST;
     IF ASK(T,10,10,0) THEN EXIT;
     D:=ST2DT(T,DT);IF T='' THEN EXIT;
     UNTIL VALID_DATE(DT);
     SETDATE(DT.YEAR,DT.MONTH,DT.DATE);
END;

PROCEDURE INITIALSCREEN;
VAR I:BYTE;
BEGIN
  BAR(1,1,80,3,WHITE);
  TEXTCOLOR(BLACK);
  FOR I:=1 TO MAX_OPTIONS DO
  BEGIN
  GOTOXY(J[I].X,2);
  WRITE(J[I].NAME);
  END;
END;

PROCEDURE SHOW_MEMBER;
BEGIN
        DRAWBAR(MEMBER_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH MEMBER_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=2;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=MAX_OPTIONS;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(MEMBER_REC);
             DOWN  :DOWNARROW(MEMBER_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                         SAVESCREEN(1);
                        CASE CURRENT OF
                        1:MEMBER_ADD;
                        2:BEGIN
                           K:='MEMBER ID :';
                           IF NOT ASK(K,MX+7,8,1) THEN
                           BEGIN
                            VAL(K,V,ECODE);
                            MEMBER_DELETE(V);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='MEMBER ID :';
                           IF NOT ASK(K,MX+7,9,1) THEN
                           BEGIN
                            VAL(K,V,ECODE);
                           MEMBER_MODIFY(V);
                           END;
                          END;  {3}
                          END;{CASE}
                          RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH MEMBER_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);
END;

PROCEDURE SHOW_BOOK;
BEGIN
        DRAWBAR(BOOK_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH BOOK_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=3;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=1;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(BOOK_REC);
             DOWN  :DOWNARROW(BOOK_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                        SAVESCREEN(1);
                        CASE CURRENT OF
                        1:BOOK_ADD;
                        2:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,BX+9,8,1) THEN
                           BEGIN
                            VAL(K,V,ECODE);
                            BOOK_DELETE(V);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,BX+9,9,1) THEN
                           BEGIN
                            VAL(K,V,ECODE);
                            BOOK_MODIFY(V);
                           END;
                          END;  {3}
                          END;{CASE}
                         RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH BOOK_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);
END;

PROCEDURE SHOW_ISSUE;
BEGIN
        DRAWBAR(ISSUE_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH ISSUE_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=4;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=2;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(ISSUE_REC);
             DOWN  :DOWNARROW(ISSUE_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                         SAVESCREEN(1);
                        CASE CURRENT OF
                        1:ISSUE_BOOK;
                        2:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,IX+13,12,1) THEN
                           BEGIN
                            VAL(K,V,ECODE);
                            RETURN_BOOK(V);
                           END;
                          END;  {2}
                         END;{CASE}
                         RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH ISSUE_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);

END;

PROCEDURE SHOW_VIEW;
VAR M:MEMBER_RECORD;
    B:BOOK_RECORD;
    I:ISSUE_RECORD;
    E:EXPIRY_RECORD;
BEGIN
        DRAWBAR(VIEW_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH VIEW_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=5;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=3;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(VIEW_REC);
             DOWN  :DOWNARROW(VIEW_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                         SAVESCREEN(1);
                        CASE CURRENT OF
                        1:BEGIN
                           INITIALIZE_MEMBER(M);
                         VIEW_MEMBER(M);
                          END;  {1}
                        2:BEGIN
                           INITIALIZE_BOOK(B);
                         VIEW_BOOK(B);
                          END;  {2}
                        3:BEGIN
                           INITIALIZE_ISSUE(I);
                         VIEW_ISSUE(I);
                          END;  {3}
                         4:BEGIN
                           INITIALIZE_EXPIRY(E);
                         VIEW_EXPIRY(E);
                          END;  {4}
                          END;{CASE}
                          RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH VIEW_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);
END;

PROCEDURE SHOW_SEARCH;
BEGIN
        DRAWBAR(SEARCH_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH SEARCH_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=6;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=4;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(SEARCH_REC);
             DOWN  :DOWNARROW(SEARCH_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                         SAVESCREEN(1);
                        CASE CURRENT OF
                          1:VIEWSPECIFIC_MEMBER;
                          2:VIEWSPECIFIC_BOOK;
                          3:VIEWSPECIFIC_ISSUE;
                          4:VIEWSPECIFIC_EXPIRY;
                          END;{CASE}
                          RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH SEARCH_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);
END;

PROCEDURE SHOW_SORT;
BEGIN
        DRAWBAR(SORT_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH SORT_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=7;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=5;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(SORT_REC);
             DOWN  :DOWNARROW(SORT_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                        SAVESCREEN(1);
                        CASE CURRENT OF
                          1:SORT_MEMBER;
                          2:SORT_BOOK;
                          3:SORT_ISSUE;
                          4:SORT_EXPIRY;
                          5:SET_OPTION;
                          END;{CASE}
                          RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH SORT_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC);
END;

PROCEDURE SHOW_OTHER;
BEGIN
        DRAWBAR(OTHER_REC);
        REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
          WITH OTHER_REC DO
          BEGIN
             CASE CHOICE OF
             RIGHT :BEGIN COPTION:=1;ERASES(X,Y,XI,YI,BKCOLOR);END;
             LEFT  :BEGIN COPTION:=6;ERASES(X,Y,XI,YI,BKCOLOR);END;
             UP    :UPARROW(OTHER_REC);
             DOWN  :DOWNARROW(OTHER_REC);
             ESC   :BEGIN COPTION:=0;ERASES(X,Y,XI,YI,BKCOLOR);END;
             ENTER :BEGIN
                        SAVESCREEN(1);
                        CASE CURRENT OF
                          1:COPTION:=MAX_OPTIONS+1;
                          2:ABOUT;
                          END;{CASE}
                         RESTORESCREEN(1);
                      END;{ENTER}
             END;{CASE}
           END;{WITH EXIT_REC}
        UNTIL (CHOICE=LEFT) OR (CHOICE=RIGHT) OR (CHOICE=ESC)
                            OR ((CHOICE=ENTER)AND(OTHER_REC.CURRENT=1));
END;

PROCEDURE SELECT_OPTIONS;
BEGIN
  REPEAT
    D:=READKEY;
    CHOICE:=CODES(D);
    CASE CHOICE OF
     RIGHT  :BEGIN ERASE_OLD(COPTION);
              IF COPTION=MAX_OPTIONS THEN COPTION:=1 ELSE COPTION:=COPTION+1;
               SHOW_NEW(COPTION);
             END;
     LEFT   :BEGIN ERASE_OLD(COPTION);
              IF COPTION=1 THEN COPTION:=MAX_OPTIONS ELSE COPTION:=COPTION-1;
               SHOW_NEW(COPTION);
             END;
DOWN,ENTER  :{EXIT TO OPTIONS};
     ESC    :COPTION:=MAX_OPTIONS+1;
     END;
     UNTIL (CHOICE=ENTER) OR (CHOICE=ESC) OR (CHOICE=DOWN);
END;

PROCEDURE OPTIONS;
BEGIN
   COPTION:=1;
   OLD_OPTION:=1;
   SHOW_NEW(COPTION);
   SELECT_OPTIONS;
   REPEAT
     IF COPTION=0 THEN
     BEGIN COPTION:=OLD_OPTION;
           SELECT_OPTIONS;
     END;
           ERASE_OLD(OLD_OPTION);
           SHOW_NEW(COPTION);

           OLD_OPTION:=COPTION;
     CASE COPTION OF
      1: SHOW_MEMBER;
      2:SHOW_BOOK;
      3:SHOW_ISSUE;
      4:SHOW_VIEW;
      5:SHOW_SEARCH;
      6:SHOW_SORT;
      7:SHOW_OTHER;
      END;
   UNTIL COPTION=MAX_OPTIONS+1;
END;

BEGIN {***** MAIN *******} MAKECURSOR(OFF);
  ASSIGN(SFILE,'SCREEN.SCN'); REWRITE(SFILE,1);
  BLOCKWRITE(SFILE,SCREEN^,4000);
  CLOSE(SFILE);
  OLD_CURSOR[1]:=WHEREX;
  OLD_CURSOR[2]:=WHEREY;

  TEXTBACKGROUND(BKCOLOR);
  CLRSCR;
  WITH MEMBER_REC DO
  BEGIN
      A[1]:='Add    Record';
      A[2]:='Delete Record ';
      A[3]:='Modify Record ';
       TOTAL:=3; CURRENT:=1;
        X:=MX;
        Y:=COMMON_Y;
        XI:=MX+30;
        YI:=Y+TOTAL+1;
  END;
  WITH BOOK_REC DO
  BEGIN
      A[1]:='Add    Book';
      A[2]:='Delete Book';
      A[3]:='Modify Book';
       TOTAL:=3; CURRENT:=1;
       X:=BX;
       Y:=COMMON_Y;
       XI:=BX+29;
       YI:=Y+TOTAL+1;
  END;
  WITH ISSUE_REC DO
  BEGIN
   A[1]:='Issue  a Book';
   A[2]:='Return a Book';
     TOTAL:=2;  CURRENT:=1;
      X:=IX;
      Y:=COMMON_Y;
      XI:=IX+20;
      YI:=Y+TOTAL+1;
   END;
   WITH VIEW_REC DO
   BEGIN
      A[1]:='Members';
      A[2]:='Books';
      A[3]:='Issued  Books';
      A[4]:='Expired Books';
      TOTAL:=4; CURRENT:=1;
        X:=VX;
        Y:=COMMON_Y;
        XI:=VX+19;
        YI:=Y+TOTAL+1;
   END;
  WITH SEARCH_REC DO
  BEGIN
      A[1]:='Members';
      A[2]:='Books';
      A[3]:='Issued  Books';
      A[4]:='Expired Books';
      TOTAL:=4; CURRENT:=1;
        X:=SEARCHX;
        Y:=COMMON_Y;
        XI:=SEARCHX+19;
        YI:=Y+TOTAL+1;
  END;
  WITH SORT_REC DO
  BEGIN
      A[1]:='Members';
      A[2]:='Books';
      A[3]:='Issued  Books';
      A[4]:='Expired Books';
      A[5]:='Set Option';
      TOTAL:=5; CURRENT:=1;
        X:=SORTX;
        Y:=COMMON_Y;
        XI:=SORTX+19;
        YI:=Y+TOTAL+1;
  END;
   WITH OTHER_REC DO
  BEGIN
      A[1]:='Exit';
      A[2]:='About';
      TOTAL:=2; CURRENT:=1;
        X:=EXITX;
        Y:=COMMON_Y;
        XI:=EXITX+10;
        YI:=Y+TOTAL+1;
  END;
 WITH J[1] DO BEGIN NAME:='Member'; X:=MX-1; XI:=MX+8; END;
 WITH J[2] DO BEGIN NAME:='Book';   X:=BX-1; XI:=BX+6; END;
 WITH J[3] DO BEGIN NAME:='Issue';  X:=IX-1; XI:=IX+7; END;
 WITH J[4] DO BEGIN NAME:='View';   X:=VX-1; XI:=VX+6; END;
 WITH J[5] DO BEGIN NAME:='Search'; X:=SEARCHX-1; XI:=SEARCHX+8; END;
 WITH J[6] DO BEGIN NAME:='Sort';   X:=SORTX-1;   XI:=SORTX+6;   END;
 WITH J[7] DO BEGIN NAME:='Other';   X:=EXITX-1;   XI:=EXITX+6;   END;
 INITIALSCREEN;
 SAVESCREEN(1); IDENTIFICATION; DATES; RESTORESCREEN(1);
 OPTIONS;
 TEXTBACKGROUND(BLACK); TEXTCOLOR(WHITE);
 RESET(SFILE,1); BLOCKREAD(SFILE,SCREEN^,4000);
 GOTOXY(OLD_CURSOR[1],OLD_CURSOR[2]);
 {$I-}
 CLOSE(MEMBER_FILE); CLOSE(BOOK_FILE);
 CLOSE(ISSUE_FILE);  CLOSE(EXPIRY_FILE);
 {$I+} MAKECURSOR(ON);
END.