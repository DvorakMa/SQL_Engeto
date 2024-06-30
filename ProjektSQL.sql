CREATE TEMPORARY TABLE temp_t_Martin_Dvorak_project_SQL_primary_final AS  -- vytvoření dočasné tabulky, aby bylo možné vytvořit tabulku klasickou včetně CTE WITH
WITH czechia_price_adjusted AS 
	(
	SELECT date_from,
		YEAR(date_from) AS year,
		QUARTER(date_from) AS quarter,
		category_code,
		value
	FROM czechia_price cp 
	WHERE region_code IS NULL
	ORDER BY date_from
	)
SELECT 
	cpp.id,
	cpp.industry_branch_code,
	cpib.name AS branch_name,
	cpp.value AS salary,
	cpp.payroll_year,
	cpp.payroll_quarter,
	cpa.year,
	cpa.quarter,
	cpa.category_code,
	cpa.value AS price,
	cpc.name,
	CONCAT(cpp.industry_branch_code ,cpp.payroll_year,cpp.payroll_quarter,cpa.category_code) AS combined_ID
FROM czechia_payroll cpp
CROSS JOIN  czechia_price_adjusted cpa
LEFT JOIN czechia_price_category cpc ON 
	cpa.category_code=cpc.code 
LEFT JOIN czechia_payroll_industry_branch cpib ON
	cpib.code =cpp.industry_branch_code 
WHERE
	value_type_code = 5958                				  -- hodnota pro mzdu
	AND calculation_code =100            				  -- počítáme s fyzickou hodnotou hrubé mzdy
	AND industry_branch_code IS NOT NULL    			  -- NULL hodnoty v czechia_payroll.industry_branch_code jsou průměry, nepočitám  
	AND cpp.payroll_year =cpa.year   					  -- rok na rok 
	AND cpp.payroll_quarter=cpa.quarter					  -- kvartál na kvartál, zároven vyřadí záznamy, kde nemáme data za korespondující období
ORDER BY industry_branch_code ,
	cpp.payroll_year ,
	cpp.payroll_quarter,
	cpa.date_from,
	cpa.category_code;

CREATE TABLE t_Martin_Dvorak_project_SQL_primary_final AS   -- Vytvoření finální tabulky
SELECT * FROM temp_t_Martin_Dvorak_project_SQL_primary_final 
GROUP BY combined_ID ; 

/* Nyní máme vytvořenou tabulku, kde je každému záznamu průměrné mzdy každého odvětí přiřazen první záznam průměrné ceny za celou ČR v danném kvartálu sledovaných potravin */




