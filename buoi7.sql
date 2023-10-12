--EX1:
select
     name
from students
where marks > 75
order by right(name, 3), id asc;
--ex2:
select
    user_id,
    concat(upper(left(name, 1)), lower(substring(name,2))) as name
from users
order by user_id
-ex3:
SELECT
  manufacturer,
  concat('$',round(sum(total_sales)/10^6), ' million') as sales_mil
FROM pharmacy_sales
group by manufacturer
order by round(sum(total_sales)/10^6) desc, manufacturer desc;
--ex4:
SELECT 
  extract(month from submit_date) as mth,
  product_id as product,
  round(avg(stars), 2) as avg_stars
FROM reviews
group by product_id, extract(month from submit_date)
order by mth, product;
--ex5:
SELECT
  sender_id,
  count(*) as message_count
FROM messages
where to_char(sent_date, 'mm-yyyy') = '08-2022'
group by sender_id
order by message_count DESC
limit 2;
-ex6:
select
    tweet_id 
from tweets
where length(content)> 15;
--ex7:
select
    activity_date as day,
    count(distinct user_id) as active_users
from activity
where   activity_date between (date('2019-07-27')- interval 30 day) and '2019-07-27'
group by day
--ex8:
select 
    count(*)
from employees
where joining_date between '2022-01-01' and '2022-07-31'
-ex9:
select 
    position ('a' in  'Amitah')
--ex10:
select winery,
    substring( title from position(' ' in title) for 5) :: numeric as year
from winemag_p2
where country = 'Macedonia';
