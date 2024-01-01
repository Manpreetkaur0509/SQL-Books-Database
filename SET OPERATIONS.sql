--List the states where authors and publishers are located.

SELECT state FROM authors
UNION
SELECT state FROM publishers;

SELECT state FROM authors
UNION ALL
SELECT state FROM publishers;

--List the names of all the authors and publishers.

SELECT fname || ' ' || lname AS "Name"
  FROM authors
UNION
SELECT pub_name
  FROM publishers
  ORDER BY 1 ASC;
  
--List the names of all the authors and publishers located in New York state, sorted by type and then by name

SELECT
    'author' AS "Type",
    fname || ' ' || lname AS "Name",
    state
  FROM authors
  WHERE state = 'NY'
UNION
SELECT
    'publisher',
    pub_name,
    state
  FROM publishers
  WHERE state = 'NY'
  ORDER BY 1 ASC, 2 ASC;
  

--List the names of all the authors and publishers located in New York state and the titles of books published in New York state,
--sorted by type and then by name.
SELECT
    'author' AS "Type",
    fname || ' ' || lname AS "Name"
  FROM authors
  WHERE state = 'NY'
UNION
SELECT
    'publisher',
    pub_name
  FROM publishers
  WHERE state = 'NY'
UNION
SELECT
    'title',
    title_name
  FROM titles t
  INNER JOIN publishers p
    ON t.pub_id = p.pub_id
  WHERE p.state = 'NY'
  ORDER BY 1 ASC, 2 ASC; 
  
--List the counts of all the authors and publishers located in New York state 
--and the titles of books published in New York state, sorted by type.  

SELECT
    'author' AS "Type",
    COUNT(au_id) AS "Count"
  FROM authors
  WHERE state = 'NY'
UNION
SELECT
    'publisher',
    COUNT(pub_id)
  FROM publishers
  WHERE state = 'NY'
UNION
SELECT
    'title',
    COUNT(title_id)
  FROM titles t
  INNER JOIN publishers p
    ON t.pub_id = p.pub_id
  WHERE p.state = 'NY'
  ORDER BY 1 ASC;
  
--Raise the price of history books by 10 percent and psychology books by 20 percent, 
--and leave the prices of other books unchanged.  

SELECT title_id, genre, price,
    price * 1.10 AS "New price"
  FROM titles
  WHERE genre = 'history'
UNION
SELECT title_id, genre, price, price * 1.20
  FROM titles
  WHERE genre = 'psychology'
UNION
SELECT title_id, genre, price, price
  FROM titles
  WHERE genre NOT IN ('psychology','history')
  ORDER BY genre ASC, title_id ASC;
  
--INTERSECTION

--List the cities in which both an author and a publisher are located.

SELECT city
  FROM authors
INTERSECT
SELECT city
  FROM publishers;
  
  
SELECT DISTINCT authors.city
  FROM authors
  INNER JOIN publishers
    ON authors.city =
      publishers.city;  

-- List the cities in which an author lives but a publisher isn’t located.
      
SELECT city
  FROM authors
EXCEPT
SELECT city
  FROM publishers; 
  
SELECT DISTINCT a.city
  FROM authors a
  LEFT OUTER JOIN publishers p
    ON a.city = p.city
  WHERE p.city IS NULL;  
  
SELECT DISTINCT city
  FROM authors
  WHERE NOT EXISTS
    (SELECT *
       FROM publishers
       WHERE authors.city =
             publishers.city); 
             
--
