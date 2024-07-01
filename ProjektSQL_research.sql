
-- Query 1.1
SELECT 
	t_max.industry_branch_code ,
	t_max.salary AS Salary_2018 ,
	t_min.salary AS Salary_2006
FROM t_martin_dvorak_project_sql_primary_final t_max
LEFT JOIN
	(SELECT industry_branch_code ,salary 
	FROM t_martin_dvorak_project_sql_primary_final tmdpspf 
	WHERE payroll_year =2006 AND payroll_quarter=1
	) t_min
	ON 
	t_max.industry_branch_code =t_min.industry_branch_code
WHERE payroll_year=2018 
	AND payroll_quarter =4 
	AND category_code =111101
GROUP BY t_max.industry_branch_code ;




-- Query 1.2

SELECT		
	main.branch_name ,
	secondary.payroll_year,
	secondary.avg_monthly_salary_secondary,
	ROUND(AVG(salary)) AS avg_monthly_salary_main,
	secondary.avg_monthly_salary_secondary - ROUND(AVG(salary)) AS diff_last_year    -- záporné číslo značí pokles meziroční průměrné mzdy v oboru
FROM t_martin_dvorak_project_sql_primary_final main 
LEFT JOIN
	(SELECT 
		payroll_year ,
		branch_name ,
		industry_branch_code ,
		ROUND(AVG(salary)) AS avg_monthly_salary_secondary
	FROM t_martin_dvorak_project_sql_primary_final main
	GROUP BY payroll_year,industry_branch_code  
	ORDER BY industry_branch_code ,payroll_year
	) secondary
ON
	secondary.payroll_year =main.payroll_year +1 AND
	main.industry_branch_code =secondary.industry_branch_code 
WHERE secondary.payroll_year IS NOT NULL
GROUP BY main.payroll_year, main.industry_branch_code  
ORDER BY main.industry_branch_code ,main.payroll_year ,diff_last_year ASC;


-- Query 2

SELECT
	table_08.branch_name ,
	table_08.name,
	ROUND(table_08.salary/table_08.price) AS can_buy_2006,  -- ceny jsou pro tyto komodity uvedeny v kilogramech a litrech, není třeba další úpravy výsledku
	table_18.can_buy_2018
FROM t_martin_dvorak_project_sql_primary_final table_08 
LEFT JOIN 
	(SELECT	
		sub_table.branch_name ,
		sub_table.salary ,
		sub_table.price ,
		sub_table.category_code ,
		ROUND(sub_table.salary/sub_table.price) AS can_buy_2018
	FROM t_martin_dvorak_project_sql_primary_final sub_table
	WHERE sub_table.category_code IN (111301,114201) 
		AND `year` =2018
		AND quarter =4
	) table_18 
	ON
	table_18.category_code=table_08.category_code 
	AND table_08.branch_name =table_18.branch_name
WHERE table_08 .category_code IN (111301,114201) 
	AND table_08 .`year` =2006
	AND table_08 .quarter =1;


-- Query 3
 -- TBD překlopit na sebe tuto tabulku s odsazením  , maybe WITH? uděalt rozdíl a ten pak zprůmněrovat přes COUNT 
 SELECT
 	main.`year` ,
 	main.quarter ,
	 main.category_code,
	 main.price
 FROM t_martin_dvorak_project_sql_primary_final main 
 GROUP BY category_code ,`year` ,quarter ;

