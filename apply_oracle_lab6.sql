-- ------------------------------------------------------------------
-- Instructions:
-- ------------------------------------------------------------------
-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql
 
SPOOL apply_oracle_lab6.txt
 

-- step 1 --
ALTER TABLE rental_item
ADD (rental_item_price NUMBER)
ADD (rental_item_type  NUMBER);



SET NULL ''
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
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;


-- step 2 create table --
CREATE TABLE price
( price_id      NUMBER
, item_id       NUMBER         CONSTRAINT nn1_price NOT NULL
, price_type    NUMBER
, active_flag   VARCHAR2(1)    CONSTRAINT nn2_price NOT NULL
, start_date    DATE           CONSTRAINT nn3_price NOT NULL
, end_date      DATE           
, amount        NUMBER          CONSTRAINT nn4_price NOT NULL
, created_by    NUMBER          CONSTRAINT nn5_price NOT NULL
, creation_date DATE            CONSTRAINT nn6_price NOT NULL
, last_update_by    NUMBER      CONSTRAINT nn7_price NOT NULL
, last_update_date  DATE        CONSTRAINT nn8_price NOT NULL
, CONSTRAINT YN_PRICE CHECK (active_flag IN ('Y', 'N'))
, CONSTRAINT pk_price_1     PRIMARY KEY(price_id)
, CONSTRAINT fk_price_1     FOREIGN KEY(item_id)
REFERENCES item(item_id)
, CONSTRAINT fk_price_2     FOREIGN KEY(price_type)
REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_price_3     FOREIGN KEY(last_update_by)
REFERENCES system_user(system_user_id));





SET NULL ''
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
WHERE    table_name = 'PRICE'
ORDER BY 2;


-- step 2 part b --

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';


-- step 3 a --
ALTER TABLE item
RENAME COLUMN item_release_date TO release_date;


SET NULL ''
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
WHERE    table_name = 'ITEM'
ORDER BY 2;

-- step 3 b --
INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT	common_lookup_id
  FROM	common_lookup
  WHERE	common_lookup_context = 'ITEM'
  AND	common_lookup_type = 'DVD_WIDE_SCREEN')
,'Tron'
,'PG'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);
 
 INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( item_s1.nextval
,'2'
,(SELECT	common_lookup_id
  FROM	common_lookup
  WHERE	common_lookup_context = 'ITEM'
  AND	common_lookup_type = 'DVD_WIDE_SCREEN')
,'Enders Game'
,'PG'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( item_s1.nextval
,'3'
,(SELECT	common_lookup_id
  FROM	common_lookup
  WHERE	common_lookup_context = 'ITEM'
  AND	common_lookup_type = 'DVD_WIDE_SCREEN')
,'Elysium'
,'PG'
, (TRUNC(SYSDATE) - 1)
, 1001
, SYSDATE
, 1001
, SYSDATE);





SELECT   item_title
,        SYSDATE AS today
,        release_date
FROM     item 
WHERE   (SYSDATE - release_date) < 31;


-- step 3 c --

INSERT INTO member
( member_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( member_s1.nextval                               -- member_id
, common_lookup_s1.currval                                            -- member_type
,'US00011'                                     -- account_number
,'6011000000000078'                            -- credit_card_number
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval                              -- contact_id
, member_s1.currval                               -- member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Harry'                                        -- first_name
,'Potter'                                        -- last_name
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'UT'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval                              -- contact_id
, member_s1.currval                               -- member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Ginny'                                        -- first_name
,'Potter'                                        -- last_name
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);




INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'UT'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO contact
( contact_id
, member_id
, contact_type
, first_name
, middle_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_s1.nextval                              -- contact_id
, member_s1.currval                               -- member_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')       -- contact_type
,'Lily'
,'Luna'-- first_name
,'Potter'                                        -- last_name
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'UT'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);


INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'USA'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

COLUMN account_number  FORMAT A10  HEADING "Account|Number"
COLUMN full_name       FORMAT A18  HEADING "Name|(Last, First MI)"
COLUMN street_address  FORMAT A14  HEADING "Street Address"
COLUMN city            FORMAT A10  HEADING "City"
COLUMN state           FORMAT A10  HEADING "State"
COLUMN postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN
             ' ' || c.middle_name || ' '
         END AS full_name
,        sa.street_address
,        a.city
,        a.state_province AS state
,        a.postal_code
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';
-- ... insert lab 6 commands here ...

INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Star Wars III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN'
)
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Harry')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Hook'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'BLU-RAY')
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.first_name = 'Ginny')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'RoboCop'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'XBOX')
, 1001
, SYSDATE
, 1001
, SYSDATE);


INSERT INTO rental
( rental_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_s1.nextval
,(SELECT   contact_id
  FROM     contact
  WHERE    last_name = 'Potter'
  AND      middle_name = 'Luna'
  AND      first_name = 'Lily')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item
( rental_item_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental r
  ,        contact c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Potter'
  AND      c.middle_name = 'Luna'
  AND      c.first_name = 'Lily')
,(SELECT   d.item_id
  FROM     item d
  ,        common_lookup cl
  WHERE    d.item_title = 'Star Wars III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN'
)
, 1001
, SYSDATE
, 1001
, SYSDATE);



COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;



-- step 4 a --

DROP INDEX common_lookup_n1;
DROP INDEX common_lookup_u2;

COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';


-- step 4 b --
ALTER TABLE common_lookup
ADD (common_lookup_table VARCHAR2(30))
ADD (common_lookup_column VARCHAR2(30))
ADD (common_lookup_code VARCHAR2(30));

SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

-- step 4 c --

--UPDATE common_lookup
--SET common_lookup_table = common_lookup_context;

UPDATE common_lookup
SET common_lookup_table = common_lookup_context
WHERE NOT common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET common_lookup_table = 'ADDRESS'
WHERE common_lookup_context = 'MULTIPLE';


UPDATE common_lookup
SET common_lookup_column = concat(common_lookup_context, '_TYPE')
WHERE NOT common_lookup_context = 'MULTIPLE';

UPDATE common_lookup
SET common_lookup_column = 'ADDRESS_TYPE'
WHERE common_lookup_context = 'MULTIPLE';


COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
ORDER BY 1, 2, 3;

--step 4 d --

ALTER TABLE common_lookup
MODIFY (common_lookup_context VARCHAR2(20) NULL);


INSERT INTO common_lookup 
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.nextval
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'HOME'
, 'Home'
, 1001
, sysdate
, 1001
, SYSDATE);

INSERT INTO common_lookup 
( common_lookup_id
, common_lookup_table
, common_lookup_column
, common_lookup_type
, common_lookup_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
(common_lookup_s1.nextval
, 'TELEPHONE'
, 'TELEPHONE_TYPE'
, 'WORK'
, 'Work'
, 1001
, sysdate
, 1001
, SYSDATE);


COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;


-- step 4 e --
ALTER TABLE common_lookup
DROP COLUMN common_lookup_context;

ALTER TABLE common_lookup
MODIFY (common_lookup_table VARCHAR(30) CONSTRAINT NN_CLOOKUP_8 NOT NULL)
MODIFY (common_lookup_column VARCHAR(30) CONSTRAINT NN_CLOOKUP_9 NOT NULL);


CREATE UNIQUE INDEX CLOOKUP_U1
ON common_lookup ( common_lookup_table
                 , common_lookup_column
                 , common_lookup_type);



SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition" 
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   UI.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes UI INNER JOIN user_ind_columns uic
ON       UI.index_name = uic.index_name
AND      UI.table_name = uic.table_name
WHERE    UI.table_name = UPPER('common_lookup')
ORDER BY UI.index_name
,        uic.column_position;


-- step 4 f --
UPDATE telephone
SET telephone_type =
(SELECT common_lookup_id
FROM   common_lookup
WHERE  common_lookup_table = 'TELEPHONE'
AND    common_lookup_type = 'HOME');

COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;


SPOOL OFF
