-- 1. Create a database to store the sales data (Redshift or PostgreSQL).
CREATE DATABASE SalesAnalysis;
USE SalesAnalysis;

-- Create a table named "sales_sample" with the specified columns:
CREATE TABLE sales_sample (
    Product_Id INT NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Date DATE NOT NULL,
    Sales_Amount DECIMAL(10, 2) NOT NULL
);


-- 2. Insert 10 sample records into the "sales_sample" table, representing sales data.
INSERT INTO sales_sample (Product_Id, Region, Date, Sales_Amount)
VALUES
    (101, 'East', '2024-01-01', 500.00),
    (102, 'West', '2024-01-02', 450.00),
    (103, 'North', '2024-01-03', 600.00),
    (104, 'South', '2024-01-04', 700.00),
    (101, 'East', '2024-01-05', 550.00),
    (102, 'West', '2024-01-06', 470.00),
    (103, 'North', '2024-01-07', 620.00),
    (104, 'South', '2024-01-08', 750.00),
    (101, 'East', '2024-01-09', 580.00),
    (102, 'West', '2024-01-10', 500.00);

-- 3. Perform OLAP operations
-- a) Drill Down: Analyze Sales by Product within a Region
SELECT 
    Region, 
    Product_Id, 
    SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY Region, Product_Id
ORDER BY Region, Product_Id;

-- b) Rollup: Summarize Sales by Region
SELECT 
    Region, 
    SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
GROUP BY ROLLUP(Region)
ORDER BY Region;


-- c) Cube: Analyze Sales by Multiple Dimensions
SELECT 
    Product_Id, 
    Region, 
    DATE_TRUNC('month', Date) AS Month, 
    SUM(Sales_Amount) AS Total_Sales
FROM sales_sample
-- --GROUP BY CUBE (Product_Id, Region, DATE_TRUNC('month', Date))
GROUP BY Product_Id, Region, DATE_FORMAT(Date, '%Y-%m-01')
ORDER BY Product_Id, Region, Month;


-- d) Slice: Filter Data for a Specific Region or Date Range
SELECT *
FROM sales_sample
WHERE Region = 'East' AND Date BETWEEN '2024-01-01' AND '2024-01-09';


-- e) Dice - To extract data based on multiple criteria.
SELECT 
    Product_Id, 
    Region, 
    DATE_FORMAT(Date, '%Y-%m-%d') AS Sale_Date, 
    Sales_Amount
FROM sales_sample
WHERE 
    Product_Id IN (101, 103)  -- Specific products
    AND Region IN ('East', 'West')  -- Specific regions
    AND Date BETWEEN '2024-01-01' AND '2024-01-09'  -- Specific date range
ORDER BY Product_Id, Region, Sale_Date;
