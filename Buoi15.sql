--EX1:
WITH cte AS ( 
    SELECT 
        EXTRACT(year from transaction_date) as year,
        product_id,
        spend as curr_year_spend,
        LAG(spend) OVER(PARTITION BY product_id ORDER BY  EXTRACT(year from transaction_date)) as pre_year_spend
    FROM user_transactions
)
SELECT
    year,
    product_id,
    curr_year_spend,
    pre_year_spend,
    ROUND(
    (curr_year_spend - pre_year_spend) :: numeric / COALESCE(pre_year_spend, 1) *100, 2
    ) as yoy_rate
FROM cte 

--EX2:
WITH cte AS(
    SELECT 
      card_name,
      issued_amount,
      Rank() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) as ranking
    FROM monthly_cards_issued
)
SELECT
    card_name,
    issued_amount
FROM cte 
WHERE ranking = 1
ORDER BY issued_amount desc;

--EX3:
WITH cte AS (
  SELECT 
    user_id,
    spend,
    transaction_date,
    rank() over(PARTITION BY user_id order by transaction_date) as ranking
  FROM transactions
)
SELECT
    user_id,
    spend,
    transaction_date
FROM cte 
where ranking = 3;

--ex4:
WITH cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    rank() over(PARTITION BY user_id ORDER BY transaction_date desc) as ranking
  FROM user_transactions
  )
SELECT
  transaction_date,
  user_id,
  count(*) as purchase_count
FROM cte 
WHERE ranking = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date;
--EX5:
SELECT 
    t1.user_id,
    t1.tweet_date,
    ROUND(
      avg(t2.tweet_count),2
    ) as rolling_avg_3d
  
FROM tweets as t1
INNER JOIN tweets as t2
ON t1.user_id = t2.user_id
AND t2.tweet_date BETWEEN t1.tweet_date - INTERVAL '2 days' 
                  AND t1.tweet_date
GROUP BY t1.user_id, t1.tweet_date
ORDER BY t1.user_id, t1.tweet_date;

--EX6:
With cte AS (
    SELECT 
      *,
      LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount
                                        ORDER BY transaction_timestamp
                                        ) as pre_transaction
    FROM transactions 
    )
SELECT 
  COUNT(merchant_id) as payment_count
FROM cte 
WHERE transaction_timestamp - pre_transaction <= INTERVAL '10 minutes';

--ex7:
WITH cte AS (
  SELECT 
    category,
    product,
    SUM(spend) as total_spend,
    RANK() OVER(PARTITION BY category ORDER BY sum(spend) desc) as ranking
  FROM product_spend
  WHERE EXTRACT(year from transaction_date) = 2022
  GROUP BY category, product
  )
SELECT
  category,
  product,
  total_spend 
FROM cte 
WHERE ranking < 3
ORDER BY category, ranking

-- ex8:
WITH cte AS (
  SELECT 
    a.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(s.song_id) DESC) AS artist_ranking
  FROM artists as a
  INNER JOIN songs as s
  ON a.artist_id = s.artist_id
  INNER JOIN global_song_rank AS gs_ranking
    ON s.song_id = gs_ranking.song_id
  WHERE gs_ranking.rank <= 10
  GROUP BY a.artist_name
)

SELECT artist_name, artist_ranking
FROM cte
WHERE artist_ranking <= 5;
