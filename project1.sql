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

/* Thêm cột 
CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
Chuẩn hóa 
CONTACTLASTNAME, CONTACTFIRSTNAME 
theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. */
select
	contactfullname,
	left(contactfullname, position('-' in contactfullname)- 1), 
	concat(
		upper(left(left(contactfullname, position('-' in contactfullname)- 1), 1)), 
		   lower(substring(left(contactfullname, position('-' in contactfullname)- 1),2))
	),
	right(contactfullname, length(contactfullname)- position('-' in contactfullname)),
	concat(
		upper(left(right(contactfullname, length(contactfullname)- position('-' in contactfullname)), 1)), 
		lower(substring(right(contactfullname, length(contactfullname)- position('-' in contactfullname)),2))
	)
from sales_dataset_rfm_prj


alter table sales_dataset_rfm_prj
add CONTACTFIRSTNAME VARCHAR(50)

alter table sales_dataset_rfm_prj
add CONTACTLASTNAME VARCHAR(50)

INSERT INTO sales_dataset_rfm_prj(CONTACTFIRSTNAME, CONTACTLASTNAME)
select * from (
SELECT 
	concat(
		upper(left(left(contactfullname, position('-' in contactfullname)- 1), 1)), 
		   lower(substring(left(contactfullname, position('-' in contactfullname)- 1),2))
	) as CONTACTFIRSTNAME,
		concat(
		upper(left(right(contactfullname, length(contactfullname)- position('-' in contactfullname)), 1)), 
		lower(substring(right(contactfullname, length(contactfullname)- position('-' in contactfullname)),2))
	) as CONTACTLASTNAME
FROM sales_dataset_rfm_prj) as a



