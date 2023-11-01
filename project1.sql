--Buoi19:Practice 9- Project1

select * from public.sales_dataset_rfm_prj

ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN quantityordered TYPE numeric USING (trim(quantityordered)::numeric);

ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN priceeach TYPE numeric USING (trim(priceeach)::numeric);

ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN sales TYPE numeric USING (trim(sales)::numeric);

ALTER TABLE sales_dataset_rfm_prj 
ALTER COLUMN orderdate TYPE date USING (trim(orderdate)::date);

/*Check NULL/BLANK (‘’)  ở các trường: 
ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDE*/

select *
from sales_dataset_rfm_prj
where ORDERNUMBER = ' ' 
	or QUANTITYORDERED is null
	or PRICEEACH is null
	or ORDERLINENUMBER is null
	or SALES is null
	or ORDERDATE is null


/* Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME 
được tách ra từ CONTACTFULLNAME . */

--Thêm cột
ALTER TABLE sales_dataset_rfm_prj
ADD column contactfirstname VARCHAR(50)

ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname VARCHAR(50)

--Update data vào cột
UPDATE sales_dataset_rfm_prj
SET contactfirstname = UPPER(LEFT(contactfullname,1))||
LOWER(SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2))

UPDATE sales_dataset_rfm_prj
SET contactlastname = UPPER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1,1))||
LOWER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2,LENGTH(contactfullname)))

/*Thêm cột QTR_ID, MONTH_ID, YEAR_ID 
lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE */
-- thêm cột
ALTER TABLE sales_dataset_rfm_prj
ADD column qtr_id float

ALTER TABLE sales_dataset_rfm_prj
ADD column MONTH_ID float

ALTER TABLE sales_dataset_rfm_prj
ADD column YEAR_ID float

--Update data vào cột
UPDATE public.sales_dataset_rfm_prj
SET qtr_id = extract(quarter from orderdate)

UPDATE sales_dataset_rfm_prj
SET MONTH_ID = extract(month from orderdate)

UPDATE sales_dataset_rfm_prj
SET YEAR_ID = extract(year from orderdate)

/* Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED 
và hãy chọn cách xử lý cho bản ghi đó*/
WITH twt_min_max_value as (
SELECT
	q1-1.5 * iqr as min_value,
	q3+1.5* iqr as max_value
FROM (
	SELECT
		percentile_cont(0.25) within group (order by quantityordered ) as  q1,
		percentile_cont(0.75) within group (order by quantityordered) as q3,
		percentile_cont(0.75) within group (order by quantityordered)
		- percentile_cont(0.25) within group (order by quantityordered) as iqr
	FROM public.sales_dataset_rfm_prj) as a
)
SELECT * FROM sales_dataset_rfm_prj
WHERE 
	quantityordered < (select min_value from twt_min_max_value)
	or quantityordered > (select max_value from twt_min_max_value)

--xu ly outlier-update
UPDATE sales_dataset_rfm_prj
Set quantityordered = (select avg(quantityordered) from sales_dataset_rfm_prj)
Where quantityordered IN (
	SELECT quantityordered FROM 
		(SELECT * FROM sales_dataset_rfm_prj
		 WHERE 
				quantityordered < (select min_value from twt_min_max_value)
				or quantityordered > (select max_value from twt_min_max_value)
			) as cte)
-- delete
delete from sales_dataset_rfm_prj
where quantityordered in IN (
		SELECT quantityordered FROM 
		(SELECT * FROM sales_dataset_rfm_prj
		 WHERE 
				quantityordered < (select min_value from twt_min_max_value)
				or quantityordered > (select max_value from twt_min_max_value)
			) as cte)
/*Sau khi làm sạch dữ liệu, hãy lưu vào bảng mới  tên là SALES_DATASET_RFM_PRJ_CLEAN*/
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN as 
(
	select * from sales_dataset_rfm_prj
)

