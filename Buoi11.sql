--EX1:  
--the names of all the continents
--average city populations 
SELECT c1.continent , Floor(avg(c2.population)) as AVG_population
FROM country as c1
INNER JOIN city as c2
ON c1.code = c2.countrycode
GROUP BY  c1.continent
  
--ex2:
--the activation rate of specified users in the emails table
--Round the percentage to 2 decimal places.
SELECT 
  ROUND(
  count(texts.email_id) :: numeric 
          / Greatest(count(distinct emails.email_id), 1) , 2) as confirm_rate
FROM emails
LEFT JOIN texts
ON emails.email_id = texts.email_id
AND texts.signup_action = 'Confirmed'
  
--EX3:
WITH cte AS (
  SELECT 
    ab.age_bucket,
    SUM(CASE 
            WHEN activity_type = 'send' THEN ac.time_spent ELSE 0 
        END) as time_spent_sending,
    SUM(CASE 
            WHEN activity_type = 'open' THEN ac.time_spent ELSE 0 
        END) as time_spent_opening
  FROM activities as ac
  INNER JOIN age_breakdown as ab 
  on ac.user_id = ab.user_id
  GROUP BY ab.age_bucket
  )
SELECT 
    age_bucket,
    ROUND(
      time_spent_sending :: numeric / (time_spent_sending + time_spent_opening) * 100, 2
    ) as send_perc,
    ROUND(
      time_spent_opening :: numeric / (time_spent_sending + time_spent_opening) * 100, 2
    ) as open_perc
FROM cte 

--EX4:
With cte AS (
    SELECT
        c.customer_id,
        count(distinct p.product_category) as count_category
    FROM customer_contracts as c 
    INNER JOIN products as p  
    ON c. product_id = p.product_id
    GROUP BY c.customer_id)
SELECT 
  customer_id
FROM cte 
WHERE count_category = 3;

--EX5:
SELECT
    management.employee_id,
    management.name,
    count(*) as reports_count,
    round(avg(employees.age)) as average_age
FROM employees 
INNER JOIN employees as management
ON employees.reports_to = management.employee_id
group by management.employee_id, management.name

--EX6:
SELECT
    p.product_name,
    sum(o.unit) as unit 
FROM products as p
LEFT JOIN orders as o
ON p.product_id = o.product_id
WHERE MONTH(order_date) = '02' AND YEAR(order_date) = '2020' 
group by p.product_name
Having sum(o.unit) >= 100;

--ex7:
SELECT 
  pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id = page_likes.page_id
WHERE page_likes.page_id IS NULL
