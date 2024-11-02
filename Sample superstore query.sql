--Sample Superstore Data Exploration and Analysis

Skill Used: Join, Aggregate Functions, CTEs,Window Function.

--Sales Analysis
--Analyzing Total sales across different region
SELECT 
    R.Region,
    SUM(O.Sales) AS Total_Sales
FROM 
    order_details O
JOIN 
    [Dim_Region table] R ON O.[Dim_Regiontable City_id] = R.City_id
GROUP BY 
    R.Region
ORDER BY 
    Total_Sales DESC;

--Analyzing Total sales by product category
SELECT 
    P.Category,
    ROUND(SUM(O.Sales),2) AS Total_Sales
FROM 
    order_details O
JOIN 
    [Dim_Products table] P ON O.[Product ID] = P.[Product ID]
GROUP BY 
    P.Category
ORDER BY 
    Total_Sales DESC;

--Analyzing Total sales by customer segment
SELECT 
    C.Segment,
    ROUND(SUM(O.Sales),2) AS Total_Sales
FROM 
    order_details O 
JOIN 
    [Dim_Customer table] C ON O.[Customer ID] = C.[Customer ID]
GROUP BY 
    C.Segment
ORDER BY 
    Total_Sales DESC;

--Monthly sales trend i.e determining which month make the most sales
SELECT 
    DATENAME(MONTH, [Order Date]) AS Month,
	FORMAT([Order Date], 'MM') AS Month_In_Num,
    ROUND(SUM(Sales),2) AS Monthly_Sales
FROM 
    order_details
GROUP BY 
    DATENAME(MONTH, [Order Date]),
	FORMAT([Order Date], 'MM')
ORDER BY 
    Monthly_Sales DESC;

--Analyzing Yearly Sales Trend
SELECT 
    YEAR([Order Date]) AS Year,
    ROUND(SUM(Sales),2) AS Yearly_Sales
FROM 
    order_details
GROUP BY 
    YEAR([Order Date])
ORDER BY 
    Year DESC;

--Analyzing Quarterly Sales Trend
SELECT 
    YEAR([Order Date]) AS Year,
    'Q' + CAST(DATEPART(QUARTER, [Order Date]) AS NVARCHAR) AS Quarter,
    SUM(Sales) AS Quarterly_Sales
FROM 
    Order_details
GROUP BY 
    YEAR([Order Date]), 
    DATEPART(QUARTER, [Order Date])
ORDER BY 
    Quarterly_Sales DESC;



--Profit Analysis
--Determining the product category with the highest profit
SELECT 
    P.Category,
    ROUND(SUM(O.Profit),2) AS Total_Profit
FROM 
    order_details O
JOIN 
    [Dim_Products table] P ON O.[Product ID] = P.[Product ID]
GROUP BY 
    P.Category
ORDER BY 
    Total_Profit DESC;

--Analyzing profit by region and customer segments
SELECT 
    R.Region,
    C.Segment,
    Round(SUM(O.Profit),2) AS Total_Profit
FROM 
    order_details O
JOIN 
    [Dim_Region table] R ON O.[Dim_Regiontable City_id] = R.City_id
JOIN 
    [Dim_Customer table] C ON O.[Customer ID] = C.[Customer ID]
GROUP BY 
    R.Region, C.Segment
ORDER BY 
    Total_Profit DESC;



--Customer Behavior Analysis 
--(Analyzing Average Order Value by Customer Segment)
SELECT 
    C.Segment,
    ROUND(AVG(O.Sales),2) AS Average_Order_Value
FROM 
    order_details O
JOIN 
    [Dim_Customer table] C ON O.[Customer ID] = C.[Customer ID]
GROUP BY 
    C.Segment
ORDER BY Average_Order_Value DESC;

--Analyzing customer segment with the highest Purchase frequency
SELECT 
    C.Segment AS Customer_Segment,
    COUNT(DISTINCT O.[Order ID]) AS Purchase_Frequency
FROM 
    order_details O
JOIN 
    [Dim_Customer table] C ON O.[Customer ID] = C.[Customer ID]
GROUP BY 
    C.Segment
ORDER BY 
    Purchase_Frequency DESC;

--Analyzing the total sales contributed by each customer to understand high-value customers (10 Best Performing Customer)
SELECT TOP 10
    [Customer Name],
    SUM(Sales) AS Total_Sales,
    COUNT(DISTINCT [Order ID]) AS Total_Orders
FROM 
    order_details O
JOIN [Dim_Customer table] C ON O.[Customer ID] = C.[Customer ID]
GROUP BY 
    [Customer Name]
ORDER BY 
    Total_Sales DESC;

--Analyze how often customers make repeat purchases.
SELECT 
    [Customer Name],
    COUNT(DISTINCT [Order ID]) AS Total_Orders,
    CASE 
        WHEN COUNT(DISTINCT [Order ID]) > 1 THEN 'Repeat'
        ELSE 'One-Time'
    END AS Purchase_Type
FROM 
    order_details O
JOIN [Dim_Customer table]C ON O.[Customer ID]= C.[Customer ID]
GROUP BY 
    [Customer Name]
ORDER BY Total_Orders DESC;

--Tracking retention by measuring how many customers made repeat purchases in different periods (e.g., monthly or yearly).
WITH CustomerOrders AS (
    SELECT 
        [Customer ID],
        YEAR([Order Date]) AS Order_Year,
        COUNT(DISTINCT [Order ID]) AS Orders_Per_Year
    FROM 
        order_details
    GROUP BY 
        [Customer ID], 
		YEAR([Order Date])
)
SELECT 
    Order_Year,
    COUNT(DISTINCT CASE WHEN Orders_Per_Year > 1 THEN [Customer ID] END) * 1.0 / COUNT(DISTINCT [Customer ID]) AS Retention_Rate
FROM 
    CustomerOrders
GROUP BY 
    Order_Year;

--Identify products with the highest sales volume.
SELECT TOP 10
    [Product Name],
    SUM(Sales) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity
FROM 
    order_details O
JOIN [Dim_Products table]P ON O.[Product ID] = P.[Product ID]
GROUP BY 
    [Product Name]
ORDER BY 
    Total_Sales DESC;

--Determining how fast different products sell to optimize inventory levels.
SELECT TOP 10
    [Product ID],
    SUM(Quantity) AS Total_Quantity_Sold,
    COUNT(DISTINCT [Order ID]) AS Total_Orders,
    SUM(Quantity) * 1.0 / COUNT(DISTINCT [Order ID]) AS Average_Sold_Per_Order
FROM 
    order_details
GROUP BY 
    [Product ID]
ORDER BY 
    Average_Sold_Per_Order DESC;

--Analyze which products are frequently purchased together to create cross-sell or bundle opportunities.
SELECT TOP 10
    a.[Product ID] AS Product_A,
    b.[Product ID] AS Product_B,
    COUNT(*) AS Times_Bought_Together
FROM 
    order_details a
    JOIN order_details b ON a.[Order ID] = b.[Order ID] 
	AND a.[Product ID] < b.[Product ID]
GROUP BY 
    a.[Product ID], b.[Product ID]
ORDER BY 
    Times_Bought_Together DESC;

--Analyzing the impact of discounts on sales volume to see if discounts lead to increased revenue.
SELECT 
    Discount,
    ROUND(SUM(Sales),2) AS Total_Sales,
    COUNT([Order ID]) AS Total_Orders
FROM 
    order_details
GROUP BY 
    Discount
ORDER BY 
    Discount DESC;

