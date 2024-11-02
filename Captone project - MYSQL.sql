select * from amazon;

alter table amazon
add Month_name varchar(10);
set SQL_safe_updates = 0;

update demo.amazon
set Month_name = 
case 
when MONTH(DATE) = 1 THEN 'January'
when MONTH(DATE) = 2 THEN 'February'
when MONTH(DATE) = 3 THEN 'March'
when MONTH(DATE) = 4 THEN 'April'
when MONTH(DATE) = 5 THEN 'May'
when MONTH(DATE) = 6 THEN 'June'
when MONTH(DATE) = 7 THEN 'July'
when MONTH(DATE) = 8 THEN 'August'
when MONTH(DATE) = 9 THEN 'September'
when MONTH(DATE) = 10 THEN 'October'
when MONTH(DATE) = 11 THEN 'November'
when MONTH(DATE) = 12 THEN 'December'
end;

alter table amazon
add Timeofday Varchar(20);

update amazon
set Timeofday = 
case 
when Hour(time) >= 0 and Hour(time) < 12 then 'Morning'
when Hour(time) >= 12 and Hour(time) < 15 then 'Afternoon'
else 'Evening'
end;

alter table amazon
add Dayname varchar(20);

update amazon
set Dayname = dayname(date);

-- EDA - Exploratory Data Analysis --

-- What is the count of distinct cities in the dataset?--
select count(distinct(city)) from amazon;

-- For each branch, what is the corresponding city? --
select Branch, city from amazon group by Branch, city; 

-- What is the count of distinct product lines in the dataset?--
select count(distinct(Product_line)) from amazon;

-- Which payment method occurs most frequently? --
select max(Payment) from amazon;

-- Which product line has the highest sales? --
select Product_line, sum(total) as sales from amazon
group by  product_line
order by sales desc
limit 1;

-- How much revenue is generated each month? --
select Month_name, sum(total) as revenue from amazon 
group by Month_name;

-- In which month did the cost of goods sold reach its peak? --
select month_name, max(cogs) as cost_goods_sold from amazon
group by Month_name
order by cost_goods_sold desc
limit 1;

-- Which product line generated the highest revenue? --
select Product_line, sum(total) as revenue from amazon 
group by Product_line
order by revenue desc
limit 1;

-- In which city was the highest revenue recorded? --
select city, max(total) as highest_revenue from amazon
group by City
order by highest_revenue desc
limit 1;

-- Which product line incurred the highest Value Added Tax? --
select product_line, sum(`Tax-five percent`) as highest_VAT from amazon
group by Product_line
order by highest_VAT desc
limit 1;

-- For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad." --
select product_line,
case 
when total>avg(total) over(partition by product_line) then 'Good'
else 'Bad'
end as Sales_review
from amazon;

-- Identify the branch that exceeded the average number of products sold --
select branch, sum(quantity) as sold from amazon
group by branch having sum(quantity) >
(select avg(quantity) * count(distinct branch) from amazon) limit 1;

-- Which product line is most frequently associated with each gender? -- 
select gender, product_line, count(*) as frequency from amazon
group by gender, product_line order by frequency desc
limit 1;

-- Calculate the average rating for each product line --
select product_line, avg(rating) as avg_rating_products from amazon
group by product_line
order by avg_rating_products desc; 

-- Count the sales occurrences for each time of day on every weekday.--
select timeofday, Dayname, count(cogs) as sales_count from amazon
group by timeofday, dayname
order by sales_count desc;

-- Identify the customer type contributing the highest revenue.--
select `customer type`, sum(total) as highest_revenue from amazon
group by `customer type`
order by highest_revenue desc
limit 1;

-- Determine the city with the highest VAT percentage.--
select city, max(`tax-five percent`) as highest_VAT_percentage from amazon
group by city
order by sum(`tax-five percent`) desc
limit 1;

-- Identify the customer type with the highest VAT payments.--
select `customer type`, max(`tax-five percent`) as highest_VAT_Payment
from amazon group by `customer type` order by highest_VAT_payment desc limit 1;

-- What is the count of distinct customer types in the dataset?--
select count(distinct(`customer type`)) as distinct_customer_type from amazon;

-- What is the count of distinct payment methods in the dataset? --
select count(distinct(payment)) as distinct_payment_methods from amazon;

-- Which customer type occurs most frequently? -- 
select max(`customer type`) as most_frequent_customer_type from amazon;

-- Identify the customer type with the highest purchase frequency.--
select `customer type`, avg(cogs) as purchase_frequency from amazon
group by `customer type`
order by purchase_frequency desc;

-- Determine the predominant gender among customers.--
select gender, count(*) as predominant_gender from amazon
group by gender
order by predominant_gender desc
limit 1;

-- Examine the distribution of genders within each branch. --
select branch, gender, count(*) as gender_count from amazon
group by branch, gender
order by gender_count desc;

-- Identify the time of day when customers provide the most ratings. --
select timeofday, avg(rating) as most_rating from amazon group by timeofday
order by most_rating desc;

-- Determine the time of day with the highest customer ratings for each branch.--
select branch, timeofday, round(avg(rating),2) as highest_ratings from amazon
group by branch, timeofday
order by branch, highest_ratings desc;

-- Identify the day of the week with the highest average ratings.--
select dayname, avg(rating) as highest_avg_rating from amazon
group by dayname
order by highest_avg_rating desc
limit 1;

-- Determine the day of the week with the highest average ratings for each branch.--
select branch,dayname,avg(rating) as highest_avg_rating from amazon
group by branch,dayname
order by branch, highest_avg_rating desc;
