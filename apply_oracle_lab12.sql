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
--   sql> @apply_oracle_lab12.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab11/apply_oracle_lab11.sql

-- Spool log file.
SPOOL apply_oracle_lab12.txt


create table calendar
( calendar_id           NUMBER
, calendar_name         VARCHAR2(10)    constraint nn1_cal not null
, calendar_short_name   VARCHAR2(3)     constraint nn2_cal not null
, start_date            DATE            constraint nn3_cal not null
, end_date              DATE            constraint nn4_cal not null
, created_by            NUMBER          constraint nn5_cal not null
, creation_date         DATE            constraint nn6_cal not null
, last_updated_by       NUMBER          constraint nn7_cal not null
, last_update_date      DATE            constraint nn8_cal not null
, CONSTRAINT pk_calendar_1      PRIMARY KEY(calendar_id)
, CONSTRAINT fk_calendar_1      FOREIGN KEY(created_by)
REFERENCES system_user(system_user_id)
, CONSTRAINT fk_calendar_2      FOREIGN KEY(last_updated_by)
REFERENCES system_user(system_user_id));



--verify calendar--
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'CALENDAR'
ORDER BY 2;


-- verify constraints --

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition"
COLUMN constraint_type   FORMAT A1   HEADING "C|T"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('calendar')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;




-- verify FK --
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
,       'REFERENCES'||CHR(10)
||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
,        user_cons_columns ucc1
,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
AND      uc.r_constraint_name = ucc2.constraint_name
AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
AND      uc.constraint_type = 'R'
AND      ucc1.table_name = 'CALENDAR'
ORDER BY ucc1.table_name
,        uc.constraint_name;



-- SEQUENCE --
create sequence calendar_s1 start with 1;


-- step 2 --


insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'January'
, 'JAN'
, '01-JAN-2009'
, '31-JAN-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'February'
, 'FEB'
, '01-FEB-2009'
, '28-FEB-2009'
, 1001
, sysdate
, 1001
, sysdate);




insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'March'
, 'MAR'
, '01-MAR-2009'
, '31-MAR-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'April'
, 'APR'
, '01-APR-2009'
, '30-APR-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'May'
, 'MAY'
, '01-MAY-2009'
, '31-MAY-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'June'
, 'JUN'
, '01-JUN-2009'
, '30-JUN-2009'
, 1001
, sysdate
, 1001
, sysdate);




insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'July'
, 'JUL'
, '01-JUL-2009'
, '31-JUL-2009'
, 1001
, sysdate
, 1001
, sysdate);




insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'August'
, 'AUG'
, '01-AUG-2009'
, '31-AUG-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'September'
, 'SEP'
, '01-SEP-2009'
, '30-SEP-2009'
, 1001
, sysdate
, 1001
, sysdate);


insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'October'
, 'OCT'
, '01-OCT-2009'
, '31-OCT-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'November'
, 'NOV'
, '01-NOV-2009'
, '30-NOV-2009'
, 1001
, sysdate
, 1001
, sysdate);



insert into calendar
( calendar_id
, calendar_name
, calendar_short_name
, start_date
, end_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
values
( calendar_s1.nextval
, 'December'
, 'DEC'
, '01-DEC-2009'
, '31-DEC-2009'
, 1001
, sysdate
, 1001
, sysdate);



-- verify --


COL calendar_name        FORMAT A10  HEADING "Calendar|Name"
COL calendar_short_name  FORMAT A8  HEADING "Calendar|Short|Name"
COL start_date           FORMAT A9   HEADING "Start|Date"
COL end_date             FORMAT A9   HEADING "End|Date"
SELECT   calendar_name
,        calendar_short_name
,        start_date
,        end_date
FROM     calendar;
-- ... insert lab 12 commands here ...



-- step 3 --


CREATE TABLE transaction_reversal
   (    "TRANSACTION_ID" number
   ,    "TRANSACTION_ACCOUNT" VARCHAR2(15)
   ,    "TRANSACTION_TYPE" number
   ,    "TRANSACTION_DATE" date
   ,    "TRANSACTION_AMOUNT" number
   ,    "RENTAL_ID" number
   ,    "PAYMENT_METHOD_TYPE" number
   ,    "PAYMENT_ACCOUNT_NUMBER" varchar2(19)
   ,    "CREATED_BY" number
   ,    "CREATED_DATE" date
   ,    "LAST_UPDATED_BY" number
   ,    "LAST_UPDATE_DATE" date)
   ORGANIZATION EXTERNAL
    ( TYPE ORACLE_LOADER
      DEFAULT DIRECTORY "UPLOAD"
      ACCESS PARAMETERS
      ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL     )
      LOCATION
       ( 'transaction_upload2.csv'
       )
    )
reject limit unlimited;







-- Move the data from TRANSACTION_REVERSAL to TRANSACTION.
INSERT INTO TRANSACTION
(SELECT transaction_s1.nextval
, transaction_account
, transaction_type
, transaction_date
, (transaction_amount/1.06)
, rental_id
, payment_method_type
, PAYMENT_ACCOUNT_NUMBER
, 1001
, sysdate
, 1001
, sysdate
 FROM    transaction_reversal);
 
 
 
 
 COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;
        
        
        
        
        
        
        
        
-- STEP 4 --


SELECT   CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
         END AS "TRANSACTION_ACCOUNT"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JANUARY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FEBRUARY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MARCH"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F1Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "APRIL"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUNE"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F2Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JULY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "AUGUST"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "SEPTEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F3Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "OCTOBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "NOVEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "DECEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F4Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' 
GROUP BY CASE
           WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
           WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
        END
UNION ALL
SELECT 'TOTAL' AS "TRANSACTION_ACCOUNT"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 1 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JANUARY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 2 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "FEBRUARY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 3 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MARCH"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F1Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 4 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "APRIL"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 5 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "MAY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 6 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JUNE"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (4, 5, 6) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F2Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 7 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "JULY"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 8 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "AUGUST"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 9 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "SEPTEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (7, 8, 9) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F3Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 10 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "OCTOBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 11 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "NOVEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) = 12 AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "DECEMBER"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "F4Q"
,        LPAD(TO_CHAR
        (SUM(CASE
               WHEN EXTRACT(MONTH FROM transaction_date) IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12) AND
                    EXTRACT(YEAR FROM transaction_date) = 2009 THEN
                 CASE
                   WHEN cl.common_lookup_type = 'DEBIT'
                   THEN t.transaction_amount
                   ELSE t.transaction_amount * -1
                 END
             END),'99,999.00'),10,' ') AS "YTD"
FROM     transaction t INNER JOIN common_lookup cl
ON       t.transaction_type = cl.common_lookup_id 
WHERE    cl.common_lookup_table = 'TRANSACTION'
AND      cl.common_lookup_column = 'TRANSACTION_TYPE' ;

SPOOL OFF
