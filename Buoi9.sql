--ex1:
SELECT 
    SUM( case when device_type = 'laptop' then 1 else 0 end) as laptop_views,
    SUM(case when device_type  != 'laptop' then 1 else 0 end) as mobile_views
FROM viewership;
-ex2:
select *,
case 
    when (x+y>z) and (x+z>y) and (y+z>x) then 'Yes'
    else 'No'
end as triangle
From triangle
--ex3:


--ex4:
select name
from customer
where referee_id != 2 or referee_id IS NULL
--ex5:
select survived,
    sum(case when pclass = 1 then 1 ELSE 0 end) as first_class,
    sum(case when pclass = 2 then 1 ELSE 0 end) as second_class,
    sum(case when pclass = 3 then 1 ELSE 0 end) as third_class
from titanic
group by survived
