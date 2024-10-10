CREATE OR REPLACE PROCEDURE LOADLONGRAW
AS
  TOTAL_ROWS number;
  TABLE_ROWS number := 1;
  ROWS_AT_A_TIME number := 100;
BEGIN

  select count (*)
  into TOTAL_ROWS
  from DRUG_INCLU_APP_DOC;

  WHILE TABLE_ROWS <= TOTAL_ROWS
  LOOP
--    execute immediate 'truncate table DRUG_INCLU_APP_DOCLONG2LOB';  
--    execute immediate 'truncate table DRUG_INCLU_APP_DOCLONG2LOBtmp'; 


    insert into DRUG_INCLU_APP_DOCLONG2LOBtmp (SLNO, APPRV_LETTER, APPRV_LETTER_BLOB)
    SELECT 
      SLNO, to_lob(APPRV_LETTER), APPRV_LETTER_BLOB
    FROM DRUG_INCLU_APP_DOC
    WHERE ROWNUM between TABLE_ROWS and TABLE_ROWS + ROWS_AT_A_TIME;

    insert into DRUG_INCLU_APP_DOCLONG2LOB (SLNO, APPRV_LETTER, APPRV_LETTER_BLOB)
    SELECT 
      SLNO, APPRV_LETTER, APPRV_LETTER_BLOB
    FROM DRUG_INCLU_APP_DOCLONG2LOBtmp;

    commit;

    TABLE_ROWS := TABLE_ROWS + ROWS_AT_A_TIME;
  END LOOP;

  commit;

end;

exec LOADLONGRAW();
