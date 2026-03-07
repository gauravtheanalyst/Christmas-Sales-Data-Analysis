--Christmas Sales Data Analysis using SQL--

-- CREATE TABLE christmas_sales_trends AND CONNECT IMPORT THE DATA --

CREATE TABLE christmas_sales_trends (
    transaction_id INT,
    date DATE,
    customer_id INT,
    age INT,
    gender TEXT,
    location TEXT,
    product_id INT,
    category TEXT,
    quantity INT,
    unit_price NUMERIC,
    payment_type TEXT,
    promotion_applied BOOLEAN,
    discount_amount NUMERIC,
    gift_wrap BOOLEAN,
    event TEXT,
    customer_satisfaction INT,
    return_flag BOOLEAN
);

--Display all records from the Christmas sales dataset to understand the structure and available fields.

Select * from christmas_sales_trends;

--Create a new Column Total_Amount by Altering Table & Set Column Transaction_id Primary Key .

Alter table christmas_sales_trends 
Add Total_Amount int ;

ALTER TABLE christmas_sales_trends 
ADD CONSTRAINT transaction_id
PRIMARY KEY (transaction_id);

-- Add Values in Total_Amount By calculating quantity * unit_price - discount_amount to retrive revenue without discount.

UPDATE christmas_sales_trends
Set total_amount = (quantity * unit_price) - discount_amount ;

--Determine the overall revenue generated from all Christmas sales transactions.

Select Sum(Total_amount) as Total_revenue from christmas_sales_trends ; 

--Analyze which product categories generate the highest revenue during the Christmas sales period.

Select category,
       SUM(total_amount)
	   from christmas_sales_trends
	   group by category
	   order by 2;

--Identify the total revenue generated each year to understand yearly sales trends.

SELECT 
      EXTRACT(YEAR from date) as Year,
	  SUM(quantity * unit_price - COALESCE(discount_amount,0))as Revenue
	  from christmas_sales_trends
	  group by EXTRACT(YEAR from date)
	  order by 2 desc;

--Evaluate which locations generate the most orders and revenue.

SELECT
      location,
      COUNT(transaction_id) as Total_orders,
	  SUM(total_amount) as Total_Revenue_generated
FROM christmas_sales_trends
 GROUP BY location 
 ORDER BY 2 desc ;


--Find the top 10 most frequently sold products based on quantity sold.

SELECT product_id as Most_selling_product,
       COUNT(quantity) as Quantity
from christmas_sales_trends 
group by 1
order by 2 desc
limit 10;

--Compare revenue generated with and without promotional offers to analyze promotion effectiveness.

SELECT promotion_applied,
       SUM(Total_amount) as Total_Revenue
	   from christmas_sales_trends
       group by 1  ;     

--Determine average spending per transaction across different events.

SELECT event,
       Avg(Total_amount) as Avg_spent from christmas_sales_trends
	   group by 1;

--Identify which payment methods customers use most frequently.

SELECT payment_type,
       COUNT(transaction_id) as Total_Orders from christmas_sales_trends
	   group by 1 
	   order by 2 desc;

--Analyze how gift wrapping services contribute to total revenue.

SELECT gift_wrap,
	   SUM(Total_amount) as Total_Revenue from christmas_sales_trends
	   group by 1 
	   order by 2 desc;

--Calculate the percentage of total orders that resulted in product returns.

SELECT 
    COUNT(CASE WHEN Return_Flag = TRUE THEN 1 END) * 100.0 / COUNT(*) AS return_rate_percentage
FROM christmas_sales_trends;


--Identify which product categories have the highest return rates.

SELECT Category,COUNT(CASE WHEN return_flag = true THEN 1 END) * 100.0 / COUNT(*) AS Return_rate_percentages
from christmas_sales_trends
group by 1;

--Analyze the relationship between customer satisfaction ratings and product returns.

SELECT 
       COUNT(transaction_id)as Total_orders,
	   customer_satisfaction,
       COUNT(CASE WHEN return_flag = true THEN 1 END) as Returns
	   from christmas_sales_trends
	   group by 2
	   order by 2 desc;

--Retrive the Product_id which Returned Most.

SELECT Product_id As Most_returned_product, 
       COUNT(CASE WHEN return_flag = true Then 1 END) as Total_returned
	   from christmas_sales_trends 
	   group by 1 
	   order by 2 desc 
	   limit 10;

--Segment customers by age groups and determine which age group contributes the most revenue.

SELECT 
      CASE 
	     WHEN age < 25 then 'under_25'
		 WHEN age BETWEEN 25 AND 40 THEN '25-40'
		 WHEN age BETWEEN 40 AND 60 THEN '40-60'
		 ELSE '60+'
	  END AS Age_Group,
	  SUM(Total_amount) as Revenue
	  from christmas_sales_trends
	  group by 1 
	  order by 2 desc;

--Find the top 10 days that generated the highest revenue during the Christmas sales period.

SELECT 
      date,
	  SUM(total_amount) as Total_revenue_generated_at_a_day
	  from christmas_sales_trends
	  group by date
	  order by 2 desc
	  limit 10;

--Determine which events drive the highest sales revenue.

SELECT 
     event,
	 SUM(total_amount) as Revenue_by_Events
	 from christmas_sales_trends
	 group by event
	 order by 2 desc ; 

--Analyze gross revenue, total discounts, and final revenue after discounts for each product category.

SELECT 
      category,
	  SUM(quantity * unit_price) as Gross_Revenue,
	  SUM(discount_amount) as Discounted_amount,
	  SUM(Total_amount) as Revenue_without_discount
	  from christmas_sales_trends
	  group by category
	  order by 3 desc;

 
 