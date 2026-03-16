/*
Project: Revenue Leakage Investigation
Dataset: E-commerce Sales Data
*/

use revenue

update ecommerce
set state = 'karnataka'
where state = 'KA'

update ecommerce
set state = 'Telangana'
where state = 'TG'

-- Total Revenue
select SUM(revenue) as total_revenue
from ecommerce
/* company generated nearly 23.35 million in sales from all orders */


-- How much of this revenue actually turns into profit?
select SUM(revenue) as total_revenue,SUM(profit) as total_profit,SUM(profit)/SUM(revenue)*100 as profit_margin
from ecommerce
/* 
The company operates with a 34% margin is relatively strong, meaning the company retains about $0.34 profit for every $1 of revenue.
*/


-- Which product categories drive the most revenue?
select category,SUM(revenue) as revenue
from ecommerce
group by category
order by revenue desc
/* 
Electronics is the top-performing category, generating $7.87M, which represents roughly 34% of total company revenue.
The business relies heavily on Electronics sales Other categories contribute moderately but consistently
*/


-- Profit by category
select category,SUM(profit) as profit
from ecommerce
group by category
order by profit desc
/*
- Electronics generates the highest revenue and highest profit, making it the core business driver.
- Although Office Supplies generates more revenue than Clothing, Clothing generates higher profit.
- Furniture revenue is the lowest, but profit is relatively strong
*/


-- Which category is actually the most profitable per dollar of revenue.
select category,SUM(profit) / SUM(revenue) * 100 AS profit_margin
from ecommerce
group by category
order by profit_margin desc
/*
- Furniture Is the Most Profitable Category although Furniture generates the lowest revenue, it has the highest profit margin (37.4%).
- Electronics generates the highest revenue and profit, but its profit margin is lower than most categories 
- Office Supplies shows the lowest profit margin (31.14%)
*/


-- Are some products being sold at a loss?
select product_name,SUM(profit) as total_profit
from ecommerce
group by product_name
having SUM(profit) < 0
order by total_profit 
/* 
The analysis shows multiple products generating negative total profit. This means these products are consistently sold below profitable levels.
*/


-- Discount impact on profit
select discount,avg(profit) as avg_profit
from ecommerce
group by discount
order by discount
/* it shows higher discount higher profit but this analysis is incomplete we need to check
- How many orders per discount level
- Profit margin instead of profit
- How many orders lose money
*/

select discount,COUNT(*) as orders,AVG(profit) as avg_profit,AVG(profit_margin) as avg_margin
from ecommerce
group by discount
order by discount
/*
- Most Orders Have No Discount which means the company is not heavily dependent on discounting to generate sales
- 20% Discount Has the Lowest Profit Margin
- 30% Discount Still Produces High Profit
Discounts do not necessarily destroy profit but they reduce profit margin
*/


-- Revenue by State
select state,SUM(revenue) as revenue
from ecommerce
group by state
order by revenue desc
/* 
Karnataka and Telangana dominate revenue Maharashtra is the third largest market
*/


-- Profit by state
select state,SUM(profit) as profit
from ecommerce
group by state
order by profit desc
/*
Telangana + Karnataka are Primary profit drivers
Maharashtra is a Secondary market
*/


-- Shipping cost investigation
select AVG(shipping_cost) as avg,MAX(shipping_cost) as max
from ecommerce
/* Some Orders Have Extremely High Shipping Cost */


-- Does High Shipping Reduce Profit?
select AVG(profit) as profit
from ecommerce
where shipping_cost > 200
/* Logistics Cost Is a Revenue Leakage Driver High shipping costs are eating into profitability */


/*
Key Insights:
- Strong Overall Profitability
The company generates $23.35M revenue with a 34% profit margin, indicating a healthy overall business.
- Electronics Drives Revenue
Electronics is the largest revenue and profit contributor, making it the core business category.
- Furniture Has the Highest Profit Efficiency
Furniture has the highest profit margin (37.4%), showing strong pricing efficiency.
- Loss-Making Products Exist
Several products generate negative total profit, indicating pricing or discount issues.
- Discounts Reduce Margin Efficiency
Higher discounts lower profit margins, even if total profit remains positive.
- Revenue Concentrated in Two States
Most revenue and profit come from Telangana and Karnataka, indicating regional concentration.
- Logistics Costs Reduce Profit
Orders with shipping cost above $200 have drastically lower profitability, suggesting operational inefficiencies.
*/


