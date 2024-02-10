-- CREATE TABLE AS SELECT (CTAS)
drop table basic_row_revenue;
create table basic_row_revenue (aid, tid, type, price, sales, revenue, pid, yr, mm ) as
(
Select at.au_id, t.title_id, genre, price, sales, price * sales, p.pub_id, extract (year from pubdate), extract(month from pubdate)
From author_titles at inner join titles t on at.title_id = t.title_id 
                                    inner join publishers p on t.pub_id=p.pub_id);
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


/* RESULTS - SEE LAG_LEAD PDF*/
