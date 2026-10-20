# Supply Chain Inventory & Stockout Risk Analysis

## Project Overview

This project analyzes supply chain inventory data using MySQL to examine sales, inventory levels, reorder points, supplier lead times, product profitability, and demand forecasts.

## Business Objectives

- Identify records where inventory falls below the reorder point.
- Compare low-inventory rates across warehouses and regions.
- Identify products with frequent low-inventory records.
- Compare actual sales with demand forecasts.
- Calculate product profitability.
- Validate data quality and identify limitations in the dataset.

## Tools Used

- MySQL
- MySQL Workbench
- SQL

## Dataset

- Total records: 91,250
- Total columns: 15
- Data includes dates, product IDs, warehouse IDs, supplier IDs, regions, sales, inventory levels, costs, prices, reorder points, promotions, stockout flags, and demand forecasts.

## Key Findings

- 4,787 records had inventory levels below their reorder points (5.25% of all records).
- Warehouse WH5 had the highest reported low-inventory rate at 5.30%.
- The North region had the highest reported low-inventory rate at 5.46%.
- SKU 14 had 105 records below its reorder point.
- SKU 38 had the highest total calculated profit, at 368,630.97.
- In the West region, actual sales were approximately 0.23% below the demand forecast, based on the analysis result.

## Data Limitation

The Stockout_Flag column was 0 for all 91,250 records. Therefore, the dataset does not contain any recorded stockout events, and actual stockout occurrence cannot be evaluated from this flag.

## SQL Skills Demonstrated

Data validation, filtering, aggregation, GROUP BY, HAVING, joins, subqueries, Common Table Expressions (CTEs), window functions, ranking, date analysis, and calculated business metrics.

## Recommendations

- Review inventory records below reorder points, especially in the North region and WH5.
- Investigate SKU 14's repeated low-inventory records.
- Review SKU 38's profitability drivers before making stocking decisions.
- Compare actual demand with forecasts to improve inventory planning.
- Use a dataset with valid stockout events for future stockout-risk analysis.

## Project Status

SQL analysis completed through the initial business analysis stage. Findings should be validated before business decisions are made.