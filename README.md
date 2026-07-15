# Global Retail Data Analysis & Schema Architecture

## Project Overview
This project transforms raw CSV sales data into a fully functional relational database using **MySQL**. The objective is to architect a robust data model and perform advanced exploratory data analysis (EDA) to extract actionable business insights regarding global revenue, demographic spending habits, and operational efficiency.

## The Data Model (Star Schema)
The database was engineered using a classic Star Schema optimized for analytical querying. 
* **Fact Table:** `Sales` (Contains transactional data including quantities and currency codes).
* **Dimension Tables:** `Customers`, `Stores`, `Products`, and `Exchange_Rates`.
* *Note on Data Pipeline:* The data required on-the-fly transformations during import, specifically utilizing composite keys for accurate historical currency conversions and casting localized date formats into standard `YYYY-MM-DD`.

## Repository Structure
* **`01_database_setup.sql`**: The DDL (Data Definition Language) scripts used to build the database, define primary/foreign key constraints, and establish table relationships.
* **`03_business_analysis.sql`**: The analytical queries used to answer specific business questions and extract key performance indicators (KPIs).

## Key Business Insights & Analytics

### Revenue & Product Performance
* **Year-Over-Year (YoY) Growth:** Calculated historical growth rates using Window Functions (`LAG()`) to compare annual revenue performance.
* **Top-Selling Products by Region:** Identified the Top 5 highest-volume products within *each specific country* by partitioning the data using `ROW_NUMBER()`.

### Customer Demographics
* **Generational Spending Habits:** Categorized customers into generations (Gen Z, Millennials, Gen X, Boomers) using their birthdays to map revenue against specific product categories.
* **Gender & Category Affinities:** Analyzed the correlation between customer gender and specific retail categories to drive targeted marketing insights.

### Operational Efficiency
* **Delivery Time Analysis:** Measured average and maximum shipping times across different global store locations.
* **Pending Revenue Tracker:** Built a tracker to identify unfulfilled orders and calculate the exact amount of revenue currently tied up in pending shipments.

## Technical SQL Competencies Highlighted
* **Advanced Aggregations & Grouping**
* **Common Table Expressions (CTEs)** to stage complex data transformations
* **Window Functions** (`ROW_NUMBER`, `LAG`, `PARTITION BY`) for ranking and time-series analysis
* **Complex Multi-Table `JOIN`s** navigating a Star Schema
* **Control Flow Logic** (`CASE WHEN`) for demographic bucketing
* **Date & Time Manipulation** (`DATEDIFF`, `YEAR()`)
