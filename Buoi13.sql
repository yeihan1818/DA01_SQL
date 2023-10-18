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

