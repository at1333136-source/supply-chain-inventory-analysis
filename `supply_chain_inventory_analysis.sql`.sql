CREATE DATABASE supply_chain_analysis;
use supply_chain_analysis;

USE supply_chain_analysis;


-- Supply Chain Inventory & Stockout Risk Analysis
-- Section 1: Data Verification and Cleaning

-- 1. Check total number of records
SELECT COUNT(*) AS total_records
FROM supply_chain_inventory;


-- 2. Check table structure and data types
DESCRIBE supply_chain_inventory;


-- 3. Check for duplicate records across all columns
SELECT Date, SKU_ID, Warehouse_ID, Supplier_ID, Region,
       Units_Sold, Inventory_Level, Supplier_Lead_Time_Days,
       Reorder_Point, Order_Quantity, Unit_Cost, Unit_Price,
       Promotion_Flag, Stockout_Flag, Demand_Forecast,
       COUNT(*) AS duplicate_count
FROM supply_chain_inventory
GROUP BY Date, SKU_ID, Warehouse_ID, Supplier_ID, Region,
         Units_Sold, Inventory_Level, Supplier_Lead_Time_Days,
         Reorder_Point, Order_Quantity, Unit_Cost, Unit_Price,
         Promotion_Flag, Stockout_Flag, Demand_Forecast
HAVING COUNT(*) > 1;


-- 4. Check missing values in all columns
SELECT
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN SKU_ID IS NULL THEN 1 ELSE 0 END) AS missing_sku,
    SUM(CASE WHEN Warehouse_ID IS NULL THEN 1 ELSE 0 END) AS missing_warehouse,
    SUM(CASE WHEN Supplier_ID IS NULL THEN 1 ELSE 0 END) AS missing_supplier,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS missing_region,
    SUM(CASE WHEN Units_Sold IS NULL THEN 1 ELSE 0 END) AS missing_units_sold,
    SUM(CASE WHEN Inventory_Level IS NULL THEN 1 ELSE 0 END) AS missing_inventory,
    SUM(CASE WHEN Supplier_Lead_Time_Days IS NULL THEN 1 ELSE 0 END) AS missing_lead_time,
    SUM(CASE WHEN Reorder_Point IS NULL THEN 1 ELSE 0 END) AS missing_reorder_point,
    SUM(CASE WHEN Order_Quantity IS NULL THEN 1 ELSE 0 END) AS missing_order_quantity,
    SUM(CASE WHEN Unit_Cost IS NULL THEN 1 ELSE 0 END) AS missing_unit_cost,
    SUM(CASE WHEN Unit_Price IS NULL THEN 1 ELSE 0 END) AS missing_unit_price,
    SUM(CASE WHEN Promotion_Flag IS NULL THEN 1 ELSE 0 END) AS missing_promotion,
    SUM(CASE WHEN Stockout_Flag IS NULL THEN 1 ELSE 0 END) AS missing_stockout,
    SUM(CASE WHEN Demand_Forecast IS NULL THEN 1 ELSE 0 END) AS missing_demand_forecast
FROM supply_chain_inventory;


-- 5. Check for negative units sold, inventory, prices,
--    supplier lead times, reorder points, and order quantities
SELECT *
FROM supply_chain_inventory
WHERE Units_Sold < 0
   OR Inventory_Level < 0
   OR Unit_Price < 0
   OR Supplier_Lead_Time_Days < 0
   OR Reorder_Point < 0
   OR Order_Quantity < 0;


-- 6. Validate promotion and stockout flag values
--    Expected values are 0 and 1
SELECT *
FROM supply_chain_inventory
WHERE Promotion_Flag NOT IN (0, 1)
   OR Stockout_Flag NOT IN (0, 1);


-- Section 2: Exploratory Data Analysis (EDA)

-- 7. Display unique regions
SELECT DISTINCT Region
FROM supply_chain_inventory
ORDER BY Region DESC;


-- 8. Count records for each region
SELECT Region, COUNT(*) AS total_records
FROM supply_chain_inventory
GROUP BY Region;


-- 9. Calculate total units sold by region
--    Sort from highest to lowest
SELECT Region, SUM(Units_Sold) AS total_sold_units
FROM supply_chain_inventory
GROUP BY Region
ORDER BY total_sold_units DESC;


-- 10. Calculate average inventory for each warehouse
--     Sort from highest to lowest
SELECT Warehouse_ID, AVG(Inventory_Level) AS average_inventory
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY average_inventory DESC;


-- 11. Count stockout records for each region
SELECT
    Region,
    SUM(CASE WHEN Stockout_Flag = 1 THEN 1 ELSE 0 END) AS total_stockouts
FROM supply_chain_inventory
GROUP BY Region
ORDER BY total_stockouts DESC;

-- 12. Calculate stockout rate (%) for each region
SELECT
    Region,
    ROUND(AVG(Stockout_Flag) * 100, 2) AS stockout_rate_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY stockout_rate_percentage DESC;

-- 13. Count records for each promotion flag value
SELECT Promotion_Flag, COUNT(*) AS total_records
FROM supply_chain_inventory
GROUP BY Promotion_Flag;

-- 14. Calculate promotion rate (%) for each region
SELECT
    Region,
    ROUND(AVG(Promotion_Flag) * 100, 2) AS promotion_rate_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY promotion_rate_percentage DESC;

-- 15. Calculate total revenue for each region
SELECT
    Region,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY Region
ORDER BY total_revenue DESC;

-- 16. Calculate total profit for each region
SELECT
    Region,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY Region
ORDER BY total_profit DESC;

-- 17. Identify the Top 10 Products by Total Units Sold
select SKU_ID , sum(Units_Sold) as Total_unit_sold
from supply_chain_inventory
group by SKU_ID
order by Total_unit_sold desc
limit 10; 

-- 18. Identify the Top 10 Products with lowest Total Units Sold
select SKU_ID , sum(Units_Sold) as Total_unit_sold
from supply_chain_inventory
group by SKU_ID
order by Total_unit_sold asc
limit 10; 

-- 19. Identify the Top 10 Products with the Highest Average Selling Price
select SKU_ID , avg(Unit_Price) as  average_selling_price
from supply_chain_inventory
group by SKU_ID
order by Average_selling_price desc
limit 10;

-- 20. Identify the Top 10 Products with the Highest Total Profit
SELECT
    SKU_ID,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY total_profit DESC
LIMIT 10;

-- 21. Calculate Total Units Sold by Month
SELECT
    MONTH(Date) AS month_number,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
GROUP BY MONTH(Date)
ORDER BY total_units_sold DESC;

-- 22. Calculate Total Revenue by Month
SELECT
    MONTH(Date) AS month_number,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY MONTH(Date)
ORDER BY total_revenue DESC;

-- 23. Calculate Total Profit by Month
SELECT
    MONTH(Date) AS month_number,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY MONTH(Date)
ORDER BY total_profit DESC;

-- 24. Calculate Total Units Sold by Region and Warehouse
SELECT
    Region,
    Warehouse_ID,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
GROUP BY Region, Warehouse_ID
ORDER BY total_units_sold DESC;


-- 25. Identify Warehouses with Inventory Below the Reorder Point
SELECT
    Warehouse_ID,
    COUNT(*) AS low_inventory_records
FROM supply_chain_inventory
WHERE Inventory_Level < Reorder_Point
GROUP BY Warehouse_ID
ORDER BY low_inventory_records DESC;


-- 26. Calculate Average Supplier Lead Time by Supplier
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time_days
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY average_lead_time_days DESC;

-- 27. Identify Products Below Their Reorder Point
SELECT
    SKU_ID,
    COUNT(*) AS low_inventory_records
FROM supply_chain_inventory
WHERE Inventory_Level < Reorder_Point
GROUP BY SKU_ID
ORDER BY low_inventory_records DESC
LIMIT 10;


-- 28. Calculate Total Units Sold During Promotions
SELECT
    Promotion_Flag,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
GROUP BY Promotion_Flag
ORDER BY total_units_sold DESC;


-- 29. Compare Average Demand Forecast with Actual Units Sold by Region
SELECT
    Region,
    ROUND(AVG(Demand_Forecast), 2) AS average_forecast,
    ROUND(AVG(Units_Sold), 2) AS average_actual_units_sold
FROM supply_chain_inventory
GROUP BY Region
ORDER BY average_forecast DESC;

-- 30. Calculate Profit Margin Percentage by Region
SELECT
    Region,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold)
        / SUM(Unit_Price * Units_Sold) * 100,
        2
    ) AS profit_margin_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY profit_margin_percentage DESC;


-- 31. Identify the Top 10 Suppliers with the Highest Total Order Quantity
SELECT
    Supplier_ID,
    SUM(Order_Quantity) AS total_order_quantity
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY total_order_quantity DESC
LIMIT 10;


-- 32. Compare Average Inventory Levels Across Regions
SELECT
    Region,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory_level
FROM supply_chain_inventory
GROUP BY Region
ORDER BY average_inventory_level DESC;


-- 33. Identify Products with the Highest Average Demand Forecast
SELECT
    SKU_ID,
    ROUND(AVG(Demand_Forecast), 2) AS average_demand_forecast
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_demand_forecast DESC
LIMIT 10;


-- 34. Calculate Total Revenue by Warehouse
SELECT
    Warehouse_ID,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY total_revenue DESC;


-- 35. Compare Total Units Sold During Promotion and Non-Promotion Periods
SELECT
    CASE
        WHEN Promotion_Flag = 1 THEN 'Promotion'
        ELSE 'No Promotion'
    END AS promotion_status,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(Units_Sold), 2) AS average_units_sold
FROM supply_chain_inventory
GROUP BY Promotion_Flag;

-- 36. Calculate Total Profit by Warehouse
SELECT
    Warehouse_ID,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY total_profit DESC;


-- 37. Identify Suppliers with the Longest Average Lead Time
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time_days
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY average_lead_time_days DESC
LIMIT 10;


-- 38. Calculate Inventory Turnover by Product
SELECT
    SKU_ID,
    ROUND(
        SUM(Units_Sold) / NULLIF(AVG(Inventory_Level), 0),
        2
    ) AS inventory_turnover_ratio
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY inventory_turnover_ratio DESC
LIMIT 10;


-- 39. Calculate Monthly Revenue by Year and Month
SELECT
    YEAR(Date) AS sales_year,
    MONTH(Date) AS sales_month,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY sales_year, sales_month;


-- 40. Identify the Top 10 Products with the Largest Forecast Error
SELECT
    SKU_ID,
    ROUND(AVG(ABS(Units_Sold - Demand_Forecast)), 2) AS average_forecast_error
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_forecast_error DESC
LIMIT 10;


-- 41. Classify Products by Inventory Status
SELECT
    SKU_ID,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory,
    ROUND(AVG(Reorder_Point), 2) AS average_reorder_point,
    CASE
        WHEN AVG(Inventory_Level) < AVG(Reorder_Point)
            THEN 'Below Reorder Point'
        ELSE 'Sufficient Inventory'
    END AS inventory_status
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_inventory ASC;

-- 42. Calculate Total Units Sold by Supplier
SELECT
    Supplier_ID,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY total_units_sold DESC;


-- 43. Calculate Average Unit Cost by Product
SELECT
    SKU_ID,
    ROUND(AVG(Unit_Cost), 2) AS average_unit_cost
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_unit_cost DESC
LIMIT 10;


-- 44. Identify Products with the Highest Average Reorder Point
SELECT
    SKU_ID,
    ROUND(AVG(Reorder_Point), 2) AS average_reorder_point
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_reorder_point DESC
LIMIT 10;


-- 45. Calculate Total Order Quantity by Warehouse
SELECT
    Warehouse_ID,
    SUM(Order_Quantity) AS total_order_quantity
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY total_order_quantity DESC;


-- 46. Compare Average Selling Price and Unit Cost by Region
SELECT
    Region,
    ROUND(AVG(Unit_Price), 2) AS average_selling_price,
    ROUND(AVG(Unit_Cost), 2) AS average_unit_cost
FROM supply_chain_inventory
GROUP BY Region
ORDER BY average_selling_price DESC;


-- 47. Calculate Monthly Units Sold by Year
SELECT
    YEAR(Date) AS sales_year,
    MONTH(Date) AS sales_month,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY sales_year, sales_month;


-- 48. Classify Daily Records by Sales Performance
SELECT
    Date,
    SUM(Units_Sold) AS total_units_sold,
    CASE
        WHEN SUM(Units_Sold) >= 1000 THEN 'High Sales'
        WHEN SUM(Units_Sold) >= 500 THEN 'Medium Sales'
        ELSE 'Low Sales'
    END AS sales_category
FROM supply_chain_inventory
GROUP BY Date
ORDER BY total_units_sold DESC;


-- 49. Identify Products with the Highest Average Profit per Unit
SELECT
    SKU_ID,
    ROUND(AVG(Unit_Price - Unit_Cost), 2) AS average_profit_per_unit
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_profit_per_unit DESC
LIMIT 10;


-- 50. Calculate Total Revenue by Supplier
SELECT
    Supplier_ID,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY total_revenue DESC;

-- 51. Identify Top 10 Products by Units Sold During Promotions
SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold
FROM supply_chain_inventory
WHERE Promotion_Flag = 1
GROUP BY SKU_ID
ORDER BY total_units_sold DESC
LIMIT 10;


-- 52. Calculate Stockout Rate by Warehouse
SELECT
    Warehouse_ID,
    COUNT(*) AS total_records,
    SUM(Stockout_Flag) AS total_stockouts,
    ROUND(AVG(Stockout_Flag) * 100, 2) AS stockout_rate_percentage
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY stockout_rate_percentage DESC;


-- 53. Identify Products with Inventory Below Reorder Point
SELECT
    SKU_ID,
    COUNT(*) AS low_inventory_records
FROM supply_chain_inventory
WHERE Inventory_Level < Reorder_Point
GROUP BY SKU_ID
ORDER BY low_inventory_records DESC
LIMIT 10;


-- 54. Calculate Total Revenue and Profit by Product
SELECT
    SKU_ID,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY total_profit DESC
LIMIT 10;


-- 55. Compare Actual Sales with Demand Forecast by Region
SELECT
    Region,
    SUM(Units_Sold) AS actual_units_sold,
    SUM(Demand_Forecast) AS forecast_units,
    SUM(Units_Sold) - SUM(Demand_Forecast) AS sales_forecast_difference
FROM supply_chain_inventory
GROUP BY Region
ORDER BY sales_forecast_difference DESC;


-- 56. Calculate Average Supplier Lead Time by Region
SELECT
    Region,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time_days
FROM supply_chain_inventory
GROUP BY Region
ORDER BY average_lead_time_days DESC;


-- 57. Identify the Top 10 Products by Average Daily Sales
SELECT
    SKU_ID,
    ROUND(AVG(Units_Sold), 2) AS average_units_sold
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY average_units_sold DESC
LIMIT 10;


-- 58. Calculate Monthly Profit by Year and Month
SELECT
    YEAR(Date) AS sales_year,
    MONTH(Date) AS sales_month,
    ROUND(SUM((Unit_Price - Unit_Cost) * Units_Sold), 2) AS total_profit
FROM supply_chain_inventory
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY sales_year, sales_month;


-- 59. Classify Inventory Risk by Warehouse
SELECT
    Warehouse_ID,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN Inventory_Level < Reorder_Point THEN 1
            ELSE 0
        END
    ) AS low_inventory_records,
    ROUND(
        SUM(
            CASE
                WHEN Inventory_Level < Reorder_Point THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS low_inventory_percentage
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY low_inventory_percentage DESC;


-- 60. Calculate Profit Margin Percentage by Product
SELECT
    SKU_ID,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold)
        / NULLIF(SUM(Unit_Price * Units_Sold), 0) * 100,
        2
    ) AS profit_margin_percentage
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY profit_margin_percentage DESC
LIMIT 10;

-- 61. Rank Products by Total Units Sold
SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold,
    RANK() OVER (ORDER BY SUM(Units_Sold) DESC) AS sales_rank
FROM supply_chain_inventory
GROUP BY SKU_ID;


-- 62. Rank Warehouses by Total Revenue
SELECT
    Warehouse_ID,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(Units_Sold * Unit_Price) DESC
    ) AS revenue_rank
FROM supply_chain_inventory
GROUP BY Warehouse_ID;


-- 63. Calculate Each Region's Percentage Contribution to Revenue
WITH region_revenue AS (
    SELECT
        Region,
        SUM(Units_Sold * Unit_Price) AS total_revenue
    FROM supply_chain_inventory
    GROUP BY Region
)
SELECT
    Region,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_percentage
FROM region_revenue
ORDER BY revenue_contribution_percentage DESC;


-- 64. Identify Products Selling Below Their Average Sales
WITH product_sales AS (
    SELECT
        SKU_ID,
        AVG(Units_Sold) AS average_units_sold
    FROM supply_chain_inventory
    GROUP BY SKU_ID
)
SELECT
    SKU_ID,
    ROUND(average_units_sold, 2) AS average_units_sold
FROM product_sales
WHERE average_units_sold < (
    SELECT AVG(Units_Sold)
    FROM supply_chain_inventory
)
ORDER BY average_units_sold ASC
LIMIT 10;


-- 65. Calculate Running Monthly Revenue
WITH monthly_revenue AS (
    SELECT
        YEAR(Date) AS sales_year,
        MONTH(Date) AS sales_month,
        SUM(Units_Sold * Unit_Price) AS total_revenue
    FROM supply_chain_inventory
    GROUP BY YEAR(Date), MONTH(Date)
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY sales_year, sales_month
        ),
        2
    ) AS running_total_revenue
FROM monthly_revenue
ORDER BY sales_year, sales_month;


-- 66. Compare Each Product's Sales with the Overall Average
SELECT
    SKU_ID,
    SUM(Units_Sold) AS total_units_sold,
    ROUND(AVG(SUM(Units_Sold)) OVER (), 2) AS average_product_sales,
    SUM(Units_Sold) -
        AVG(SUM(Units_Sold)) OVER () AS difference_from_average
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY difference_from_average DESC;


-- 67. Calculate Month-over-Month Revenue Change
WITH monthly_revenue AS (
    SELECT
        YEAR(Date) AS sales_year,
        MONTH(Date) AS sales_month,
        SUM(Units_Sold * Unit_Price) AS total_revenue
    FROM supply_chain_inventory
    GROUP BY YEAR(Date), MONTH(Date)
),
revenue_comparison AS (
    SELECT
        sales_year,
        sales_month,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY sales_year, sales_month
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    sales_year,
    sales_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS revenue_change_percentage
FROM revenue_comparison
ORDER BY sales_year, sales_month;


-- 68. Rank Suppliers by Average Lead Time
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time,
    RANK() OVER (
        ORDER BY AVG(Supplier_Lead_Time_Days) DESC
    ) AS lead_time_rank
FROM supply_chain_inventory
GROUP BY Supplier_ID;


-- 69. Identify Products with Above-Average Forecast Error
WITH product_errors AS (
    SELECT
        SKU_ID,
        AVG(ABS(Units_Sold - Demand_Forecast)) AS average_forecast_error
    FROM supply_chain_inventory
    GROUP BY SKU_ID
)
SELECT
    SKU_ID,
    ROUND(average_forecast_error, 2) AS average_forecast_error
FROM product_errors
WHERE average_forecast_error > (
    SELECT AVG(ABS(Units_Sold - Demand_Forecast))
    FROM supply_chain_inventory
)
ORDER BY average_forecast_error DESC;


-- 70. Calculate Each Warehouse's Share of Total Profit
WITH warehouse_profit AS (
    SELECT
        Warehouse_ID,
        SUM((Unit_Price - Unit_Cost) * Units_Sold) AS total_profit
    FROM supply_chain_inventory
    GROUP BY Warehouse_ID
)
SELECT
    Warehouse_ID,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        total_profit * 100.0 / NULLIF(SUM(total_profit) OVER (), 0),
        2
    ) AS profit_contribution_percentage
FROM warehouse_profit
ORDER BY profit_contribution_percentage DESC;

-- 71. Identify Products with the Most Variable Daily Sales
SELECT
    SKU_ID,
    ROUND(STDDEV_POP(Units_Sold), 2) AS sales_std_deviation
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY sales_std_deviation DESC
LIMIT 10;


-- 72. Calculate Inventory Risk Percentage by Region
SELECT
    Region,
    COUNT(*) AS total_records,
    SUM(CASE
        WHEN Inventory_Level < Reorder_Point THEN 1
        ELSE 0
    END) AS low_inventory_records,
    ROUND(
        SUM(CASE
            WHEN Inventory_Level < Reorder_Point THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*),
        2
    ) AS inventory_risk_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY inventory_risk_percentage DESC;


-- 73. Identify Suppliers with the Highest Average Unit Cost
SELECT
    Supplier_ID,
    ROUND(AVG(Unit_Cost), 2) AS average_unit_cost
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY average_unit_cost DESC
LIMIT 10;


-- 74. Compare Actual Sales and Forecast by Product
SELECT
    SKU_ID,
    SUM(Units_Sold) AS actual_units_sold,
    SUM(Demand_Forecast) AS forecast_units,
    SUM(Units_Sold) - SUM(Demand_Forecast) AS forecast_difference
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY ABS(SUM(Units_Sold) - SUM(Demand_Forecast)) DESC
LIMIT 10;


-- 75. Calculate Quarterly Revenue
SELECT
    YEAR(Date) AS sales_year,
    QUARTER(Date) AS sales_quarter,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue
FROM supply_chain_inventory
GROUP BY YEAR(Date), QUARTER(Date)
ORDER BY sales_year, sales_quarter;


-- 76. Calculate Quarterly Profit
SELECT
    YEAR(Date) AS sales_year,
    QUARTER(Date) AS sales_quarter,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold),
        2
    ) AS total_profit
FROM supply_chain_inventory
GROUP BY YEAR(Date), QUARTER(Date)
ORDER BY sales_year, sales_quarter;


-- 77. Rank Products by Profit Margin
SELECT
    SKU_ID,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold)
        / NULLIF(SUM(Unit_Price * Units_Sold), 0) * 100,
        2
    ) AS profit_margin_percentage,
    DENSE_RANK() OVER (
        ORDER BY
            SUM((Unit_Price - Unit_Cost) * Units_Sold)
            / NULLIF(SUM(Unit_Price * Units_Sold), 0) DESC
    ) AS profit_margin_rank
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY profit_margin_rank;


-- 78. Identify Warehouses with the Highest Average Inventory
SELECT
    Warehouse_ID,
    ROUND(AVG(Inventory_Level), 2) AS average_inventory
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY average_inventory DESC;


-- 79. Calculate Promotion Rate by Product
SELECT
    SKU_ID,
    ROUND(AVG(Promotion_Flag) * 100, 2) AS promotion_rate_percentage
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY promotion_rate_percentage DESC
LIMIT 10;


-- 80. Calculate Supplier Lead Time Variability
SELECT
    Supplier_ID,
    ROUND(AVG(Supplier_Lead_Time_Days), 2) AS average_lead_time,
    ROUND(STDDEV_POP(Supplier_Lead_Time_Days), 2) AS lead_time_std_deviation
FROM supply_chain_inventory
GROUP BY Supplier_ID
ORDER BY lead_time_std_deviation DESC;

-- 81. Verify Total Records and Date Range
SELECT
    COUNT(*) AS total_records,
    MIN(Date) AS earliest_date,
    MAX(Date) AS latest_date
FROM supply_chain_inventory;


-- 82. Summarize Overall Sales, Revenue, and Profit
SELECT
    SUM(Units_Sold) AS total_units_sold,
    ROUND(SUM(Units_Sold * Unit_Price), 2) AS total_revenue,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold), 2
    ) AS total_profit
FROM supply_chain_inventory;


-- 83. Check Stockout Flag Distribution
SELECT
    Stockout_Flag,
    COUNT(*) AS total_records
FROM supply_chain_inventory
GROUP BY Stockout_Flag;

-- 84. Verify the Number of Recorded Stockouts
SELECT
    COUNT(*) AS total_stockout_records
FROM supply_chain_inventory
WHERE Stockout_Flag = 1;

-- 85. Calculate Records Below the Reorder Point
SELECT
    COUNT(*) AS total_low_inventory_records,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM supply_chain_inventory),
        2
    ) AS low_inventory_percentage
FROM supply_chain_inventory
WHERE Inventory_Level < Reorder_Point;

-- 86. Identify Warehouses with the Highest Low-Inventory Percentage
SELECT
    Warehouse_ID,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN Inventory_Level < Reorder_Point THEN 1
            ELSE 0
        END
    ) AS low_inventory_records,
    ROUND(
        SUM(
            CASE
                WHEN Inventory_Level < Reorder_Point THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS low_inventory_percentage
FROM supply_chain_inventory
GROUP BY Warehouse_ID
ORDER BY low_inventory_percentage DESC;
-- 87. Identify Regions with the Highest Low-Inventory Percentage
SELECT
    Region,
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN Inventory_Level < Reorder_Point THEN 1
            ELSE 0
        END
    ) AS low_inventory_records,
    ROUND(
        SUM(
            CASE
                WHEN Inventory_Level < Reorder_Point THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS low_inventory_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY low_inventory_percentage DESC;

-- 88. Identify the Top 10 Products with the Most Low-Inventory Records
SELECT
    SKU_ID,
    COUNT(*) AS low_inventory_records
FROM supply_chain_inventory
WHERE Inventory_Level < Reorder_Point
GROUP BY SKU_ID
ORDER BY low_inventory_records DESC
LIMIT 10;

-- 89. Compare Actual Sales with Demand Forecast by Region
SELECT
    Region,
    SUM(Units_Sold) AS actual_units_sold,
    SUM(Demand_Forecast) AS forecast_units,
    SUM(Units_Sold) - SUM(Demand_Forecast) AS forecast_difference,
    ROUND(
        (SUM(Units_Sold) - SUM(Demand_Forecast))
        * 100.0 / NULLIF(SUM(Demand_Forecast), 0),
        2
    ) AS forecast_difference_percentage
FROM supply_chain_inventory
GROUP BY Region
ORDER BY forecast_difference_percentage DESC;

-- 90. Identify the Top 10 Products by Total Profit
SELECT
    SKU_ID,
    ROUND(
        SUM((Unit_Price - Unit_Cost) * Units_Sold),
        2
    ) AS total_profit
FROM supply_chain_inventory
GROUP BY SKU_ID
ORDER BY total_profit DESC
LIMIT 10;