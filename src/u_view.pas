UNIT U_VIEW;
INTERFACE
USES CRT,U_TOOL,LIBS;

PROCEDURE VIEW_MEMBER(REC:MEMBER_RECORD);
PROCEDURE VIEW_BOOK(REC:BOOK_RECORD);
PROCEDURE VIEW_ISSUE(REC:ISSUE_RECORD);
PROCEDURE VIEW_EXPIRY(REC:EXPIRY_RECORD);

PROCEDURE VIEWSPECIFIC_MEMBER;
PROCEDURE VIEWSPECIFIC_BOOK;
PROCEDURE VIEWSPECIFIC_ISSUE;
PROCEDURE VIEWSPECIFIC_EXPIRY;

IMPLEMENTATION
VAR D:CHAR;
  ALL:BOOLEAN;
  CHOICE:KEYTYPE;
  PX,PY:INTEGER;
PROCEDURE VIEW_MEMBER(REC:MEMBER_RECORD);
VAR R:MEMBER_RECORD;
    ALL:BOOLEAN;
BEGIN
   RESET(MEMBER_FILE);
     IF FILESIZE(MEMBER_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT;   END;
   R:=REC;
  IF NOT SEARCH_MEMBER(MEMBER_FILE,R) THEN
  ALL:=TRUE ELSE ALL:=FALSE;
  IF ALL THEN
  BEGIN
  RESET(MEMBER_FILE); READ(MEMBER_FILE,R);
        RESET(MEMBER_FILE); END;
   DISPLAY_MEMBER(R);
      D:=READKEY;
     CHOICE:=CODES(D);
     WHILE CHOICE<>ESC DO
     BEGIN
    CASE CHOICE OF
     ESC:EXIT;
     UP :IF (ALL) AND (FILEPOS(MEMBER_FILE)<>0) THEN
          BEGIN SEEK(MEMBER_FILE,FILEPOS(MEMBER_FILE)-1);
                READ(MEMBER_FILE,R);
                DISPLAY_MEMBER(R);
                SEEK(MEMBER_FILE,FILEPOS(MEMBER_FILE)-1);
          END
          ELSE
          IF (ALL) AND (FILEPOS(MEMBER_FILE)=0) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_MEMBER(MEMBER_FILE,R) THEN
           DISPLAY_MEMBER(R) ELSE  BEEP;
          END;
    DOWN:IF (ALL) AND (FILEPOS(MEMBER_FILE)<>FILESIZE(MEMBER_FILE)-1) THEN
          BEGIN SEEK(MEMBER_FILE,FILEPOS(MEMBER_FILE)+1);
                READ(MEMBER_FILE,R);
                DISPLAY_MEMBER(R);
                SEEK(MEMBER_FILE,FILEPOS(MEMBER_FILE)-1);
          END
          ELSE
          IF (ALL)AND (FILEPOS(MEMBER_FILE)=FILESIZE(MEMBER_FILE)-1) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_MEMBER(MEMBER_FILE,R) THEN
           DISPLAY_MEMBER(R) ELSE BEEP;
          END;
    PGDN: IF ALL THEN
          BEGIN SEEK(MEMBER_FILE,FILESIZE(MEMBER_FILE)-1);
                READ(MEMBER_FILE,R); DISPLAY_MEMBER(R);
                SEEK(MEMBER_FILE,FILESIZE(MEMBER_FILE)-1);
          END;
    PGUP: IF ALL THEN
          BEGIN RESET(MEMBER_FILE); READ(MEMBER_FILE,R);
                DISPLAY_MEMBER(R);  RESET(MEMBER_FILE);
          END;
       ELSE  BEEP;
    END;
    D:=READKEY;
    CHOICE:=CODES(D);
    END;
    CLOSE(MEMBER_FILE);
END;

PROCEDURE VIEW_BOOK(REC:BOOK_RECORD);
VAR R:BOOK_RECORD; ALL:BOOLEAN;
BEGIN
   RESET(BOOK_FILE);
     IF FILESIZE(BOOK_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT;   END;
   R:=REC;
  IF NOT SEARCH_BOOK(BOOK_FILE,R) THEN
  ALL:=TRUE ELSE ALL:=FALSE;
   IF ALL THEN
   BEGIN RESET(BOOK_FILE); READ(BOOK_FILE,R); RESET(BOOK_FILE); END;
   DISPLAY_BOOK(R);
      D:=READKEY;
      CHOICE:=CODES(D);
  WHILE CHOICE<>ESC DO
  BEGIN
    CASE CHOICE OF
     ESC:EXIT;
     UP :IF (ALL) AND (FILEPOS(BOOK_FILE)<>0) THEN
          BEGIN SEEK(BOOK_FILE,FILEPOS(BOOK_FILE)-1);
                READ(BOOK_FILE,R);
                DISPLAY_BOOK(R);
                SEEK(BOOK_FILE,FILEPOS(BOOK_FILE)-1);
          END
          ELSE
          IF (ALL) AND (FILEPOS(BOOK_FILE)=0) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_BOOK(BOOK_FILE,R) THEN
           DISPLAY_BOOK(R) ELSE BEEP;
          END;
    DOWN:IF (ALL) AND (FILEPOS(BOOK_FILE)<>FILESIZE(BOOK_FILE)-1) THEN
          BEGIN SEEK(BOOK_FILE,FILEPOS(BOOK_FILE)+1);
                READ(BOOK_FILE,R);
                DISPLAY_BOOK(R);
                SEEK(BOOK_FILE,FILEPOS(BOOK_FILE)-1);
          END
          ELSE
          IF (ALL)AND (FILEPOS(BOOK_FILE)=FILESIZE(BOOK_FILE)-1) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          {IF EOF(BOOK_FILE) THEN RESET(MEMBER_FILE);}
          R:=REC;
          IF SEARCH_BOOK(BOOK_FILE,R) THEN
           DISPLAY_BOOK(R) ELSE BEEP;
          {RESET(BOOK_FILE); }
          END;
    PGDN: IF ALL THEN
          BEGIN SEEK(BOOK_FILE,FILESIZE(BOOK_FILE)-1);
                READ(BOOK_FILE,R); DISPLAY_BOOK(R);
                SEEK(BOOK_FILE,FILESIZE(BOOK_FILE)-1);
          END;
    PGUP: IF ALL THEN
          BEGIN RESET(BOOK_FILE); READ(BOOK_FILE,R);
                DISPLAY_BOOK(R);  RESET(BOOK_FILE);
          END;
      ELSE BEEP;
    END;
        D:=READKEY;
    CHOICE:=CODES(D);
    END;
    CLOSE(BOOK_FILE);
END;

PROCEDURE VIEW_ISSUE(REC:ISSUE_RECORD);
VAR R:ISSUE_RECORD;
BEGIN
   RESET(ISSUE_FILE);
   IF FILESIZE(ISSUE_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT;   END;
   R:=REC;
  IF NOT SEARCH_ISSUE(ISSUE_FILE,R) THEN
  ALL:=TRUE ELSE ALL:=FALSE;
    IF ALL THEN
    BEGIN RESET(ISSUE_FILE); READ(ISSUE_FILE,R); RESET(ISSUE_FILE); END;
   DISPLAY_ISSUE(R);
      D:=READKEY;
     CHOICE:=CODES(D);
  WHILE CHOICE<>ESC DO
  BEGIN
    CASE CHOICE OF
     ESC:EXIT;
     UP :IF (ALL) AND (FILEPOS(ISSUE_FILE)<>0) THEN
          BEGIN SEEK(ISSUE_FILE,FILEPOS(ISSUE_FILE)-1);
                READ(ISSUE_FILE,R);
                DISPLAY_ISSUE(R);
                SEEK(ISSUE_FILE,FILEPOS(ISSUE_FILE)-1);
          END
          ELSE
          IF (ALL) AND (FILEPOS(ISSUE_FILE)=0) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_ISSUE(ISSUE_FILE,R) THEN
           DISPLAY_ISSUE(R) ELSE    BEEP;
          END;
    DOWN:IF (ALL) AND (FILEPOS(ISSUE_FILE)<>FILESIZE(ISSUE_FILE)-1) THEN
          BEGIN SEEK(ISSUE_FILE,FILEPOS(ISSUE_FILE)+1);
                READ(ISSUE_FILE,R);
                DISPLAY_ISSUE(R);
                SEEK(ISSUE_FILE,FILEPOS(ISSUE_FILE)-1);
          END
          ELSE
          IF (ALL)AND (FILEPOS(ISSUE_FILE)=FILESIZE(ISSUE_FILE)-1) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_ISSUE(ISSUE_FILE,R) THEN
           DISPLAY_ISSUE(R) ELSE BEEP;
          END;
    PGDN: IF ALL THEN
          BEGIN SEEK(ISSUE_FILE,FILESIZE(ISSUE_FILE)-1);
                READ(ISSUE_FILE,R); DISPLAY_ISSUE(R);
                SEEK(ISSUE_FILE,FILESIZE(ISSUE_FILE)-1);
          END;
    PGUP: IF ALL THEN
          BEGIN RESET(ISSUE_FILE); READ(ISSUE_FILE,R);
                DISPLAY_ISSUE(R);  RESET(ISSUE_FILE);
          END;
    ELSE BEEP;
    END;
        D:=READKEY;
    CHOICE:=CODES(D);
   END;
    CLOSE(ISSUE_FILE);
END;

PROCEDURE VIEW_EXPIRY(REC:EXPIRY_RECORD);
VAR R:EXPIRY_RECORD;
BEGIN
   RESET(EXPIRY_FILE);
     IF FILESIZE(EXPIRY_FILE)=0 THEN
   BEGIN PRINT_ERROR(FILE_IS_EMPTY); EXIT;   END;
   R:=REC;
  IF NOT SEARCH_EXPIRY(EXPIRY_FILE,R) THEN
  ALL:=TRUE ELSE ALL:=FALSE;
  IF ALL THEN BEGIN RESET(EXPIRY_FILE); READ(EXPIRY_FILE,R);
                    RESET(EXPIRY_FILE); END;
   DISPLAY_EXPIRY(R);
      D:=READKEY;
      CHOICE:=CODES(D);
   WHILE CHOICE<>ESC DO
   BEGIN
    CASE CHOICE OF
     ESC:EXIT;
     UP :IF (ALL) AND (FILEPOS(EXPIRY_FILE)<>0) THEN
          BEGIN SEEK(EXPIRY_FILE,FILEPOS(EXPIRY_FILE)-1);
                READ(EXPIRY_FILE,R);
                DISPLAY_EXPIRY(R);
                SEEK(EXPIRY_FILE,FILEPOS(EXPIRY_FILE)-1);
          END
          ELSE
          IF (ALL) AND (FILEPOS(EXPIRY_FILE)=0) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_EXPIRY(EXPIRY_FILE,R) THEN
           DISPLAY_EXPIRY(R) ELSE BEEP;
          END;
    DOWN:IF (ALL) AND (FILEPOS(EXPIRY_FILE)<>FILESIZE(EXPIRY_FILE)-1) THEN
          BEGIN SEEK(EXPIRY_FILE,FILEPOS(EXPIRY_FILE)+1);
                READ(EXPIRY_FILE,R);
                DISPLAY_EXPIRY(R);
                SEEK(EXPIRY_FILE,FILEPOS(EXPIRY_FILE)-1);
          END
          ELSE
          IF (ALL)AND (FILEPOS(EXPIRY_FILE)=FILESIZE(EXPIRY_FILE)-1) THEN BEEP
          ELSE
          IF NOT ALL THEN
          BEGIN
          R:=REC;
          IF SEARCH_EXPIRY(EXPIRY_FILE,R) THEN
           DISPLAY_EXPIRY(R) ELSE BEEP;
          END;
    PGDN: IF ALL THEN
          BEGIN SEEK(EXPIRY_FILE,FILESIZE(EXPIRY_FILE)-1);
                READ(EXPIRY_FILE,R); DISPLAY_EXPIRY(R);
                SEEK(EXPIRY_FILE,FILESIZE(EXPIRY_FILE)-1);
          END;
    PGUP: IF ALL THEN
          BEGIN RESET(EXPIRY_FILE); READ(EXPIRY_FILE,R);
                DISPLAY_EXPIRY(R);  RESET(EXPIRY_FILE);
          END;
    ELSE BEEP;
    END;
        D:=READKEY;
    CHOICE:=CODES(D);
  END;
    CLOSE(EXPIRY_FILE);
END;

PROCEDURE VIEWSPECIFIC_MEMBER;
VAR M,TEMP:MEMBER_RECORD;
    D_REC:DISPLAY_RECORD;
    DT:DATE_TYPE;
    K:STRING;
    V,ECODE:INTEGER;
    CHOICE:KEYTYPE;
BEGIN
       WITH D_REC DO
       BEGIN
         A[1]:='By Name';
         A[2]:='By Membership Number';
         A[3]:='By Date Of Birth';
         CURRENT:=1;
         TOTAL:=3;
         X:=38;
         Y:=8;
         XI:=X+24;
         YI:=Y+TOTAL+1;
       END;
        DRAWBAR(D_REC);
      REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
             CASE CHOICE OF
             UP    :UPARROW(D_REC);
             DOWN  :DOWNARROW(D_REC);
             ESC   :{EXIT};
             ENTER :BEGIN
                         SAVESCREEN(2);
                        CASE D_REC.CURRENT OF
                        1:BEGIN
                           K:='MEMBER NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_MEMBER(M);
                           M.NAME:=K;
                           TEMP:=M;
                           RESET(MEMBER_FILE);
                           IF NOT SEARCH_MEMBER(MEMBER_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_MEMBER(M);
                           END;
                          END;  {1}
                        2:BEGIN
                           K:='MEMBER ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_MEMBER(M);
                           VAL(K,V,ECODE);
                           M.ID:=V;
                           TEMP:=M;
                           RESET(MEMBER_FILE);
                           IF NOT SEARCH_MEMBER(MEMBER_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_MEMBER(M);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='MEMBER DOB :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           IF ST2DT(K,DT) THEN
                           BEGIN
                           INITIALIZE_MEMBER(M);
                           M.DOB:=DT;
                           TEMP:=M;
                           RESET(MEMBER_FILE);
                           IF NOT SEARCH_MEMBER(MEMBER_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_MEMBER(M);
                           END;
                          END;
                          END;  {3}
                        END;{CASE}
                        RESTORESCREEN(2);
                      END;{ENTER}
              END;{CASE}
        UNTIL CHOICE=ESC;
END;

PROCEDURE VIEWSPECIFIC_BOOK;
VAR M,TEMP:BOOK_RECORD;
    D_REC:DISPLAY_RECORD;
    DT:DATE_TYPE;
    K:STRING;
    V,ECODE:INTEGER;
    CHOICE:KEYTYPE;
BEGIN
       WITH D_REC DO
       BEGIN
         A[1]:='By Name';
         A[2]:='By Book ID';
         A[3]:='By Auther''s Name';
           CURRENT:=1;
         TOTAL:=3;
         X:=38;
         Y:=9;
         XI:=X+34;
         YI:=Y+TOTAL+1;
       END;
        DRAWBAR(D_REC);
      REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
             CASE CHOICE OF
             UP    :UPARROW(D_REC);
             DOWN  :DOWNARROW(D_REC);
             ESC   :{EXIT};
             ENTER :BEGIN
                        SAVESCREEN(2);
                        CASE D_REC.CURRENT OF
                        1:BEGIN
                           K:='BOOK NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_BOOK(M);
                           M.NAME:=K;
                           TEMP:=M;
                           RESET(BOOK_FILE);
                           IF NOT SEARCH_BOOK(BOOK_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_BOOK(M);
                           END;
                          END;  {1}
                        2:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_BOOK(M);
                           VAL(K,V,ECODE);
                           M.ID:=V;
                           TEMP:=M;
                           RESET(BOOK_FILE);
                           IF NOT SEARCH_BOOK(BOOK_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_BOOK(M);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='AUTHER''S NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_BOOK(M);
                           M.AUTHOR:=K;
                           TEMP:=M;
                           RESET(BOOK_FILE);
                           IF NOT SEARCH_BOOK(BOOK_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_BOOK(M);
                           END;
                          END;  {3}
                        END;{CASE}
                        RESTORESCREEN(2);
                      END;{ENTER}
              END;{CASE}
        UNTIL CHOICE=ESC;
END;

PROCEDURE VIEWSPECIFIC_ISSUE;
VAR M,TEMP:ISSUE_RECORD;
    D_REC:DISPLAY_RECORD;
    DT:DATE_TYPE;
    K:STRING;
    V,ECODE:INTEGER;
    CHOICE:KEYTYPE;
BEGIN
       WITH D_REC DO
       BEGIN
         A[1]:='By Member''s Name';
         A[2]:='By Member ID';
         A[3]:='By Book''s Name';
         A[4]:='By Book ID';
         A[5]:='By Date Of Issue';
         CURRENT:=1;
         TOTAL:=5;
         X:=38;
         Y:=10;
         XI:=X+24;
         YI:=Y+TOTAL+1;
       END;
        DRAWBAR(D_REC);
      REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
             CASE CHOICE OF
             UP    :UPARROW(D_REC);
             DOWN  :DOWNARROW(D_REC);
             ESC   :{EXIT};
             ENTER :BEGIN
                         SAVESCREEN(2);
                        CASE D_REC.CURRENT OF
                        1:BEGIN
                           K:='MEMBER''S NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_ISSUE(M);
                           M.M_NAME:=K;
                           TEMP:=M;
                           RESET(ISSUE_FILE);
                           IF NOT SEARCH_ISSUE(ISSUE_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_ISSUE(M);
                           END;
                          END;  {1}
                        2:BEGIN
                           K:='ISSUE ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_ISSUE(M);
                           VAL(K,V,ECODE);
                           M.M_ID:=V;
                           TEMP:=M;
                           RESET(ISSUE_FILE);
                           IF NOT SEARCH_ISSUE(ISSUE_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_ISSUE(M);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='BOOK''S NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_ISSUE(M);
                           M.B_NAME:=K;
                           TEMP:=M;
                           RESET(ISSUE_FILE);
                           IF NOT SEARCH_ISSUE(ISSUE_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_ISSUE(M);
                           END;
                          END;  {1}
                        4:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_ISSUE(M);
                           VAL(K,V,ECODE);
                           M.B_ID:=V;
                           TEMP:=M;
                           RESET(ISSUE_FILE);
                           IF NOT SEARCH_ISSUE(ISSUE_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_ISSUE(M);
                           END;
                          END;  {2}
                        5:BEGIN
                           K:='DATE OF ISSUE :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           IF ST2DT(K,DT) THEN
                           BEGIN
                           INITIALIZE_ISSUE(M);
                           M.DOI:=DT;
                           TEMP:=M;
                           RESET(ISSUE_FILE);
                           IF NOT SEARCH_ISSUE(ISSUE_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_ISSUE(M);
                           END;
                          END;
                          END;  {3}
                        END;{CASE}
                        RESTORESCREEN(2);
                      END;{ENTER}
              END;{CASE}
        UNTIL CHOICE=ESC;
END;

PROCEDURE VIEWSPECIFIC_EXPIRY;
VAR M,TEMP:EXPIRY_RECORD;
    D_REC:DISPLAY_RECORD;
    DT:DATE_TYPE;
    K:STRING;
    V,ECODE:INTEGER;
    CHOICE:KEYTYPE;
BEGIN
       WITH D_REC DO
       BEGIN
         A[1]:='By Member''s Name';
         A[2]:='By Member ID';
         A[3]:='By Book''s Name:';
         A[4]:='By Book ID';
         A[5]:='By Date Of Expiry';
         CURRENT:=1;
         TOTAL:=5;
         X:=38;
         Y:=11;
         XI:=X+24;
         YI:=Y+TOTAL+1;
       END;
        DRAWBAR(D_REC);
      REPEAT
            D:=READKEY;
            CHOICE:=CODES(D);
             CASE CHOICE OF
             UP    :UPARROW(D_REC);
             DOWN  :DOWNARROW(D_REC);
             ESC   :{EXIT};
             ENTER :BEGIN
                         SAVESCREEN(2);
                        CASE D_REC.CURRENT OF
                        1:BEGIN
                           K:='MEMBER''S NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_EXPIRY(M);
                           M.M_NAME:=K;
                           TEMP:=M;
                           RESET(EXPIRY_FILE);
                           IF NOT SEARCH_EXPIRY(EXPIRY_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_EXPIRY(M);
                           END;
                          END;  {1}
                        2:BEGIN
                           K:='EXPIRY ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_EXPIRY(M);
                           VAL(K,V,ECODE);
                           M.M_ID:=V;
                           TEMP:=M;
                           RESET(EXPIRY_FILE);
                           IF NOT SEARCH_EXPIRY(EXPIRY_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_EXPIRY(M);
                           END;
                          END;  {2}
                        3:BEGIN
                           K:='BOOK''S NAME :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           INITIALIZE_EXPIRY(M);
                           M.B_NAME:=K;
                           TEMP:=M;
                           RESET(EXPIRY_FILE);
                           IF NOT SEARCH_EXPIRY(EXPIRY_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_EXPIRY(M);
                           END;
                          END;  {1}
                        4:BEGIN
                           K:='BOOK ID :';
                           IF NOT ASK(K,PX,PY,1) THEN
                           BEGIN
                           INITIALIZE_EXPIRY(M);
                           VAL(K,V,ECODE);
                           M.B_ID:=V;
                           TEMP:=M;
                           RESET(EXPIRY_FILE);
                           IF NOT SEARCH_EXPIRY(EXPIRY_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_EXPIRY(M);
                           END;
                          END;  {2}
                        5:BEGIN
                           K:='DATE OF EXPIRY :';
                           IF NOT ASK(K,PX,PY,0) THEN
                           BEGIN
                           IF ST2DT(K,DT) THEN
                           BEGIN
                           INITIALIZE_EXPIRY(M);
                           M.DOE:=DT;
                           TEMP:=M;
                           RESET(EXPIRY_FILE);
                           IF NOT SEARCH_EXPIRY(EXPIRY_FILE,TEMP) THEN
                           PRINT_ERROR(RECORD_NOT_FOUND) ELSE
                           VIEW_EXPIRY(M);
                           END;
                          END;
                          END;  {3}
                        END;{CASE}
                        RESTORESCREEN(2);
                      END;{ENTER}
              END;{CASE}
        UNTIL CHOICE=ESC;
END;
BEGIN
  PX:=8;  PY:=12;
END.
