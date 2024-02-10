select a.au_id, a.fname, a.lname, at.title_id, t.title, 
t.genre, t.pub_id, t.price * t.sales as revenue, 
extract(year FROM pubdate) as pub_year, p.pub_name
        From authors a 
        inner join author_titles at 
        on a.au_id = at.au_id
            inner join  titles t
            ON at.title_id = t.title_id
            right join publishers p 
              ON t.pub_id = p.pub_id
               where t.price * t.sales >10000
                        Order by a.au_id, genre, pub_year, revenue;

--------------------------------------------------------------------------------------------------
select 	a.au_id, a.fname, a.lname, 	
at.title_id, t.title, t.genre,
t.pub_id, t.price * t.sales as revenue,
extract(year from pubdate) as pub_year, 
p.pub_name
    From authors a 
    inner join author_titles at
    on a.au_id = at.au_id
    	inner join titles t
        on at.title_id = t.title_id
     right join publishers p
     on t.pub_id = p.pub_id
    where t.price * t.sales >10000
   Order by a.au_id, genre, pub_year, revenue
   
--------------------------------------------------------------------------------------------------   
   
   -- CREATE TABLE AS SELECT (CTAS)
drop table basic_row_revenue;
create table basic_row_revenue (aid, tid, type, price, sales, revenue, pid, yr, mm ) as
(
Select
    at.au_id,
    t.title_id, 
    genre, price, 
    sales, 
    price * sales,
    p.pub_id, 
    extract (year from pubdate),
    extract(month from pubdate)
From author_titles at
                inner join titles t
                on at.title_id = t.title_id 
                        inner join publishers p
                        on t.pub_id=p.pub_id);
-- Using the table:
                                    
select * from basic_row_revenue;

select * from basic_row_revenue order by yr, mm, aid;

-- LAG & LEAD:
-- LAG: compares current row with rows before;
-- LEAD: compares current row with rows after;

select aid, tid, type, pid, yr, mm, revenue, 
       lag(revenue, 1)  OVER (PARTITION BY Yr  order by Yr nulls last, mm) prev1_wiYY,
       lag(revenue, 2)  OVER (PARTITION BY YR  order by Yr nulls last, mm) prev2_wiYY,
       lead(revenue, 1) OVER (PARTITION BY YR  order by Yr nulls last, mm) next1_wiYY,
       lead(revenue, 2) OVER (PARTITION BY YR  order by Yr nulls last, mm) next2_wiYY,
       lag(revenue, 1)  OVER (                 ORDER BY Yr nulls last, mm) prev1_All,
       lead(revenue,1)  OVER (                 ORDER BY Yr nulls last, mm) next_All
from basic_row_revenue
order by yr, mm;


select aid, tid, type, pid, yr, mm, revenue, 
       lag(revenue, 1)  OVER (PARTITION BY Yr  order by Yr nulls last, mm) prev1_wiYY
       from basic_row_revenue
order by yr, mm;

select aid, tid, type, pid, yr, mm, revenue, 
        lag(revenue, 2)  OVER (PARTITION BY YR  order by Yr nulls last, mm) prev2_wiYY
         from basic_row_revenue
        order by yr, mm;


select aid, tid, type, pid, yr, mm, revenue, 
       lag(revenue, 1)  OVER (                 ORDER BY Yr nulls last, mm) prev1_All
      from basic_row_revenue
        order by yr, mm;
        
select aid, tid, type, pid, yr, mm, revenue, 
       lag(revenue)  OVER (                 ORDER BY Yr nulls last, mm) prev1_All
      from basic_row_revenue
        order by yr, mm;        
        


select aid, tid, type, pid, yr, mm, revenue, 
       lead(revenue, 1) OVER (PARTITION BY YR  order by Yr nulls last, mm) next1_wiYY
       from basic_row_revenue
            order by yr, mm;


select aid, tid, type, pid, yr, mm, revenue, 
             lead(revenue, 2) OVER (PARTITION BY YR  order by Yr nulls last, mm) next2_wiYY
       from basic_row_revenue
        order by yr, mm;

select aid, tid, type, pid, yr, mm, revenue, 
            lead(revenue,1)  OVER (                 ORDER BY Yr nulls last, mm) next_All
            from basic_row_revenue
            order by yr, mm;


/* RESULTS - SEE LAG_LEAD PDF*/





select a.au_id, a.fname, a.lname, at.title_id, t.title, t.genre, t.pub_id, t.price * t.sales as revenue,
extract(year FROM pubdate) as pub_year, p.pub_name
From authors a 
                  inner join author_titles at 
                           on a.au_id = at.au_id
inner join 
                             titles t
                                       on at.title_id = t.title_id
right join publishers p 
                                    on t.pub_id = p.pub_id
--where t.price * t.sales >10000
Order by a.au_id, genre, pub_year, revenue;


UPDATE PUBLISHERS SET PUB_NAME ='WEST COAST PUBLISHERS' WHERE PUB_NAME LIKE '%WEST%;

UPDATE PUBLISHERS SET PUB_NAME ='WEST COAST PUBLISHERS' WHERE PUB_NAME LIKE '%WEST%';

UPDATE PUBLISHERS SET PUB_NAME ='WEST COAST' WHERE (PUB_NAME) LIKE '%Abat%';

select * from publishers

explain plan for
select a.au_id, a.fname, a.lname, at.title_id, t.title, t.genre, t.pub_id, t.price * t.sales as revenue,
extract(year FROM pubdate) as pub_year, p.pub_name
From authors a 
                  inner join author_titles at 
                           on a.au_id = at.au_id
inner join 
                             titles t
                                       on at.title_id = t.title_id
right join publishers p 
                                    on t.pub_id = p.pub_id
--where t.price * t.sales >10000
Order by a.au_id, genre, pub_year, revenue;

SELECT plan_table_output from table(dbms_xplan.display());


----------------------------------------------
joins
-----------------------------------------
List each book’s title name and ID and each book’s publisher name and ID

SELECT
    t.title_id,
    t.title,
    t.pub_id,
    p.pub_name
  FROM titles t
  INNER JOIN publishers p
    ON p.pub_id = t.pub_id
  ORDER BY t.title ASC;
  
  -----------------------------------------------------
  List each book’s title name and ID and each book’s publisher name and ID
  
SELECT
    title_id,
    title,
    p.pub_id,
    pub_name
  FROM titles t
  INNER JOIN publishers p
    ON p.pub_id = t.pub_id
  ORDER BY title ASC;
  
  -----------------------------------------------------------------------------------
  List the authors who live in the same city and state in which a publisher is located.
  
  SELECT
    au_id,
    fname,
    lname,
    a.city,
    a.state,
    pub_id,
    pub_name
  FROM authors a 
  INNER JOIN publishers p
    ON p.city = a.city and p.state=a.state
 -- ORDER BY au_id ;
 
 ------------------------------------------------------------------------------
 
 SELECT a.au_id, a.fname,
    a.lname, a.city, a.state
  FROM authors a, publishers p
  WHERE a.city = p.city
    AND a.state = p.state
  ORDER BY a.au_id ASC;
  
 -------------------------------------------- 
  List the books published in California or outside the large North American countries.
  
  SELECT
    t.title_id,
    t.title,
    p.state,
    p.country
  FROM titles t
  INNER JOIN publishers p
    ON t.pub_id = p.pub_id
  WHERE p.state = 'CA'
    OR p.country NOT IN ('USA', 'Canada',
       'Mexico')
  ORDER BY t.title_id ASC;
  
  -----------------------------------------------------------------------------------------------
  --List the number of books that each author wrote (or cowrote)
  
  SELECT
    a.au_id,
    COUNT(at.title_id) AS "Num books"
  FROM authors a
  INNER JOIN author_titles at
    ON a.au_id = at.au_id
  GROUP BY a.au_id
  ORDER BY a.au_id ASC;
 
 ------------------------------------------------------------------------------------------
  --- List the advance paid for each biography
  
  select advance , type,title,t.title_id
  from
  titles t
   inner join BASIC_ROW_REVENUE b
  on t.title_id = b.tid
  where b.type = 'biography'
  and advance IS NOT NULL;
  ----------------------------------------------------------------------------------------
  
  List the count and total advance paid for each type of book
  
  select type ,sum(advance), count(t.title_id)
  from titles t
  inner join Basic_row_revenue b
  on t.title_id= b.tid 
  WHERE advance IS NOT NULL
 group by type;
 
 --------------------------------------------------------------------------------
 List the count and total advance paid for each type of book, by publisher
 
 select type ,sum(advance), count(t.title_id),pub_id
  from titles t
  inner join Basic_row_revenue b
  on t.title_id= b.tid 
  WHERE advance IS NOT NULL
 group by type ,pub_id;
 
 --------------------------------------------------------------------------------
 
 List the number of coauthors of each book written by two or more authors
 
 select  title_id ,COUNT(at.au_id) AS "Num authors"
 from authors a
 inner join author_titles at
 on a.au_id = at.au_id 
  group by title_id
 having count(a.au_id)> 1
 order by title_id ;
 
 -----------------------------------------------------------------------------------
 List each book whose revenue (= price × sales) is at least 10 times greater than its advance
 
 select t.title_id  , (price*sales) as rev , advance ,title
 from titles t
  inner join author_titles at 
  on t.title_id = at.title_id
     and (price* sales)>= (10*advance)
  order by title_id;
 -----------------------------------------------------------
 List the author names and the names of the books that each author wrote (or cowrote). 
 
 select
    a.fname,
    a.lname ,
    t.title 
   from authors a
  inner join author_titles at
  on a.au_id= at.au_id
    inner join titles t
    on t.title_id = at.title_id
 
---------------------------------------------------------------------------------------- 
  List the author names, the names of the books that each author wrote (or cowrote), and the publisher names. 
 
 select 
 a.fname,
 a.lname ,
 t.title ,
 p.pub_name
 from authors a
    inner join author_titles at
     on a.au_id= at.au_id
         inner join titles t
         on t.title_id = at.title_id
            inner join publishers p
            on t.pub_id=p.pub_id;
 
 ---------------------------------------------------------------------------------------------------------------
 
 Calculate the total royalties for all books
 
 select sum(price*sales*royalty_rate) as total_royalties , title_id
 from titles t
group by title_id
 
 -----------------------------------------------------------------------------------------------------
 Assignment question:
 -----------------------------------------------------------------------------------------------
 List all authors (au_id, fname, name) – include authors that haven’t (yet) written
a book - the books (Title_id, Title) each author has written – both published and
unpublished books – and the publisher (pub_id, pubname) information where it
exists. Include Publishers (pub_id, pubname) of Publishers that haven’t
published a book. Order the results by au_id, title_id, pub_id



 select a.au_id,a.fname,
       t.title_id , t.title,
       p.pub_id,p.pub_name
       FROM authors a 
       left join author_titles at
       on a.au_id = at.au_id
        left join titles t
        on at.title_id = t.title_id
            full outer join publishers p
            on t.pub_id=p.pub_id
        order by a.au_id , t.title_id ,p.pub_id;     
       
       
 SELECT
    a.au_id,
    a.fname,
    a.lname,
    b.title_id,
    b.title,
    p.pub_id,
    p.pub_name
FROM
    authors a
LEFT JOIN
    author_titles at ON a.au_id = at.au_id
LEFT JOIN
    titles b ON at.title_id = b.title_id
LEFT JOIN
    publishers p ON b.pub_id = p.pub_id
ORDER BY
    a.au_id, b.title_id, p.pub_id;
      
-------------------------------------------------------------------------------------------------------
List the number of books that each author wrote (or cowrote), including authors who have written no books.

Select 
    a.au_id ,count(at.title_id) as book_count
    from authors a
    left join author_titles at
    on a.au_id=at.au_id
    group by a.au_id
    order by a.au_id ;
    
-------------------------------------------------------------------------------------
List the authors who haven’t written (or cowritten) a book.

select a.au_id ,title_id
from authors a
    left join author_titles at
    
    on a.au_id=at.au_id
    where (at.title_id)is null
    order by a.au_id ;
-------------------------------------------------------------    
 List all authors and any books written (or cowritten) that sold more than 100,000 copies.
 
 SELECT
    a.au_id,
    a.fname,
    a.lname,
    t.title_id,
    t.title,
    t.sales
FROM
    authors a
JOIN
    author_titles at ON a.au_id = at.au_id
JOIN
    titles t ON at.title_id = t.title_id
WHERE
    t.sales > 100000
ORDER BY
    a.au_id, t.title_id;

--------------------------------------------------------------------------------------
--SELF JOIN

--List the authors who live in the same state as author A04 (Klee Hull)

select a.au_id ,
a.fname,
a.lname,
a.state 
from authors a 
     inner join authors b
     on a.state=b.state 
     where b.au_id='A04';

----------------------------------------------------------------------------------------

--For every biography, list the title ID and sales of the other biographies that outsold it. 


    SELECT t1.tid, t1.sales,T1.TYPE,
    t2.Tid AS "Better seller",
    t2.sales AS "Higher sales"
  FROM BASIC_ROW_REVENUE t1
  INNER JOIN BASIC_ROW_REVENUE t2
    ON t1.sales < t2.sales
  WHERE t1.type = 'biography'
    AND t2.type = 'biography'
  ORDER BY t1.tid ASC, t2.sales ASC;
    
----------------------------------------------------------------------------------

---List all pairs of authors who live in New York state.

SELECT
    a1.fname, a1.lname,
    a2.fname, a2.lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;
  
  ---------------------------------------------------------------------------------
---List all different pairs of authors who live in New York state

SELECT
    a1.fname, a1.lname,
    a2.fname, a2.lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
    AND a1.au_id <> a2.au_id
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;
  
---------------------------------------------------------------------------------------
--List all different pairs of authors who live in New York state, with no redundancies.

SELECT
    a1.fname, a1.lname,
    a2.fname, a2.lname
  FROM authors a1
  INNER JOIN authors a2
    ON a1.state = a2.state
    AND a1.au_id < a2.au_id
  WHERE a1.state = 'NY'
  ORDER BY a1.au_id ASC, a2.au_id ASC;
  
--------------------------------------------------------------------------------------------


  






