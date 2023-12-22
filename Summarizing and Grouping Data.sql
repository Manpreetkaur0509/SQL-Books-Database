
--Summarizing and Grouping Data

--An aggregate expression can’t appear in a WHERE clause

SELECT title_id           --Illegal
  FROM titles
  WHERE sales = MAX(sales);
  
--  You can’t mix nonaggregate (row-by-row) and aggregate expressions in a SELECT clause.

SELECT title_id, MAX(sales)
  FROM titles;  
  
SELECT TITLE_ID, GENRE, SUM(sales)
  FROM titles
  GROUP BY TITLE_ID, GENRE;  
  
 SELECT  GENRE, SUM(sales)
  FROM titles
  GROUP BY  GENRE; 
  
-- You can use more than one aggregate expression in a SELECT clause:

SELECT MIN(sales), MAX(sales)
  FROM titles;
  
-- You can’t nest aggregate functions:

SELECT SUM(AVG(sales))
  FROM titles;
  
-- valid for oracle
--List the average of the maximum sales of all book types. 
SELECT AVG(MAX(sales))
  FROM titles
  GROUP BY genre;  
  
-- 2nd way

SELECT AVG(s.max_sales)
FROM (SELECT MAX(sales) AS max_sales
        FROM titles
        GROUP BY genre) s  
        
        
-- We can use aggregate expressions in subqueries.

-- This statement finds the title of the book with the highest sales:

SELECT title_id, price      --Legal
  FROM titles
  WHERE sales =
    (SELECT MAX(sales) FROM titles);
    
    
--We can’t use subqueries in aggregate expressions: 

AVG(SELECT price FROM titles)  -- illegal

-- Some MIN() queries

SELECT MIN(price) AS "Min price"
  FROM titles;

SELECT MIN(pubdate) AS "Earliest pubdate"
  FROM titles;

SELECT MIN(pages) AS "Min history pages"
  FROM titles
  WHERE genre = 'history';
  
-- Finding a Maximum with MAX()

SELECT MAX(lname) AS "Max last name"
  FROM authors;

SELECT
    MIN(price) AS "Min price",
    MAX(price) AS "Max price",
    MAX(price) - MIN(price) AS "Range"
  FROM titles;

SELECT MAX(price * sales)
         AS "Max history revenue"
  FROM titles
  WHERE genre = 'history';
--MAX() works with character, numeric, and datetime data types.

--Calculating a Sum with SUM()

select sum(advance) as "total advance"
 from titles;

select sum(sales) as total_sales
    from titles
        where pubdate between 
        '2000-01-01' and '2000-12-31';

-- 2nd way
SELECT SUM(sales)
         AS "Total sales (2000 books)"
  FROM titles
  WHERE pubdate
    BETWEEN DATE '2000-01-01'
        AND DATE '2000-12-31';
        
select sum(price) as total_sales , 
        sum(sales) as total_sales,
        sum(price* sales) as revenue
                from titles ;
--SUM() works with only numeric data types.

-- The sum of no rows is null—not zero

--Calculating an Average with AVG()

select avg(price*2) as "avg(price*2)"
        from titles ;

select avg(sales) as avg_sales ,
        sum(sales)as sum_sales
            from titles
                where genre='business' ;
                
select title_id , sales 
    from titles 
        where sales>
               (select avg(sales) from titles)
        order by sales desc ;       
-- AVG() works with only numeric data types.

-- The average of no rows is null—not zero

-- AGGREGATING AND NULLS

-- Aggregate functions (except COUNT(*)) ignore nulls.
-- If an aggregation requires that you account for nulls,
--you can replace each null with a specified value by using COALESCE()

--List the average sales of biographies by including nulls (replaced by zeroes) in the calculation:
SELECT AVG(COALESCE(sales,0))
    AS AvgSales
  FROM titles
  WHERE genre = 'biography';
  
--List the mode of book prices in the sample database:
--SELECT price, COUNT(*) AS frequency
--  FROM titles
--  GROUP BY price
--  HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM titles GROUP BY price);

--Counting Rows with COUNT()
--Use the aggregate function COUNT() to count the number of rows in a set of values. COUNT() has two forms:
--
--COUNT(expr) returns the number of rows in which expr is not null.
--
--COUNT(*) returns the count of all rows in a set, including nulls and duplicates.

SELECT
    COUNT(title_id) AS "COUNT(title_id)",
    COUNT(price) AS "COUNT(price)",
    COUNT(*) AS "COUNT(*)"
  FROM titles;


SELECT
    COUNT(title_id) AS "COUNT(title_id)",
    COUNT(price) AS "COUNT(price)",
    COUNT(*) AS "COUNT(*)"
  FROM titles
  WHERE price IS NOT NULL;
  
SELECT
    COUNT(title_id) AS "COUNT(title_id)",
    COUNT(price) AS "COUNT(price)",
    COUNT(*) AS "COUNT(*)"
  FROM titles
  WHERE price IS NULL;  
  
--COUNT(expr) and COUNT(*) work with all data types and never return null.

--COUNT(*) - COUNT(expr) returns the number of nulls, and 
--((COUNT(*) - COUNT(expr))*100)/COUNT(*) returns the percentage of nulls.

--Aggregating Distinct Values with DISTINCT

--use DISTINCT to eliminate duplicate values in aggregate function calculations

Some DISTINCT aggregate queries.

SELECT
    COUNT(*)     AS "COUNT(*)"
  FROM titles;

SELECT
    COUNT(price) AS "COUNT(price)",
    SUM(price)   AS "SUM(price)",
    AVG(price)   AS "AVG(price)"
  FROM titles;

SELECT
    COUNT(DISTINCT price)
      AS "COUNT(DISTINCT)",
    SUM(DISTINCT price)
      AS "SUM(DISTINCT)",
    AVG(DISTINCT price)
      AS "AVG(DISTINCT)"
  FROM titles;
  
  
SELECT SUM(DISTINCT price)
  FROM titles;  
  
SELECT SUM(price)
  FROM (SELECT DISTINCT price
          FROM titles);  
          
--DISTINCT in a SELECT clause and DISTINCT in an aggregate function differ in meaning

select count(au_id) as count
    from author_titles ;
    
    
select distinct count(au_id) as distinct_count
    from author_titles;
    
select count(distinct au_id) as "count(distinct au_id)"
 from author_titles ;
    
-- Combining non-DISTINCT and DISTINCT aggregates gives inconsistent results.

select count(price) as "count(price)" ,
        sum(price) as "sum(price)"
            from titles ;
            
            
select count(price) as "count(price)" ,
        sum(distinct price) as "sum(distinct price)" 
            from titles ;
            
select count(distinct price) as "count(distinct price)" ,
       sum (distinct price) as "sum (distinct price) "
             from titles ;
             
select count(price) as "count(price)" ,
        sum(price) as "sum(price)" ,
        count(distinct price) as "count(distinct price)" ,
        sum (distinct price) as "sum (distinct price) "
             from titles ;
             
--List the number of books each author wrote (or cowrote)

select au_id ,
       count(*) as num_books 
            from author_titles 
                group by au_id ;
                
                
SELECT genre, pub_id, COUNT(*)
  FROM titles
  GROUP BY genre,pub_id;   
  
  
SELECT
   state,
   COUNT(state) AS "COUNT(state)",
   COUNT(*)     AS "COUNT(*)"
  FROM publishers
  GROUP BY state;  
  
SELECT
   genre,
   SUM(sales)   AS "SUM(sales)",
   COUNT(sales) AS "COUNT(sales)",
   COUNT(*)     AS "COUNT(*)",
   SUM(sales)/COUNT(sales) AS "SUM/COUNT(sales)",
   SUM(sales)/COUNT(*) AS "SUM/COUNT(*)",
   AVG(sales)   AS "AVG(sales)"
            FROM titles
                    GROUP BY genre;  
                    
-- 
SELECT
    genre,
    SUM(sales)   AS "SUM(sales)",
    AVG(sales)   AS "AVG(sales)",
    COUNT(sales) AS "COUNT(sales)"
  FROM titles
  GROUP BY genre;      
  
SELECT
    genre,
    SUM(sales)   AS "SUM(sales)",
    AVG(sales)   AS "AVG(sales)",
    COUNT(sales) AS "COUNT(sales)"
  FROM titles
  WHERE price >= 13
  GROUP BY genre
  ORDER BY "SUM(sales)" DESC; 
  
-- List the number of books of each type for each publisher, sorted by descending count within ascending publisher ID. 

SELECT
    pub_id,genre,
    COUNT(*) AS "COUNT(*)"
  FROM titles
  GROUP BY pub_id, genre
  ORDER BY pub_id ASC, "COUNT(*)" DESC;

--List the number of books in each calculated sales range, sorted by ascending sales.

SELECT
    CASE
      WHEN sales IS NULL
        THEN 'Unknown'
      WHEN sales <= 1000
        THEN 'Not more than 1,000'
      WHEN sales <= 10000
        THEN 'Between 1,001 and 10,000'
      WHEN sales <= 100000
        THEN 'Between 10,001 and 100,000'
      WHEN sales <= 1000000
        THEN 'Between 100,001 and 1,000,000'
      ELSE 'Over 1,000,000'
    END
      AS "Sales category",
    COUNT(*) AS "Num titles"
  FROM titles
  GROUP BY
    CASE
      WHEN sales IS NULL
        THEN 'Unknown'
      WHEN sales <= 1000
        THEN 'Not more than 1,000'
      WHEN sales <= 10000
        THEN 'Between 1,001 and 10,000'
      WHEN sales <= 100000
        THEN 'Between 10,001 and 100,000'
      WHEN sales <= 1000000
        THEN 'Between 100,001 and 1,000,000'
      ELSE 'Over 1,000,000'
    END
  ORDER BY MIN(sales) ASC;
  
--Use the WHERE clause to exclude rows that you don’t want grouped and use the HAVING clause to filter rows after they have been grouped. 

SELECT
    FLOOR(price/10)*10 AS "Category",
    COUNT(*) AS "Count"
  FROM titles
  GROUP BY FLOOR(price/10)*10;
  
SELECT genre
  FROM titles
  GROUP BY genre;

SELECT DISTINCT genre
  FROM titles;  
  
  
-- List the average sales for each price, sorted by ascending price.  

select avg(sales)as avg_price from titles
    where price is not null 
    group by price
    order by price asc ;
    
--Filtering Groups with HAVING
--The HAVING clause sets conditions on the GROUP BY clause
--The HAVING clause comes after the GROUP BY clause and before the ORDER BY clause.
--
--HAVING limits the number of groups displayed by GROUP BY
--
--The WHERE search condition is applied before grouping occurs, and the HAVING search condition is applied after.
--
--HAVING syntax is similar to the WHERE syntax, except that HAVING can contain aggregate functions.
--
--A HAVING clause can reference any of the items that appear in the SELECT list.


--The sequence in which the WHERE, GROUP BY, and HAVING clauses are applied is:
--
--The WHERE clause filters the rows that result from the operations specified in the FROM and JOIN clauses.
--
--The GROUP BY clause groups the output of the WHERE clause.
--
--The HAVING clause filters rows from the grouped result.


-- List the number of books written (or cowritten) by each author who has written three or more books.

select count(title_id) , au_id 
     from author_titles 
     group by au_id 
     having count (title_id)>=3;

-- 2nd way
--SELECT
--    au_id,
--    COUNT(*) AS "num_books"
--  FROM author_titles
--  GROUP BY au_id
--  HAVING COUNT(*) >= 3;

--List the number of titles and average revenue for the types with average revenue more than $1 million.

select title_id ,count(price), avg(price* sales) as avg_revenue , genre
  from titles
  group by genre,--(price*sales),title_id
  having (avg(price*sales)) > 1000000 ;
    


--select genre, count(price), avg(price* sales) as avg_revenue 
--  from titles
--  group by genre,(price*sales)
--  having (avg(price*sales)) > 1000000 ;

SELECT
    genre,
    COUNT(price) AS "COUNT(price)",
    AVG(price * sales) AS "AVG revenue"
  FROM titles
  GROUP BY genre
  HAVING AVG(price * sales) > 1000000;

--2nd way
SELECT
    genre,
    COUNT(price) AS "COUNT(price)"
  FROM titles
  GROUP BY genre
  HAVING AVG(price * sales) > 1000000;

--List the number of books of each type for each publisher, for publishers with more than one title of a type.

select pub_id, genre ,
        count(title_id) 
        from titles
        group by pub_id , genre 
        having count(title_id) > 1
        order by pub_id , count(title_id) desc ;
        
--select title_id,pub_id, genre ,
--        count(title_id) 
--        from titles
--        group by pub_id , genre ,title_id
--        having count(title_id) > 1
--        order by pub_id , count(title_id) desc ;        

--2nd way        
--SELECT
--    pub_id,
--    genre,
--    COUNT(*) AS "COUNT(*)"
--  FROM titles
--  GROUP BY pub_id, genre
--  HAVING COUNT(*) > 1
--  ORDER BY pub_id ASC, "COUNT(*)" DESC;


--For books from publishers P03 and P04, 
--list the total sales and average price by type,
--for types with more than $10,000 total sales and less than $20 average price

select genre ,sum(sales) ,avg(price)
            from titles
                where pub_id in ('P03' , 'P04' )
                group by genre 
              having sum(sales) >10000
              and avg(price) < 20 ;

-- The following statements,are equivalent, but the first statement is preferable
-- because it reduces the number of rows that have to be grouped:

SELECT pub_id, SUM(sales)  --Faster
  FROM titles
  WHERE pub_id IN ('P03', 'P04')
  GROUP BY pub_id
  HAVING SUM(sales) > 10000;              
        
SELECT pub_id, SUM(sales)  --Slower
  FROM titles
  GROUP BY pub_id
  HAVING SUM(sales) > 10000
    AND pub_id IN ('P03', 'P04');

