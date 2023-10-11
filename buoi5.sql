--EX1:
select distinct city from station
where mod(id, 2)= 0;
--EX2:
select count(city) - count(distinct city) 
from station;
--EX3
select cast(CEILING(avg(cast(salary as float)) - avg(cast(replace(salary,0,'') as float))) as int) from employees;
--EX4:
SELECT round(cast(sum(item_count*order_occurrences)/ sum(order_occurrences) as decimal),1)
FROM items_per_order;
--ex5:
SELECT candidate_id
FROM candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(skill) = 3
--ex6:
SELECT user_id, 
    max(date(post_date))- min (date(post_date)) as days_between
FROM posts
where EXTRACT(year from post_date) = 2021
group by user_id
having max(date(post_date))- min (date(post_date)) <> 0;
--ex7:
SELECT card_name,
  max(issued_amount)- min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc
--ex8:
SELECT manufacturer, 
        count(distinct product_id) as drug_count, 
        sum(cogs- total_sales) as total_loss
FROM pharmacy_sales
where cogs> total_sales
group by manufacturer
order by total_loss desc
--ex9:
select *
from cinema
where mod(id, 2) != 0 and description != 'boring'
order by rating desc;
--ex10:
select
    teacher_id,
    count(distinct subject_id) as cnt
from teacher
group by teacher_id
--ex11:
select
    user_id,
    count(follower_id) as followers_count
from followers
group by user_id
order by user_id
--ex12:
select
    class
from courses
group by class
having count(student)>= 5
