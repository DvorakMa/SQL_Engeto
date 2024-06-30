WITH czechia_price_adjusted AS 
(
SELECT date_from,
	year(date_from) AS year,
	category_code,
	value,
CASE 
	WHEN MONTH(date_from) BETWEEN 1 AND 3 THEN 1   -- roztřídění záznamů na kvartály, stejně jako v czechia_payroll
	WHEN MONTH(date_from) BETWEEN 4 AND 6 THEN 2
	WHEN MONTH(date_from) BETWEEN 7 AND 9 THEN 3
	WHEN MONTH(date_from) BETWEEN 10 AND 12 THEN 4
END AS quarter	
FROM czechia_price cp 
WHERE region_code IS NULL
ORDER BY date_from
)
SELECT 
	cpp.id,
	cpp.value,
	cpp.industry_branch_code,
	cpib.name ,
	cpp.payroll_year,
	cpp.payroll_quarter,
	czechia_price_adjusted.date_from,
	czechia_price_adjusted.year,
	czechia_price_adjusted.quarter,
	czechia_price_adjusted.category_code,
	czechia_price_adjusted.value,
	czechia_price_category.name	
FROM czechia_payroll cpp
CROSS JOIN  czechia_price_adjusted
LEFT JOIN czechia_price_category ON 
	czechia_price_adjusted.category_code=czechia_price_category.code 
LEFT JOIN czechia_payroll_industry_branch cpib ON
	cpib.code =cpp.industry_branch_code 
WHERE
	value_type_code = 5958                				  -- hodnota pro mzdu
	AND calculation_code =100              				  -- počítáme jen s hodnotou reálnou hodnotou mzdy, nikoliv přepočtenou
	AND industry_branch_code IS NOT NULL    			  -- NULL hodnoty v czechia_payroll.industry_branch_code jsou průměry, nepočitám  
	AND cpp.payroll_year =czechia_price_adjusted.year     -- rok na rok 
	AND cpp.payroll_quarter=czechia_price_adjusted.quarter-- kvartál na kvartál, zároven vyřadí záznamy, kde nemáme data za korespondující období
ORDER BY industry_branch_code ,
	cpp.payroll_year ,
	cpp.payroll_quarter,
	czechia_price_adjusted.date_from;


-- just a test for comit validation