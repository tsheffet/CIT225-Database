-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab8.sql
--  Lab Assignment: Lab #8
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2018
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
--   sql> @apply_oracle_lab8.sql
--
-- ------------------------------------------------------------------

-- Call library files.
@/home/student/Data/cit225/oracle/lab7/apply_oracle_lab7.sql

-- Open log file.
SPOOL apply_oracle_lab8.txt

CREATE SEQUENCE price_s
START WITH 1001;


INSERT INTO price
( price_id
, item_id
, price_type
, active_flag
, start_date
, end_date
, amount
, created_by
, creation_date
, last_updated_by
, last_update_date )
( SELECT price_s.NEXTVAL
  ,        item_id
  ,        price_type
  ,        active_flag
  ,        start_date
  ,        end_date
  ,        amount
  ,        created_by
  ,        creation_date
  ,        last_updated_by
  ,        last_update_date
  FROM 
    (SELECT   i.item_id
     ,        af.active_flag
     ,        cl.common_lookup_id AS price_type
     ,        cl.common_lookup_type AS price_desc
     ,        CASE
                WHEN (trunc(sysdate) - i.release_date) > 30 AND af.active_flag = 'Y'
                THEN (i.release_date + 30)
                ELSE (i.release_date)
              END AS start_date
     ,        CASE
                WHEN (trunc(sysdate) - i.release_date) > 30 AND af.active_flag = 'N'
                THEN (i.release_date + 30)
                END AS end_date
     ,        CASE
                WHEN (trunc(sysdate) - i.release_date) < 30 AND af.active_flag = 'Y'
                THEN
                CASE
                WHEN dr.rental_days = 1 THEN 3
                WHEN dr.rental_days = 3 THEN 10
                WHEN dr.rental_days = 5 THEN 15
                END
            WHEN (trunc(sysdate) - i.release_date) > 30 AND af.active_flag = 'Y'
            THEN
   		 CASE
   		     WHEN dr.rental_days = 1 THEN 1
   		     WHEN dr.rental_days = 3 THEN 3
   		     WHEN dr.rental_days = 5 THEN 5
   		     END
   		WHEN (trunc(sysdate) - i.release_date) > 30 AND af.active_flag = 'N'
   		 THEN
   		 CASE
   		     WHEN dr.rental_days = 1 THEN 3
   		     WHEN dr.rental_days = 3 THEN 10
   		     WHEN dr.rental_days = 5 THEN 15
   		     END
   		 END AS amount
     ,        1002 AS created_by
     ,        (trunc(sysdate)) AS creation_date
     ,        1002 AS last_updated_by
     ,        (trunc(sysdate)) AS last_update_date
     FROM     item i CROSS JOIN
             (SELECT 'Y' AS active_flag FROM dual
              UNION ALL
              SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
             (SELECT '1' AS rental_days FROM dual
              UNION ALL
              SELECT '3' AS rental_days FROM dual
              UNION ALL
              SELECT '5' AS rental_days FROM dual) dr INNER JOIN
              common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
     WHERE    cl.common_lookup_table = 'PRICE'
     AND      cl.common_lookup_column = 'PRICE_TYPE'
     AND NOT (af.active_flag = 'N' AND (trunc(sysdate) <= i.release_date + 30))));
     
     
     
     
     
     
     SELECT  'OLD Y' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND      end_date IS NULL
UNION ALL
SELECT  'OLD N' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) > 30
AND NOT end_date IS NULL
UNION ALL
SELECT  'NEW Y' AS "Type"
,        COUNT(CASE WHEN amount =  3 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 10 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 15 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'Y' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      end_date IS NULL
UNION ALL
SELECT  'NEW N' AS "Type"
,        COUNT(CASE WHEN amount = 1 THEN 1 END) AS "1-Day"
,        COUNT(CASE WHEN amount = 3 THEN 1 END) AS "3-Day"
,        COUNT(CASE WHEN amount = 5 THEN 1 END) AS "5-Day"
,        COUNT(*) AS "TOTAL"
FROM     price p , item i
WHERE    active_flag = 'N' AND i.item_id = p.item_id
AND     (TRUNC(SYSDATE) - TRUNC(i.release_date)) < 31
AND      NOT (end_date IS NULL);
-- ... insert lab 8 commands here ...



-- step 2 --

--add the not null constraint to price_type column in price table--
ALTER TABLE price
    MODIFY (price_type NUMBER CONSTRAINT price_type_nn NOT NULL);

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'PRICE'
AND      column_name = 'PRICE_TYPE';


-- step 3 --

-- use the update statement, change or fix errors --

UPDATE   rental_item ri
SET      rental_item_price =
          (SELECT   p.amount
           FROM     price p INNER JOIN common_lookup cl1
           ON       p.price_type = cl1.common_lookup_id CROSS JOIN rental r
                    CROSS JOIN common_lookup cl2 
           WHERE    p.item_id = ri.item_id
           AND      ri.rental_id = r.rental_id
           AND      ri.rental_item_type = cl2.common_lookup_id
           AND      cl1.common_lookup_code = cl2.common_lookup_code
           AND      r.check_out_date
                      BETWEEN p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1));                            
                            
-- verify--

-- Widen the display console.
SET LINESIZE 150
 
-- Set the column display values.
COL customer_name          FORMAT A20  HEADING "Contact|--------|Customer Name"
COL contact_id             FORMAT 9999 HEADING "Contact|--------|Contact|ID #"
COL customer_id            FORMAT 9999 HEADING "Rental|--------|Customer|ID #"
COL r_rental_id            FORMAT 9999 HEADING "Rental|------|Rental|ID #"
COL ri_rental_id           FORMAT 9999 HEADING "Rental|Item|------|Rental|ID #"
COL rental_item_id         FORMAT 9999 HEADING "Rental|Item|------||ID #"
COL price_item_id          FORMAT 9999 HEADING "Price|------|Item|ID #"
COL rental_item_item_id    FORMAT 9999 HEADING "Rental|Item|------|Item|ID #"
COL rental_item_price      FORMAT 9999 HEADING "Rental|Item|------||Price"
COL amount                 FORMAT 9999 HEADING "Price|------||Amount"
COL price_type_code        FORMAT 9999 HEADING "Price|------|Type|Code"
COL rental_item_type_code  FORMAT 9999 HEADING "Rental|Item|------|Type|Code"
SELECT   c.last_name||', '||c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name
         END AS customer_name
,        c.contact_id
,        r.customer_id
,        r.rental_id AS r_rental_id
,        ri.rental_id AS ri_rental_id
,        ri.rental_item_id
,        p.item_id AS price_item_id
,        ri.item_id AS rental_item_item_id
,        ri.rental_item_price
,        p.amount
,        TO_NUMBER(cl2.common_lookup_code) AS price_type_code
,        TO_NUMBER(cl2.common_lookup_code) AS rental_item_type_code
FROM     price p INNER JOIN common_lookup cl1
ON       p.price_type = cl1.common_lookup_id
AND      cl1.common_lookup_table = 'PRICE'
AND      cl1.common_lookup_column = 'PRICE_TYPE' FULL JOIN rental_item ri 
ON       p.item_id = ri.item_id INNER JOIN common_lookup cl2
ON       ri.rental_item_type = cl2.common_lookup_id
AND      cl2.common_lookup_table = 'RENTAL_ITEM'
AND      cl2.common_lookup_column = 'RENTAL_ITEM_TYPE' RIGHT JOIN rental r
ON       ri.rental_id = r.rental_id FULL JOIN contact c
ON       r.customer_id = c.contact_id
WHERE    cl1.common_lookup_code = cl2.common_lookup_code
AND      r.check_out_date
BETWEEN  p.start_date AND NVL(p.end_date,TRUNC(SYSDATE) + 1)
ORDER BY 2, 3;
 

-- Reset the column display values to their default value.
SET LINESIZE 80

ALTER TABLE rental_item
    MODIFY (rental_item_price NOT NULL);



COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM'
AND      column_name = 'RENTAL_ITEM_PRICE';
SPOOL OFF
