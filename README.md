# World Layoffs Data Cleaning (MySQL)

## Project Overview
This project focuses on data cleaning and data quality enhancement using **MySQL**. Raw datasets in real-world scenarios are often noisy, inconsistent, and incomplete. This project demonstrates an end-to-end data preparation pipeline that cleans, standardizes, and formats global tech layoff records to make them analytics-ready.

---

## Key SQL Techniques Applied
* **Window Functions & CTEs:** Used `ROW_NUMBER()` partitioned across all attributes to identify and eliminate duplicate entries.
* **String Standardization:** Applied `TRIM()` and `LIKE` pattern matching to fix trailing whitespace and unify inconsistent category names (e.g., standardizing crypto variations).
* **Data Type Conversion:** Transformed raw text dates into SQL-compliant `DATE` structures using `STR_TO_DATE()`.
* **Missing Value Imputation:** Utilized self-joins (`JOIN` on same table) to infer missing industry labels based on non-null records from identical companies.
* **Data Sanitization:** Handled empty strings, converted invalid strings to `NULL`, and pruned unusable records where core metric columns were absent.

---

## Repository Content
* `project.sql`: The complete step-by-step MySQL script covering data cleaning operations.
* `layoffs.csv`: The raw input dataset containing uncleaned layoff data across companies worldwide.

---

## How to Run
1. Import `layoffs.csv` into your MySQL Database using the Table Data Import Wizard.
2. Open and run `project.sql` sequentially in MySQL Workbench or your preferred SQL tool.
