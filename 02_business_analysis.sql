/* TOP 10 SELLING PRODUCTS BY VOLUME IN EACH COUNTRY */
WITH ProductSalesByCountry AS (
    -- Calculating total sales for every product in every country
    SELECT 
        st.Country,
        p.Product_Name,
        SUM(s.Quantity) AS Total_Units_Sold,
        
        -- Assigning ranks to products within each country based on volume
        ROW_NUMBER() OVER(PARTITION BY st.Country ORDER BY SUM(s.Quantity) DESC) AS Sales_Rank
    FROM Sales s
    JOIN Stores st ON s.StoreKey = st.StoreKey
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY st.Country, p.Product_Name
)
-- Filtering the final output to only show ranks 1 through 5
SELECT 
    Country,
    Sales_Rank,
    Product_Name,
    Total_Units_Sold
FROM ProductSalesByCountry
WHERE Sales_Rank <= 5
ORDER BY Country ASC, Sales_Rank ASC;



/* YEAR-OVER-YEAR (YoY) GROWTH */
WITH YearlySales AS (
    SELECT 
        YEAR(s.Order_Date) AS Sales_Year,
        SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
    FROM Sales s
    JOIN Products p ON s.ProductKey = p.ProductKey
    GROUP BY YEAR(s.Order_Date)
)
SELECT 
    Sales_Year,
    Total_Revenue,
    LAG(Total_Revenue) OVER (ORDER BY Sales_Year) AS Prev_Year_Revenue,
    ((Total_Revenue - LAG(Total_Revenue) OVER (ORDER BY Sales_Year)) / 
      LAG(Total_Revenue) OVER (ORDER BY Sales_Year)) * 100 AS YoY_Growth_Pct
FROM YearlySales;



/* CURRENCY FLUNCTUATIONS AND EXCHANGE RATE IMPACT */
SELECT 
    s.Order_Date,
    s.Currency_Code,
    SUM(s.Quantity * p.Unit_Price_USD) AS Base_USD_Revenue,
    SUM((s.Quantity * p.Unit_Price_USD) * e.Exchange) AS Local_Currency_Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
LEFT JOIN Exchange_Rates e ON s.Order_Date = e.Date AND s.Currency_Code = e.Currency
GROUP BY s.Order_Date, s.Currency_Code;




/* SALES SEASONALITY AND PEAK DAYS */
SELECT 
    DAYNAME(s.Order_Date) AS Day_Of_Week,
    MONTHNAME(s.Order_Date) AS Sales_Month,
    COUNT(DISTINCT s.Order_Number) AS Total_Orders,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM Sales s
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY Day_Of_Week, Sales_Month
ORDER BY Total_Revenue DESC;




/* SPENDING HABITS OF AGE GROUPS AND GENERATIONS */
SELECT 
    CASE 
        WHEN YEAR(c.Birthday) BETWEEN 1946 AND 1964 THEN 'Boomers'
        WHEN YEAR(c.Birthday) BETWEEN 1965 AND 1980 THEN 'Gen X'
        WHEN YEAR(c.Birthday) BETWEEN 1981 AND 1996 THEN 'Millennials'
        WHEN YEAR(c.Birthday) >= 1997 THEN 'Gen Z'
        ELSE 'Unknown'
    END AS Generation,
    p.Category,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
GROUP BY Generation, p.Category
ORDER BY Generation, Total_Revenue DESC;





/* PURCHASES BY GENDER */
SELECT 
    c.Gender,
    p.Category,
    SUM(s.Quantity) AS Total_Items_Sold,
    SUM(s.Quantity * p.Unit_Price_USD) AS Total_Revenue
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE c.Gender IN ('Male', 'Female') 
GROUP BY c.Gender, p.Category
ORDER BY c.Gender, Total_Revenue DESC;



/* DELIVERY TIME ANALYSIS */
SELECT 
    st.Country AS Store_Country,
    AVG(DATEDIFF(s.Delivery_Date, s.Order_Date)) AS Avg_Delivery_Days,
    MAX(DATEDIFF(s.Delivery_Date, s.Order_Date)) AS Max_Delivery_Days
FROM Sales s
JOIN Stores st ON s.StoreKey = st.StoreKey
WHERE s.Delivery_Date IS NOT NULL
GROUP BY st.Country
ORDER BY Avg_Delivery_Days DESC;




/* UNFUFILLED AND PENDING ORDERS TRACKER */
SELECT 
    s.Order_Number,
    s.Order_Date,
    c.Name AS Customer_Name,
    st.State AS Store_State,
    SUM(s.Quantity * p.Unit_Price_USD) AS Pending_Revenue
FROM Sales s
JOIN Customers c ON s.CustomerKey = c.CustomerKey
JOIN Stores st ON s.StoreKey = st.StoreKey
JOIN Products p ON s.ProductKey = p.ProductKey
WHERE s.Delivery_Date IS NULL
GROUP BY s.Order_Number, s.Order_Date, c.Name, st.State
ORDER BY s.Order_Date ASC;





