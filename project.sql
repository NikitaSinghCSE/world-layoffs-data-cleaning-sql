-- PROJECT: World Layoffs Data Cleaning (MySQL)
-- OBJECTIVE: Remove duplicates, standardize text, handle nulls, and clean types

-- 1. Create a staging table to preserve the raw dataset
SELECT * 
FROM layoffs;

CREATE TABLE layoff_cleaning LIKE layoffs;

INSERT INTO layoff_cleaning 
SELECT * 
FROM layoffs;

-- 2. REMOVING DUPLICATES

-- Create a new table with a row number column to identify duplicate entries
CREATE TABLE `layoff_cleaning3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data along with row numbers partitioned across all columns
INSERT INTO layoff_cleaning3
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, 
                 percentage_laid_off, `date`, stage, country, funds_raised_millions
) AS Rowss_num
FROM layoff_cleaning;

-- Delete rows where row number is greater than 1 (duplicates)
DELETE FROM layoff_cleaning3
WHERE row_num > 1;

-- Drop the helper row_num column now that duplicates are removed
ALTER TABLE layoff_cleaning3
DROP COLUMN row_num;

-- 3. STANDARDIZING DATA

-- Remove unwanted trailing and leading spaces from company names
UPDATE layoff_cleaning3
SET company = TRIM(company);

-- Unify inconsistent industry naming variations (e.g., Crypto, Crypto Currency)
UPDATE layoff_cleaning3 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 4. FIXING DATE FORMATS & TYPES

-- Convert string dates into standard SQL date format
UPDATE layoff_cleaning3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Alter the column data type to DATE
ALTER TABLE layoff_cleaning3
MODIFY COLUMN `date` DATE;

-- 5. HANDLING NULL AND BLANK VALUES

-- Convert empty string values to actual NULLs
UPDATE layoff_cleaning3
SET industry = NULL
WHERE industry = '';

-- Populate missing industries by self-joining where the company name matches a known industry
UPDATE layoff_cleaning3 t1
JOIN layoff_cleaning3 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Remove rows where key metrics (both layoff counts and percentages) are missing
DELETE FROM layoff_cleaning3
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Final view of the clean table
SELECT * 
FROM layoff_cleaning3;