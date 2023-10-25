--ex1:
SELECT
    ROUND(
        SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) 
        / COUNT(DISTINCT customer_id) * 100, 2) AS immediate_percentage
FROM Delivery
 WHERE (customer_id, order_date) IN (
    SELECT  customer_id, 
            MIN(order_date) AS first_order_date
    FROM Delivery
    GROUP BY customer_id)
--EX2:
SELECT
    ROUND(
        count( distinct a2.player_id)/ count(distinct a1.player_id)
        , 2) as fraction  
FROM activity as a1
LEFT JOIN activity as a2
ON a1.player_id = a2.player_id
AND a2.event_date = a1.event_date + INTERVAL 1 day
--EX3:
SELECT
     case 
        WHEN id = (SELECT  max(id) FROM seat) AND id % 2 != 0 THEN id
        WHEN id % 2 = 0 THEN id - 1
        WHEN id % 2 != 0 THEN id +1
    END AS id, 
    student
FROM seat
ORDER BY id

--EX4: (***)
WITH cte as (
    SELECT 
    DISTINCT visited_on, 
    SUM(amount) OVER(ORDER BY visited_on RANGE BETWEEN INTERVAL 6 DAY  PRECEDING AND CURRENT ROW) as amount, 
    min(visited_on) over() as date_fisrt 
    FROM Customer
)
SELECT 
    visited_on, 
    amount, 
    ROUND(amount/7, 2) average_amount
FROM cte
WHERE visited_on >= date_fisrt + 6;

--EX5:
SELECT 
    ROUND(SUM(tiv_2016), 2) AS tiv_2016
FROM Insurance
WHERE tiv_2015 IN (
                    SELECT tiv_2015
                    FROM Insurance
                    GROUP BY tiv_2015
                    HAVING COUNT(*) > 1)
AND (lat, lon) IN (
                    SELECT lat, lon
                    FROM Insurance
                    GROUP BY lat, lon
                    HAVING COUNT(*) = 1)

--EX6:
With cte as (
    SELECT 
        *,
        dense_rank() over(partition by departmentId order by salary desc ) as raning_department
    FROM employee)

SELECT
    d.name as Department,
    cte.name AS Employee ,
    cte.salary AS Salary 
FROM cte
INNER JOIN department as d
ON cte.departmentid = d.id
WHERE raning_department <= 3;

--EX7:
WITH cte AS (
    SELECT 
        turn, person_name, weight,
        SUM(weight) OVER(ORDER BY turn ASC) AS total_weight 
    FROM Queue
    ORDER BY turn
)
SELECT person_name
FROM Queue 
WHERE turn = (SELECT MAX(turn) FROM cte WHERE total_weight <= 1000);

--ex8:
WITH cte1 as (
    SELECT DISTINCT
    product_id, 
    FIRST_VALUE(new_price) OVER(PARTITION BY product_ID ORDER BY change_date DESC) AS price
  FROM Products
  WHERE change_date <= '2019-08-16'
),
cte2 as (
    SELECT 
        DISTINCT product_id
    FROM Products
)

SELECT
  cte2.product_id, 
  COALESCE(price, 10) AS price
FROM cte2
LEFT JOIN cte1
ON cte1.product_id = cte2.product_id;
