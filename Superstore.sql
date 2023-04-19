-- Specify the databse you are storing the dataset in 
select * from superstore;


-- SQL Project Idea: Clean the data first using the data preprocessing method and make it SQL-ready. After that, complete the following tasks:

--1) Use window function to divide each category and compare it to their maximun sales and ranking the days per day according sales descendingly
select cast(`Order Date` as date) as order_date ,category, sales as total_sales, 
max(sales) over(partition by category) as max_sales ,
rank() over(partition by category order by sales desc) as Rank_s from superstore
group by 1;

--2) Use the LEAD window function to create a new column sales_next that displays the sales of the next row in the dataset. 
 /*This function will help you quickly compare a given row’s values and values in the next row (Here we have orderd it such a way to represent 
sales of present and next it's succesor day .*/

select cast(`Order Date` as date) as order_date,category, sum(sales) as total_sales, 
lead(sales) over(partition by category order by sales desc) as sales_next
from superstore
group by 1;


-- 3) Create a new column sales_previous to display the values of the row above a given row.
select cast(`Order Date` as date) as order_date,category, sum(sales), 
lag(sales) over(partition by category ) as sales_previous
from superstore
group by 1;

-- 4) Rank the data based on sales in descending order using the RANK function for sales per segment.
select segment,  cast(`Order Date` as date) as order_date, Sales as total_sales_per_segment,
rank() over(partition by segment order by sales desc ) as Rank_s
from superstore
group by 2
;

--5) Use common SQL commands and aggregate functions to show the monthly and daily sales averages.
select cast(`Order Date` as date) as order_date, avg (sales) as daily_avg_sales from superstore
group by 1;

select month(cast(`Order Date` as date)) as order_month, year(cast(`Order Date` as date)) as order_year, avg (sales) as monthly_avg_sales 
from superstore
group by 1,2
order by 1;

--6) Analyze discounts on two consecutive days.
select cast(`Order Date` as date) as order_date, discount as dis1, 
lead(discount) over() as dis_next
from superstore
group by 1
order by 1;

-- 7) Rank the data 
select `Order ID`,sales, rank() over( order by sales desc) as rank_c from superstore;

--8) Evaluate moving averages using the window functions.
SELECT (cast(`Order Date` as date)) as sales_date, year(cast(`Order Date` as date)) as order_year,
avg(Sales) over (order by `Order Date`rows between 11 preceding and current row ) as moving_avg ,
count(sales) over (order by `Order Date`                
rows between 11 preceding and current row ) as records_count 
FROM superstore 
group by 1; 
/* Since the dataset is sparse this may not be the best approach see Moving_average.png for better explanation*/
