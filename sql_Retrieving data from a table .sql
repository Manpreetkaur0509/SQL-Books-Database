--## Retrieving Data From A Table

--Retrieving Columns with SELECT and FROM
--Creating Column Aliases with AS
--Eliminating Duplicate Rows with DISTINCT
--Sorting Rows with ORDER BY
--Filtering Rows with WHERE
--Combining and Negating Conditions with AND, OR, and NOT
--Show More Items
--Matching Patterns with LIKE
--Range Filtering with BETWEEN
--List Filtering with IN
--Testing for Nulls with IS NULL



-- List the cities in which the authors live.
SELECT city
  FROM authors;
  
--List each author’s first name, last name, city, and state.   
SELECT fname, lname, city, state
  FROM authors;  
  
--To retrieve all columns from a table  
-- List all the columns in the table authors.  
SELECT *
  FROM AUTHORS;
  
  
--  List each publisher’s city, state, and country.
SELECT city, state, country
  FROM publishers;

-- To create column aliases:

SELECT fname AS "First name",
       lname AS "Last name",
       city AS City,
       state,
       zip AS "Postal code"
  FROM authors; 
  
-- List the states in which the authors live.
SELECT state
  FROM authors;

-- To eliminate duplicate rows:
SELECT DISTINCT state
  FROM authors;
  
--  List the cities and states in which the authors live. 
SELECT city, state
  FROM authors;

-- List the distinct cities and states in which the authors live. 

SELECT DISTINCT city, state
  FROM authors;
  
-- List the authors’ first names, last names, cities, and states, sorted by ascending last name. 
--ORDER BY performs ascending sorts by default, so the ASC keyword is optional.  

SELECT fname, lname, city, state
  FROM authors
  ORDER BY lname ASC;
  
  
-- List the authors’ first names, last names, cities, and states,
-- sorted by descending first name. 
-- The DESC keyword is required  

SELECT FNAME, LNAME, CITY ,STATE  FROM AUTHORS
ORDER BY FNAME DESC ;

-- List the authors’ first names, last names, cities, and states, 
--sorted by descending city within ascending state.

SELECT FNAME , LNAME , CITY , STATE 
        FROM AUTHORS 
        ORDER BY 
                STATE ASC , 
                CITY DESC ;

-- To sort by relative column positions:
-- List each author’s first name, last name, city, and state, 
-- sorted first by ascending state (column 4 in the SELECT clause) and 
-- then by descending last name within each state (column 2).

SELECT FNAME, LNAME , CITY , STATE 
        FROM AUTHORS 
        ORDER BY 
                4 ASC,
                2 DESC ;

-- SUBSTRINGS

-- To sort results by specific parts of a string, 
-- use the functions described in “Extracting a Substring with SUBSTRING()”

-- This query sorts by the last four characters of phone:

SELECT au_id, phone
  FROM authors
  ORDER BY
    substr(phone, length(phone)-3);

-- SORTING AND NULLS
SELECT pub_id, state, country
  FROM publishers
  ORDER BY state ASC;
  
-- To sort based on conditional logic, 
-- add a CASE expression to the ORDER BY clause 

-- this query sorts by price if type is “history”; 
-- otherwise, it sorts by sales:

SELECT title_id, GENRE, price, sales
  FROM titles
  ORDER BY CASE WHEN genre = 'history'
    THEN price ELSE sales END;  


-- lists titles by descending revenue 
--(the product of price and sales).

SELECT title_id,
       price,
       sales,
       price * sales AS "Revenue"
  FROM titles
  ORDER BY "Revenue" DESC;
  
 */ OPERATOR - DESCRIPTION

= Equal to

<> Not equal to

< Less than

<= Less than or equal to

> Greater than

>= Greater than or equal to  /*

-- List the authors whose last name is not Hull.

SELECT au_id, fname, lname
  FROM authors
  WHERE lname <> 'Hull';
  
  
-- List the titles for which there is no signed contract.

SELECT title, ADVANCE
  FROM titles
  WHERE ADVANCE = 0;
  
 
 
-- List the titles published in 2001 and later.

SELECT TITLE , PUBDATE
        FROM TITLES 
            WHERE PUBDATE >= DATE '2001-01-01';
            
-- You can’t use an aggregate function such as SUM() or COUNT() in a WHERE            
 
--  List the titles that generated more than $1 million in revenue.

SELECT TITLE ,GENRE , PRICE*SALES AS REVENUE 
        FROM TITLES 
        WHERE PRICE*SALES > 1000000;

SELECT sales AS copies_sold
  FROM titles
  WHERE SALES > 100000;
  
-- USING SUBQUERY in the FROM clause, which is evaluated before the WHERE clause:

SELECT *
  FROM (SELECT sales AS copies_sold
        FROM titles) ta
  WHERE copies_sold > 100000;  

-- List the biographies that sell for LESS than $20

SELECT TITLE, GENRE , PRICE
  FROM TITLES
  WHERE 
        GENRE = 'biography'
        AND 
        PRICE < 20 ;


-- List the authors whose last names begin with one of the letters H through Z 
-- and who don’t live in California. 

SElECT FNAME, LNAME , CITY 
        FROM AUTHORS 
        WHERE LNAME BETWEEN 'H' AND 'z' 
            AND state <> 'CA';

SELECT fname, lname
  FROM authors
  WHERE lname >= 'H'
    AND lname <= 'Zz'
    AND state <> 'CA';
            
            
-- List the authors who live in New York State, 
-- Colorado, or San Francisco.  

select au_id, fname, lname , state ,city 
        from authors 
        where (state = 'CO')
              OR (STATE = 'NY')
              OR (CITY = 'San Francisco');
              
-- List the publishers that are located in California 
-- or are not located in California.   

SELECT PUB_ID , PUB_NAME , CITY , STATE ,COUNTRY
        FROM PUBLISHERS
        WHERE 
            (STATE = 'CA')
           OR
             (STATE <> 'CA');
        
-- list titles that are not biographies and
-- are not priced less than $20

SELECT TITLE_ID, TITLE, PRICE ,GENRE 
        FROM TITLES
        WHERE NOT (GENRE='biography')
        and NOT (PRICE < 20);

-- List the authors who don’t live in California.

SELECT FNAME, LNAME , CITY ,STATE
FROM AUTHORS 
WHERE STATE <> 'CA';
        
SELECT FNAME,LNAME , CITY ,STATE 
FROM AUTHORS
WHERE NOT (STATE='CA');
        
-- List the titles whose price is not less than $20
-- and that have sold more than 15,000 copies.   

SELECT TITLE_ID, TITLE ,PRICE, SALES
        FROM TITLES
        WHERE PRICE >= 20
        AND SALES > 15000;
        
SELECT title, sales, price
  FROM titles
  WHERE NOT (price < 20)
     AND (sales > 15000);    
     
-- list history and biography titles less than $20

SELECT TITLE_ID, TITLE, SALES , GENRE , PRICE 
        FROM TITLES 
        WHERE (GENRE = 'biography'
        OR GENRE = 'history')
        AND PRICE <20;
        
-- 

--SELECT genre,
--         genre = 'history' AS "Hist?",
--         genre = 'biography' AS "Bio?",
--         price,
--         price < 20 AS "<20?"
--    FROM titles;

-- List the authors whose last names begin with Kel.

select fname, lname 
        from authors
        where lname like 'Kel%';

-- List the authors whose last names have ll (el-el) as the third and fourth characters.

select fname, lname 
        from authors
        where lname like '__ll%';
  
-- List the authors who live in the San Francisco Bay Area. 
--(Zip codes in that area begin with 94.)

select fname, lname ,zip
from authors 
where zip like '94%';


--  List the authors who live outside the 212, 415, and 303 area codes.

select fname, lname , phone
from authors
 where phone not like '212%' and
        phone not like '415%' and
        phone not like '303%'
  ;
-- IInd way 

SELECT fname, lname, phone
  FROM authors
  WHERE phone NOT LIKE '212-___-____'
    AND phone NOT LIKE '415-___-%'
    AND phone NOT LIKE '303-%';  
 
-- List the titles that contain percent signs.
 
--SELECT title
--  FROM titles
--  WHERE title LIKE '%!%%' ESCAPE '!';    

-- List the authors who live outside the zip range 20000–89999

SELECT fname, lname, zip
  FROM authors
  WHERE zip NOT BETWEEN '20000' AND '89999';

-- List the titles priced between $10 and $19.95, inclusive.

SELECT title_id, price
  FROM titles
  WHERE price BETWEEN 10 AND 19.95;

-- List the titles published in 2000.

SELECT title_id, pubdate
  FROM titles
  WHERE pubdate BETWEEN DATE '2000-01-01'
                AND     DATE '2000-12-31';
                

-- you want to search for last names that begin with the letter F.

select fname,lname
from authors
where lname like 'F%';

-- F anywhere in lname

select fname,lname
from authors
where lname like '%F%';

--select fname,lname
--from authors
--where lname BETWEEN 'F' AND 'Fz';


--  List the titles priced between $10 and $19.95, exclusive. 

select title_id , price
from titles
where price >10
and price < 19.95 ;

-- List the authors who don’t live in New York State, New Jersey, or California.

select fname, lname, state
    from authors
    where
        state not in ('NY' , 'NJ', 'CA');
        
-- IIND WAY

SELECT fname, lname, state
  FROM authors
  WHERE state <> 'NY'
    AND state <> 'NJ'
    AND state <> 'CA';
  
--List the titles for which advances of $0, $1,000, or $5,000 were paid.

SELECT TITLE_ID, TITLE , ADVANCE
    FROM TITLES
    WHERE ADVANCE IN 
    (0 ,1000,5000);

--IIND WAY

 SELECT title_id, advance
  FROM TITLES
  WHERE advance IN
        (0.00, 1000.00, 5000.00);  
        
--List the titles published on the first day of the year 2000, 2001, or 2002

SELECT TITLE_ID, TITLE ,PUBDATE 
FROM TITLES
WHERE PUBDATE IN 
(DATE '2000-01-01' ,
  DATE '2001-01-01',
 DATE '2002-01-01') ;
 
SELECT TITLE_ID, TITLE ,PUBDATE 
FROM TITLES
WHERE PUBDATE IN 
    ('2000-01-01',
       '2001-01-01',
       '2002-01-01')
 
--List the locations of all the publishers.

SELECT pub_id, city, state, country
  FROM publishers;
  
--List the publishers located in California

SELECT PUB_ID,CITY , STATE ,COUNTRY 
FROM PUBLISHERS
WHERE
STATE = 'CA' ;

--List the publishers located outside California 

SELECT PUB_ID , CITY , STATE 
FROM PUBLISHERS
WHERE STATE <> 'CA'
OR state IS NULL;

--List the biographies whose (past or future) publication dates are known.

SELECT TITLE_ID , genre , PUBDATE 
FROM TITLES
WHERE GENRE = 'biography'
and pubdate is not null ;

-- list publishers details where country is not canada

SELECT pub_id, city, state, country
  FROM publishers
  WHERE country <> 'Canada';
  
  


