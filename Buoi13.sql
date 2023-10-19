--ex1:
WITH cte AS (
    SELECT 
      company_id,
      title,
      description, 
      count(*) as count_job
    FROM job_listings
    GROUP BY company_id, title, description
    )
    
SELECT 
  COUNT(distinct company_id) as duplicate_companies
FROM cte 
WHERE count_job > 1

-ex2:
WITH cte AS (
SELECT
  category,
  product,
  SUM(spend) AS total_spend,
  RANK() OVER( PARTITION BY category ORDER BY SUM(spend) desc) AS ranking
FROM product_spend
WHERE EXTRACT(year from transaction_date) = 2022
GROUP BY category, product )
SELECT 
    category, 
    product,
    total_spend
FROM cte
WHERE ranking <= 2
ORDER BY category, ranking

--ex3:
WITH cte AS (
    SELECT 
        policy_holder_id,
        count(case_id) as count_call
    FROM callers
    GROUP BY policy_holder_id
    HAVING count(case_id) >=3)
SELECT 
    COUNT(*) as member_count
FROM cte;

--EX4:
SELECT
  p.page_id
FROM pages as p
LEFT JOIN page_likes as pl
ON p.page_id = pl.page_id
WHERE pl.page_id is null;

--EX5:

WITH curr_month AS (
    SELECT 
      date_trunc('month', event_date) AS mth, 
      user_id
    FROM user_actions
)

SELECT
    EXTRACT(month from curr.mth) as month,
    count(DISTINCT curr.user_id)
FROM curr_month  AS curr
INNER JOIN curr_month AS previous
ON curr.user_id = previous.user_id
AND previous.mth = curr.mth - interval '1 month'
WHERE to_char(curr.mth, 'mm-yyyy') = '07-2022'
GROUP BY month;

-ex6:
SELECT 
    to_char(trans_date, 'yyyy-mm') AS month, 
    country, 
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 
        END) AS approved_count, 
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0
        END) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

--ex7:
WITH cte AS ( 
    SELECT 
        *,
        rank() over( partition by product_id order by year asc) as ranking
    FROM sales)
SELECT
    product_id,
    year as first_year,
    quantity,
    price
FROM cte
WHERE ranking = 1
group by product_id

--ex8:
SELECT
    customer_id
FROM customer
GROUP BY customer_id
HAVING count(product_key) = (select count(product_key) from product);

-EX9:
SELECT
    e.employee_id
FROM employees as e
LEFT JOIN employees AS m
ON e.manager_id = m.employee_id
WHERE e.salary < 30000 
AND m.employee_id is null
and e.manager_id is not null

--EX10:
--Chị ơi, bài này là link EX1.

--EX11:
(SELECT
   name as results
FROM users as u
INNER JOIN movierating as mr
ON u.user_id = mr.user_id
GROUP BY name
ORDER BY count(movie_id) desc, name asc
LIMIT 1)
UNION
(SELECT
    title as results
FROM movies as m
INNER JOIN movierating as mr
ON m.movie_id = mr.movie_id
WHERE to_char(created_at, 'mm-yyyy') = '02-2022'
GROUP BY title
ORDER BY avg(rating) desc, title asc
LIMIT 1)

--EX12:
WITH cte as (
    select requester_id AS id from RequestAccepted
union all
    select accepter_id AS id from RequestAccepted)
select 
    id,
    count(*) as num
from cte
group by id
order by num desc
limit 1
