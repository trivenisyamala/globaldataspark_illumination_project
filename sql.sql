# Customer Analysis

# Q1 Demographic Distribution: Analyze the distribution of customers based on gender, age (calculated from birthday), location (city, state, country, continent).
SELECT Gender, 
       FLOOR(DATEDIFF(CURDATE(), Birthday) / 365) AS Age, 
       City, State, Country, Continent, 
       COUNT(CustomerKey) AS Total_Customers
FROM customers
GROUP BY Gender, Age, City, State, Country, Continent;


#Q2 Purchase Patterns: Identify purchasing patterns such as average order value, frequency of purchases, and preferred products.
SELECT 
    S.CustomerKey,
    AVG(P.UnitPriceUSD * S.Quantity) AS Average_Order_Value,
    COUNT(S.Order_Number) AS Total_Orders
FROM sales S
JOIN products P ON S.ProductKey = P.ProductKey
GROUP BY S.CustomerKey;

SELECT 
    P.ProductName, 
    SUM(S.Quantity) AS Total_Quantity_Sold
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.ProductName
ORDER BY Total_Quantity_Sold DESC;

SELECT C.CustomerKey, 
       C.Name, 
       P.ProductName, 
       SUM(S.Quantity) AS Total_Quantity_Purchased
FROM sales S
JOIN customers C ON S.CustomerKey = C.CustomerKey
JOIN products P ON S.ProductKey = P.ProductKey
GROUP BY C.CustomerKey, P.ProductName
ORDER BY Total_Quantity_Purchased DESC;

#Q3 Segmentation: Segment customers based on demographics and purchasing behavior to identify key customer groups.
SELECT 
    C.CustomerKey, 
    C.Name, 
    CASE 
        WHEN SUM(S.Quantity * P.UnitPriceUSD) > 1000 THEN 'High Value'
        WHEN SUM(S.Quantity * P.UnitPriceUSD) BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS Customer_Segment
FROM sales S
JOIN customers C ON S.CustomerKey = C.CustomerKey
JOIN products P ON S.ProductKey = P.ProductKey
GROUP BY C.CustomerKey;

#Q4 Sales Analysis: Overall Sales Performance, Analyze total sales over time, identifying trends and seasonality

SELECT YEAR(Order_Date) AS Year, 
       MONTH(Order_Date) AS Month, 
       SUM(Quantity) AS Total_Sales
FROM sales
GROUP BY Year, Month
ORDER BY Year, Month;

#Q5Sales by Product: Evaluate which products are the top performers in terms of quantity sold and revenue generated.
SELECT P.ProductName, 
       SUM(S.Quantity) AS Total_Quantity_Sold, 
       SUM(S.Quantity * P.UnitPriceUSD) AS Total_Revenue
FROM sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.ProductName
ORDER BY Total_Revenue DESC, Total_Quantity_Sold DESC;

#Q6Sales by Store: Assess the performance of different stores based on sales data
SELECT St.StoreKey, 
       SUM(S.Quantity) AS Total_Sales, 
       COUNT(S.Order_Number) AS Total_Orders
FROM sales S
JOIN Stores St ON S.StoreKey = St.StoreKey
GROUP BY S.StoreKey
ORDER BY Total_Sales DESC;

#Q7 Sales based on currency
SELECT 
    S.Currency_Code, 
    SUM(S.Quantity * P.UnitPriceUSD) AS Total_Amount, 
    SUM((S.Quantity * P.UnitPriceUSD) / E.Exchange) AS Total_Sales_USD
FROM sales S
LEFT JOIN products P ON S.ProductKey = P.ProductKey
LEFT JOIN exchangerates E ON S.Currency_Code = E.Currency
GROUP BY S.Currency_Code;

#Q8Product Popularity (Identify the most and least popular products based on sales data):

#-- Most popular products by quantity sold
SELECT 
    P.ProductName, 
    SUM(S.Quantity) AS Total_Quantity_Sold
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.ProductName
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;  #-- Adjust to show the top N products

#-- Least popular products by quantity sold
SELECT 
    P.ProductName, 
    SUM(S.Quantity) AS Total_Quantity_Sold
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.ProductName
ORDER BY Total_Quantity_Sold ASC
LIMIT 10;  #-- Adjust to show the bottom N products

#Q9Profitability Analysis (Calculate profit margins for products by comparing unit cost and unit price):
SELECT 
    P.ProductName, 
    P.UnitPriceUSD, 
    P.UnitCostUSD, 
    (P.UnitPriceUSD - P.UnitCostUSD) AS Profit_Margin
FROM Products P
ORDER BY Profit_Margin DESC;

#Q10Category Analysis (Analyze sales performance across different product categories and subcategories):
SELECT 
    P.Category, 
    P.Subcategory, 
    SUM(S.Quantity * P.UnitPriceUSD) AS Total_Sales
FROM Sales S
JOIN Products P ON S.ProductKey = P.ProductKey
GROUP BY P.Category, P.Subcategory
ORDER BY Total_Sales DESC;

#Q11 Store Performance (Evaluate store performance based on sales, size (square meters), and operational data (open date)):

SELECT 
    Stores.StoreKey, 
    SUM(Sales.Quantity * Products.UnitPriceUSD) AS Total_Sales,
    Stores.Square_Meters, 
    Stores.Open_Date
FROM Sales
JOIN Products ON Sales.ProductKey = Products.ProductKey
JOIN Stores ON Sales.StoreKey = Stores.StoreKey
GROUP BY Stores.StoreKey
ORDER BY Total_Sales DESC;

#Q12 Geographical Analysis (Analyze sales by store location to identify high-performing regions):
SELECT 
    Stores.State, 
    Stores.Country, 
    SUM(Sales.Quantity * Products.UnitPriceUSD) AS Total_Sales
FROM Sales
JOIN Products ON Sales.ProductKey = Products.ProductKey
JOIN Stores ON Sales.StoreKey = Stores.StoreKey
GROUP BY Stores.State, Stores.Country
ORDER BY Total_Sales DESC;


