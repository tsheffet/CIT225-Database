-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab9.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql

-- Open log file.
SPOOL apply_oracle_lab9.txt

CREATE SEQUENCE transaction_s1 START WITH 1;

CREATE TABLE transaction
( transaction_id         NUMBER         
, transaction_account    VARCHAR2(15)       CONSTRAINT nn1_transaction not null  
, transaction_type       NUMBER             CONSTRAINT nn2_transaction not null
, transaction_date       DATE               CONSTRAINT nn3_transaction not null
, transaction_amount     NUMBER             CONSTRAINT nn4_transaction not null
, rental_id              NUMBER             CONSTRAINT nn5_transaction not null
, payment_method_type    NUMBER             CONSTRAINT nn6_transaction not null
, payment_account_number VARCHAR2(19)       CONSTRAINT nn7_transaction not null
, created_by             NUMBER             CONSTRAINT nn8_transaction not null
, creation_date          DATE               CONSTRAINT nn9_transaction not null
, last_updated_by        NUMBER             CONSTRAINT nn10_transaction not null
, last_update_date       DATE               CONSTRAINT nn11_transaction not null 
, CONSTRAINT pk_transaction_1   PRIMARY KEY(transaction_id)
, CONSTRAINT fk_transaction_1   FOREIGN KEY(transaction_type)
REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_2   FOREIGN KEY(rental_id)
REFERENCES rental(rental_id)
, CONSTRAINT fk_transaction_3   FOREIGN KEY(payment_method_type)
REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_transaction_4   FOREIGN KEY(created_by)
REFERENCES system_user(system_user_id)
, CONSTRAINT fk_transaction_5   FOREIGN KEY(last_updated_by)
REFERENCES system_user(system_user_id));

-- verify table --
COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN columb_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT  table_name
,       column_id
,       column_name
,       CASE
            WHEN nullable = 'N' THEN 'NOT NULL'
            ELSE ''
        END AS nullable
,       CASE
            WHEN data_type IN ('CHAR', 'VARCHAR2', 'NUMBER') THEN
                data_type||'('||data_length||')'
            ELSE
                data_type
            END AS data_type
FROM    user_tab_columns
WHERE   table_name = 'TRANSACTION'
ORDER BY 2;



-- create the natural key --


CREATE UNIQUE INDEX natural_key
ON transaction (rental_id
, transaction_type
, transaction_date
, payment_method_type
, payment_account_number
, transaction_account);


COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'TRANSACTION'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NATURAL_KEY';



-- step 2 --
INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
      VALUES ( common_lookup_s1.nextval
, 'CREDIT'
, 'Credit'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'CR');

INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES ( common_lookup_s1.nextval
, 'DEBIT'
, 'Debit'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'TRANSACTION_TYPE'
, 'DR');

-- payment_method_type --

INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES ( common_lookup_s1.nextval
, 'DISCOVER_CARD'
, 'Discover_Card'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');


INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES ( common_lookup_s1.nextval
, 'VISA_CARD'
, 'Visa_Card'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');


INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES ( common_lookup_s1.nextval
, 'MASTER_CARD'
, 'Master_Card'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup
(common_lookup_id
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date
, common_lookup_table
, common_lookup_column
, common_lookup_code)
VALUES ( common_lookup_s1.nextval
, 'CASH'
, 'Cash'
, 1001
, sysdate
, 1001
, sysdate
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');


-- verify --

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'TRANSACTION'
AND      common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;



-- step 3 --
CREATE SEQUENCE airport_s1 START WITH 1;


CREATE TABLE airport
( airport_id        NUMBER
, airport_code      VARCHAR2(3)     constraint nn1_airport not null
, airport_city      VARCHAR2(30)    constraint nn2_airport not null
, city              VARCHAR2(30)    constraint nn3_airport not null
, state_province  VARCHAR2(30)    constraint nn4_airport not null
, created_by        NUMBER          constraint nn5_airport not null
, creation_date     DATE            constraint nn6_airport not null
, last_updated_by   NUMBER          constraint nn7_airport not null
, last_update_date  DATE            constraint nn8_airport not null
, constraint pk_airport_1       primary key(airport_id)
, constraint fk_airport_1       FOREIGN key(created_by)
references system_user(system_user_id)
, constraint fk_airport_2       FOREIGN key(last_updated_by)
references system_user(system_user_id));



-- veridy --
COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'AIRPORT'
ORDER BY 2;



-- create unique natural key NK_AIRPORT) index --
CREATE UNIQUE INDEX nk_airport
ON airport (airport_code
, airport_city
, city
, state_province);



-- verify --
COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'AIRPORT'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NK_AIRPORT';


-- create the seed --


INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 1001
, sysdate
, 1001
, sysdate);


INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 1001
, sysdate
, 1001
, sysdate);



INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 1001
, sysdate
, 1001
, sysdate);



INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'SFO'
, 'San Francisco'
, 'San Francisco'
, 'California'
, 1001
, sysdate
, 1001
, sysdate);



INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 1001
, sysdate
, 1001
, sysdate);



INSERT INTO airport
( airport_id
, airport_code
, airport_city
, city
, state_province
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES (airport_s1.nextval
, 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 1001
, sysdate
, 1001
, sysdate);

-- verify --

COLUMN code           FORMAT A4  HEADING "Code"
COLUMN airport_city   FORMAT A14 HEADING "Airport City"
COLUMN city           FORMAT A14 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
SELECT   airport_code AS code
,        airport_city
,        city
,        state_province
FROM     airport;



-- create account_list & sequence S1 --
CREATE TABLE account_list
( account_list_id       NUMBER  
, account_number       VARCHAR2(10)    constraint nn1_account_list not null 
, consumed_date         DATE            
, consumed_by          NUMBER          
, created_by            NUMBER          constraint nn2_account_list not null
, creation_date         DATE            constraint nn3_account_list not null
, last_updated_by       NUMBER          constraint nn4_account_list not null
, last_update_date      DATE            constraint nn5_account_list not null
, constraint pk_account_list_1          primary key(account_list_id)
, constraint fk_account_list_1          FOREIGN key(consumed_by)
references system_user(system_user_id)
, constraint fk_account_list_2          FOREIGN key(created_by)
references system_user(system_user_id)
, constraint fk_account_list_3          FOREIGN key(last_updated_by)
references system_user(system_user_id));


CREATE SEQUENCE account_list_s1 START WITH 1;


-- verify --
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ACCOUNT_LIST'
ORDER BY 2;



-- seeding code --
-- Create or replace seeding procedure.
CREATE OR REPLACE PROCEDURE seed_account_list IS
  /* Declare variable to capture table, and column. */
  lv_table_name   VARCHAR2(90);
  lv_column_name  VARCHAR2(30);
 
  /* Declare an exception variable and PRAGMA map. */
  not_null_column  EXCEPTION;
  PRAGMA EXCEPTION_INIT(not_null_column,-1400);
 
BEGIN
  /* Set savepoint. */
  SAVEPOINT all_or_none;
 
  FOR i IN (SELECT DISTINCT airport_code FROM airport) LOOP
    FOR j IN 1..50 LOOP
 
      INSERT INTO account_list
      VALUES
      ( account_list_s1.NEXTVAL
      , i.airport_code||'-'||LPAD(j,6,'0')
      , NULL
      , NULL
      , 1002
      , SYSDATE
      , 1002
      , SYSDATE);
    END LOOP;
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN not_null_column THEN
    /* Capture the table and column name that triggered the error. */
    lv_table_name := (TRIM(BOTH '"' FROM RTRIM(REGEXP_SUBSTR(SQLERRM,'".*\."',REGEXP_INSTR(SQLERRM,'\.',1,1)),'."')));
    lv_column_name := (TRIM(BOTH '"' FROM REGEXP_SUBSTR(SQLERRM,'".*"',REGEXP_INSTR(SQLERRM,'\.',1,2))));
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
    RAISE_APPLICATION_ERROR(
       -20001
      ,'Remove the NOT NULL contraint from the '||lv_column_name||' column in'||CHR(10)||' the '||lv_table_name||' table.');
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/


--execute the seed --
EXECUTE seed_account_list();


-- verify --
COLUMN object_name FORMAT A18
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'SEED_ACCOUNT_LIST';



-- another verify for the commit --
COLUMN airport FORMAT A7
SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY SUBSTR(account_number,1,3)
ORDER BY 1;


-- update the state province names to be full names --
UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';


UPDATE address
SET    state_province = 'Utah'
WHERE  state_province = 'UT';



-- procedure update_member_account -- 
CREATE OR REPLACE PROCEDURE update_member_account IS
 
  /* Declare a local variable. */
  lv_account_number VARCHAR2(10);
 
  /* Declare a SQL cursor fabricated from local variables. */  
  CURSOR member_cursor IS
    SELECT   DISTINCT
             m.member_id
    ,        a.city
    ,        a.state_province
    FROM     member m INNER JOIN contact c
    ON       m.member_id = c.member_id INNER JOIN address a
    ON       c.contact_id = a.contact_id
    ORDER BY m.member_id;
 
BEGIN
 
  /* Set savepoint. */  
  SAVEPOINT all_or_none;
 
  /* Open a local cursor. */  
  FOR i IN member_cursor LOOP
 
      /* Secure a unique account number as they're consumed from the list. */
      SELECT al.account_number
      INTO   lv_account_number
      FROM   account_list al INNER JOIN airport ap
      ON     SUBSTR(al.account_number,1,3) = ap.airport_code
      WHERE  ap.city = i.city
      AND    ap.state_province = i.state_province
      AND    consumed_by IS NULL
      AND    consumed_date IS NULL
      AND    ROWNUM < 2;
 
      /* Update a member with a unique account number linked to their nearest airport. */
      UPDATE member
      SET    account_number = lv_account_number
      WHERE  member_id = i.member_id;
 
      /* Mark consumed the last used account number. */      
      UPDATE account_list
      SET    consumed_by = 1002
      ,      consumed_date = SYSDATE
      WHERE  account_number = lv_account_number;
 
  END LOOP;
 
  /* Commit the writes as a group. */
  COMMIT;
 
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    dbms_output.put_line('You have an error in your AIRPORT table inserts.');
 
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
  WHEN OTHERS THEN
    /* This undoes all DML statements to this point in the procedure. */
    ROLLBACK TO SAVEPOINT all_or_none;
END;
/



-- verify --

COLUMN object_name FORMAT A22
COLUMN object_type FORMAT A12
SELECT   object_name
,        object_type
FROM     user_objects
WHERE    object_name = 'UPDATE_MEMBER_ACCOUNT';


-- execute procedure --
EXECUTE update_member_account();




-- script that creates update_member_account --
-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A7     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A12    HEADING "Address City"
COLUMN apstate        FORMAT A10    HEADING "Airport|State or|Province"
COLUMN alcode         FORMAT A5     HEADING "Airport|Account|Code"
 
-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.state_province AS apstate
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province INNER JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;




-- Reset the pagesize.
SET PAGESIZE 99
SET LINESIZE 92
 
-- Verify the account changes in the MEMBER table.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A9     HEADING "Last|Name"
COLUMN account_number FORMAT A10    HEADING "Account|Number"
COLUMN acity          FORMAT A14    HEADING "Address City"
COLUMN apcity         FORMAT A14    HEADING "Airport|List City"
COLUMN astate         FORMAT A10    HEADING "Address|State or|Province"
COLUMN apstate        FORMAT A10    HEADING "Airport|State or|Province"
COLUMN apcode         FORMAT A5     HEADING "Airport|Code"
COLUMN alcode         FORMAT A5     HEADING "Account|Airport|Code"
 
-- Run the query.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city AS acity
,        ap.city AS apcity
,        a.state_province AS astate
,        ap.state_province AS apstate
,        ap.airport_code AS apcode
,        SUBSTR(al.account_number,1,3) AS alcode
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id RIGHT JOIN airport ap
ON       a.city = ap.city
AND      a.state_province = ap.state_province RIGHT JOIN account_list al
ON       ap.airport_code = SUBSTR(al.account_number,1,3)
ORDER BY 1;
 
-- Reset the pagesize.
SET PAGESIZE 80


-- step 4 --
CREATE TABLE transaction_upload
( account_number        VARCHAR2(10)
, first_name            VARCHAR2(20)
, middle_name           VARCHAR2(20)
, last_name             VARCHAR2(20)
, check_out_date        DATE
, return_date           DATE
, return_item_type      VARCHAR2(12)
, transaction_type      VARCHAR2(14)
, transaction_amount    NUMBER
, transaction_date      DATE
, item_id               NUMBER
, payment_method_type   VARCHAR2(14)
, payment_account_number VARCHAR2(19))
    ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY upload
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload.csv'))
REJECT LIMIT UNLIMITED;




SET LONG 200000  -- Enables the display of the full statement.
SELECT   dbms_metadata.get_ddl('TABLE','TRANSACTION_UPLOAD') AS "Table Description"
FROM     dual;



SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;
-- ... insert lab 9 commands here ...


SPOOL OFF
