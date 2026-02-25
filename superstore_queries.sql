-- Create a new database for our project
CREATE DATABASE superstore_db;

-- Select it
USE superstore_db;

-- Create table matching our CSV columns exactly
CREATE TABLE superstore (
    Row_ID INT,
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(30),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(50),
    Segment VARCHAR(20),
    Country VARCHAR(30),
    City VARCHAR(50),
    State VARCHAR(30),
    Postal_Code INT,
    Region VARCHAR(20),
    Product_ID VARCHAR(20),
    Category VARCHAR(30),
    Sub_Category VARCHAR(30),
    Product_Name VARCHAR(200),
    Sales DECIMAL(10,2),
    Quantity INT,
    Discount DECIMAL(4,2),
    Profit DECIMAL(10,2)
);



-- Check how many rows imported
SELECT COUNT(*) FROM superstore;
-- Should show 9994

-- Preview first 5 rows
SELECT * FROM superstore LIMIT 5;



-- Overall KPIs
SELECT 
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS Profit_Margin_Pct
FROM superstore;
-- sales by region
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS Profit_Margin_Pct,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- loss making sub-caegories
SELECT 
    Sub_Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS Profit_Margin_Pct
FROM superstore
GROUP BY Sub_Category
HAVING Total_Profit < 0
ORDER BY Total_Profit ASC;

-- discount impact
SELECT 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.2 THEN 'Low (0-20%)'
        WHEN Discount <= 0.4 THEN 'Medium (20-40%)'
        ELSE 'High (40%+)'
    END AS Discount_Band,
    COUNT(*) AS Orders,
    ROUND(AVG(Profit), 2) AS Avg_Profit,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY Discount_Band
ORDER BY Avg_Profit DESC;

-- top 10 customers
SELECT 
    Customer_Name,
    Segment,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM superstore
GROUP BY Customer_Name, Segment
ORDER BY Total_Sales DESC
LIMIT 10;


-- yearly trend
SELECT 
    YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y')) AS Year,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND((SUM(Profit)/SUM(Sales))*100, 2) AS Profit_Margin_Pct
FROM superstore
GROUP BY YEAR(STR_TO_DATE(Order_Date, '%m/%d/%Y'))
ORDER BY Year ASC;

-- best and worst states
SELECT 
    State,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Profit DESC
LIMIT 5;