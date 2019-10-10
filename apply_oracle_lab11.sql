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
--   sql> @apply_oracle_lab11.sql
--
-- ------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

-- Spool log file.
SPOOL apply_oracle_lab11.txt

MERGE INTO rental target
USING (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id
         ,        tu.check_out_date AS check_out_date
         ,        tu.return_date AS return_date
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name 
         LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date)) r
ON (target.rental_id = r.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = r.last_updated_by
,          last_update_date = r.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
,        r.contact_id
,        r.check_out_date
,        r.return_date
,        r.created_by
,        r.creation_date
,        r.last_updated_by
,        r.last_update_date);



SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental after merge"
FROM     rental;




-- step 2 --

MERGE INTO rental_item target
USING (SELECT   ri.rental_item_id
 ,        r.rental_id
 ,        tu.item_id
 ,        1001 AS created_by
 ,        TRUNC(SYSDATE) AS creation_date
 ,        1001 AS last_updated_by
 ,        TRUNC(SYSDATE) AS last_update_date
 ,        cl1.common_lookup_id AS rental_item_type
 ,        r.return_date - r.check_out_date AS rental_item_price
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id 
INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date)     
INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'RENTAL_ITEM'
AND     cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND     cl1.common_lookup_type = tu.return_item_type
LEFT JOIN rental_item ri
ON       r.rental_id = ri.rental_id) ri
ON (target.rental_item_id = ri.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = ri.last_updated_by
,          last_update_date = ri.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval
, ri.rental_id
, ri.item_id
, ri.created_by
, ri.creation_date
, ri.last_updated_by
, ri.last_update_date
, ri.rental_item_price
, ri.rental_item_type);




SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental Item after merge"
FROM     rental_item;




-- step 3 --
MERGE INTO transaction target
USING (SELECT   t.transaction_id
         ,        tu.payment_account_number AS transaction_account
         ,        cl1.common_lookup_id AS transaction_type
         ,        tu.transaction_date
         ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
         ,        r.rental_id
         ,        cl2.common_lookup_id AS payment_method_type
         ,        m.credit_card_number AS payment_account_number
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id 
INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date) 
INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = tu.transaction_type
INNER JOIN common_lookup cl2
ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = tu.payment_method_type
LEFT JOIN transaction t
ON      t.transaction_account = tu.payment_account_number
AND     t.rental_id = r.rental_id
AND     t.transaction_type = cl1.common_lookup_id
AND     t.transaction_date = tu.transaction_date
AND     t.payment_method_type = cl2.common_lookup_id
AND     t.payment_account_number = m.credit_card_number
         GROUP BY t.transaction_id
         ,        tu.payment_account_number
         ,        cl1.common_lookup_id
         ,        tu.transaction_date
         ,        r.rental_id
         ,        cl2.common_lookup_id
         ,        m.credit_card_number
         ,        1001
         ,        TRUNC(SYSDATE)
         ,        1001
         ,        TRUNC(SYSDATE)) t 
ON (target.transaction_id = t.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = t.last_updated_by
,          last_update_date = t.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
,        t.transaction_account
,        t.transaction_type
,        t.transaction_date
,        t.transaction_amount
,        t.rental_id
,        t.payment_method_type
,        t.payment_account_number
,        t.created_by
,        t.creation_date
,        t.last_updated_by
,        t.last_update_date);




SELECT   TO_CHAR(COUNT(*),'99,999') AS "Transaction after merge"
FROM     transaction;




-- step 4 --
-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_transaction IS 
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;
 
  -- Merge into RENTAL table.
  MERGE INTO rental target
  USING (SELECT   DISTINCT
                  r.rental_id
         ,        c.contact_id
         ,        tu.check_out_date AS check_out_date
         ,        tu.return_date AS return_date
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
         ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
         ON       c.first_name = tu.first_name
         AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND      c.last_name = tu.last_name 
         LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date)) r
ON (target.rental_id = r.rental_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = r.last_updated_by
,          last_update_date = r.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.NEXTVAL
,        r.contact_id
,        r.check_out_date
,        r.return_date
,        r.created_by
,        r.creation_date
,        r.last_updated_by
,        r.last_update_date)
 
  -- Merge into RENTAL_ITEM table.
  MERGE INTO rental_item target
USING (SELECT   ri.rental_item_id
 ,        r.rental_id
 ,        tu.item_id
 ,        1001 AS created_by
 ,        TRUNC(SYSDATE) AS creation_date
 ,        1001 AS last_updated_by
 ,        TRUNC(SYSDATE) AS last_update_date
 ,        cl1.common_lookup_id AS rental_item_type
 ,        r.return_date - r.check_out_date AS rental_item_price
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id 
INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date)     
INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'RENTAL_ITEM'
AND     cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND     cl1.common_lookup_type = tu.return_item_type
LEFT JOIN rental_item ri
ON       r.rental_id = ri.rental_id) ri
ON (target.rental_item_id = ri.rental_item_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = ri.last_updated_by
,          last_update_date = ri.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_item_s1.nextval
, ri.rental_id
, ri.item_id
, ri.created_by
, ri.creation_date
, ri.last_updated_by
, ri.last_update_date
, ri.rental_item_price
, ri.rental_item_type)
 
  -- Merge into TRANSACTION table.
  MERGE INTO transaction target
  USING (SELECT   t.transaction_id
         ,        tu.payment_account_number AS transaction_account
         ,        cl1.common_lookup_id AS transaction_type
         ,        tu.transaction_date
         ,       (SUM(tu.transaction_amount) / 1.06) AS transaction_amount
         ,        r.rental_id
         ,        cl2.common_lookup_id AS payment_method_type
         ,        m.credit_card_number AS payment_account_number
         ,        1001 AS created_by
         ,        TRUNC(SYSDATE) AS creation_date
         ,        1001 AS last_updated_by
         ,        TRUNC(SYSDATE) AS last_update_date
         FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id 
INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
LEFT JOIN rental r
         ON       c.contact_id = r.customer_id
         AND      trunc(tu.check_out_date) = trunc(r.check_out_date)
         AND      trunc(tu.return_date) = trunc(r.return_date) 
INNER JOIN common_lookup cl1
ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = tu.transaction_type
INNER JOIN common_lookup cl2
ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = tu.payment_method_type
LEFT JOIN transaction t
ON      t.transaction_account = tu.payment_account_number
AND     t.rental_id = r.rental_id
AND     t.transaction_type = cl1.common_lookup_id
AND     t.transaction_date = tu.transaction_date
AND     t.payment_method_type = cl2.common_lookup_id
AND     t.payment_account_number = m.credit_card_number
         GROUP BY t.transaction_id
         ,        tu.payment_account_number
         ,        cl1.common_lookup_id
         ,        tu.transaction_date
         ,        r.rental_id
         ,        cl2.common_lookup_id
         ,        m.credit_card_number
         ,        1001
         ,        TRUNC(SYSDATE)
         ,        1001
         ,        TRUNC(SYSDATE)) t 
ON (target.transaction_id = t.transaction_id)
WHEN MATCHED THEN
UPDATE SET last_updated_by = t.last_updated_by
,          last_update_date = t.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( transaction_s1.nextval
,        t.transaction_account
,        t.transaction_type
,        t.transaction_date
,        t.transaction_amount
,        t.rental_id
,        t.payment_method_type
,        t.payment_account_number
,        t.created_by
,        t.creation_date
,        t.last_updated_by
,        t.last_update_date)
  COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/



EXECUTE upload_transaction;




COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
        
        
        
EXECUTE upload_transaction;





COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;
        
        
        
        
 

 
-- STEP 5 -- 
 

SELECT   to_char(transaction_date, 'Mon - YYYY') "MONTH/YEAR"
,   TO_CHAR(sum(transaction_amount),'$9,999,999.00') AS "BASE_REVENUE"
,   TO_CHAR(sum(transaction_amount * 1.1),'$9,999,999.00') AS "10_PLUS"
,   TO_CHAR(sum(transaction_amount * 1.2),'$9,999,999.00') AS "20_PLUS"
,   TO_CHAR(sum(transaction_amount * .10),'$9,999,999.00') AS "10_PLUS_LESS_B"
,   TO_CHAR(sum(transaction_amount * .20),'$9,999,999.00') AS "20_PLUS_LESS_B"
from transaction
WHERE extract(year from transaction_date) = '2009'
group by to_char(transaction_date, 'Mon - YYYY')
order by max(transaction_date);

SPOOL OFF
