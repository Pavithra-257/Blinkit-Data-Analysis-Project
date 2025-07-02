-- BLINKIT DATA ANALYSIS 

SELECT * FROM blinkit_data;
-- CLEANING INVALID VALUES:
-- Objective: Clean the columns (Sales, Item Visibility, Item Weight, Rating, and Outlet Establishment Year) by removing any incorrect or non-numeric data to keep the dataset accurate and ready for analysis.

-- Sales
UPDATE blinkit_data
SET `Sales` = NULL
WHERE `Sales` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- Item Visibility
UPDATE blinkit_data
SET `Item Visibility` = NULL
WHERE `Item Visibility` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- Item Weight
UPDATE blinkit_data
SET `Item Weight` = NULL
WHERE `Item Weight` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- Rating
UPDATE blinkit_data
SET `Rating` = NULL
WHERE `Rating` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$';

-- Outlet Establishment Year
UPDATE blinkit_data
SET `Outlet Establishment Year` = NULL
WHERE `Outlet Establishment Year` NOT REGEXP '^[0-9]+$';

-- VERIFY REMAINING INVALID DATA:
-- Objective: Confirm all invalid records have been set to NULL by querying the remaining uncleaned values.

SELECT * FROM blinkit_data
WHERE
  `Sales` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
  OR `Item Visibility` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
  OR `Item Weight` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
  OR `Rating` NOT REGEXP '^[0-9]+(\\.[0-9]+)?$'
  OR `Outlet Establishment Year` NOT REGEXP '^[0-9]+$';
  
-- MODIFY COLUMN DATA TYPES:
-- Objective: Convert data types to appropriate numeric formats for accurate analysis and future validation.

ALTER TABLE blinkit_data
MODIFY COLUMN `Sales` DOUBLE,
MODIFY COLUMN `Item Visibility` DOUBLE,
MODIFY COLUMN `Item Weight` DOUBLE,
MODIFY COLUMN `Rating` DOUBLE,
MODIFY COLUMN `Outlet Establishment Year` INT;

-- VIEW TABLE:
-- Objective: To verify the structure and datatype of each column in the cleaned dataset.

DESCRIBE blinkit_data;

-- COUNT RECORDS IN CLEANED TABLE:
-- Objective: Verify the total number of records after cleaning and transformations.

SELECT COUNT(*) FROM blinkit_data;

-- STANDARDIZE FAT CONTENT VALUES:
-- Objective: Standardize inconsistent fat content labels to improve grouping and filtering accuracy.

UPDATE blinkit_data
SET `Item Fat Content` =
CASE
WHEN `Item Fat Content` IN ('LF', 'low fat') THEN 'Low Fat'
WHEN `Item Fat Content` IN ('reg') THEN 'Regular'
ELSE `Item Fat Content`
END;

-- VERIFY FAT CONTENT DISTRIBUTION:
-- Objective: Check the fat content values after fixing them to make sure they are correct and properly grouped.

SELECT `Item Fat Content`, COUNT(*) 
FROM blinkit_data
GROUP BY `Item Fat Content`;

-- KPI's
-- 1.TOTAL SALES (in Millions):
-- Objective: To find the total sales amount and show it in millions for better understanding.

SELECT 
  CONCAT(CAST(SUM(Sales) / 1000000 AS DECIMAL(10,2)), ' Million') AS Total_Sales
FROM blinkit_data;

-- 2. AVERAGE SALES:
-- Objective: To calculate the average sales value of all items.

SELECT CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales
FROM blinkit_data;

-- 3. TOTAL NUMBER OF ITEMS:
-- Objective: To count the total number of items available in the dataset.

SELECT COUNT(*) AS Total_no_items
FROM blinkit_data;

-- 4. AVERAGE RATING:
-- Objective: To find the average rating given to items in the data.

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data;

-- 5.TOTAL SALES BY FAT CONTENT:
-- Objective: Analyze how fat content affects total sales.

SELECT `Item Fat Content`,
		CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS Total_no_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY `Item Fat Content`
ORDER BY Total_Sales DESC;

-- 6.TOTAL SALES BY ITEM TYPE:
-- Objective: Identify the performance of different item types.

SELECT `Item type`,
		CAST(SUM(Sales) / 1000 AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS Total_no_items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY `Item type`
ORDER BY Total_Sales DESC
LIMIT 5;

-- 7.FAT CONTENT BY OUTLET FOR TOTAL SALES:
-- Objective: Compare sales across outlets segmented by fat content.

SELECT 
  `Outlet Location Type`,
  CAST(SUM(CASE WHEN `Item Fat Content` = 'Low Fat' THEN `Sales` ELSE 0 END) AS DECIMAL(10,2)) AS `Low Fat`,
  CAST(SUM(CASE WHEN `Item Fat Content` = 'Regular' THEN `Sales` ELSE 0 END) AS DECIMAL(10,2)) AS `Regular`
FROM blinkit_data
GROUP BY `Outlet Location Type`
ORDER BY `Outlet Location Type`;

-- 8.TOTAL SALES BY OUTLET ESTABLISHMENT YEAR:
-- Objective: Evaluate how the outlet’s establishment year affects sales.

SELECT `Outlet Establishment Year`,
			CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
			CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
			COUNT(*) AS Total_no_items,
			CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY `Outlet Establishment Year`
ORDER BY Total_Sales DESC;

-- 9.PERCENTAGE OF SALES BY OUTLET SIZE:
-- Objective: Analyze correlation between outlet size and sales.
    
SELECT
`Outlet Size`,
CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
CAST((SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage 
FROM blinkit_data 
GROUP BY `Outlet Size`
ORDER BY Total_Sales DESC;

-- 10.SALES BY OUTLET LOCATION:
-- Objective: Assess geographic distribution of sales.

SELECT
  `Outlet Location Type`,
  CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY `Outlet Location Type`
ORDER BY Total_Sales DESC;

-- 11. ALL KPIs BY OUTLET TYPE:
-- Objective: Get a full KPI breakdown by outlet type.

SELECT `Outlet Type`,
			CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
			CAST(AVG(Sales) AS DECIMAL(10,1)) AS Avg_Sales,
			COUNT(*) AS Total_no_items,
			CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY `Outlet Type`
ORDER BY Total_Sales DESC;









        








  
  
