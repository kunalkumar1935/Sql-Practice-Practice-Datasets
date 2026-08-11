-- EXPLORATORY DATA ANALYSIS

SELECT * 
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


WITH ROLLING_TOTAL AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH` ,total_off, SUM(total_off) OVER(ORDER BY `MONTH`) rolling_total
FROM ROLLING_TOTAL;

SELECT company,YEAR(`date`), SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL 
GROUP BY company,YEAR(`date`) 
ORDER BY 3 DESC  ;

WITH company_year (company,years, total_laid_off) AS
(
SELECT company,YEAR(`date`), SUM(total_laid_off) total_off
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL 
GROUP BY company,YEAR(`date`) 
),
company_year_rank AS(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) rankings 
FROM company_year
ORDER BY rankings
)
SELECT *
FROM company_year_rank
WHERE rankings<=5;
