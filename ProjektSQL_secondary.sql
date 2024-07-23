CREATE TABLE t_Martin_Dvorak_project_SQL_secondary_final AS
SELECT 
	e.country,
	e.`year`,
	e.GDP,
	e.population,
	e.gini,
	c.continent 
FROM economies e 
LEFT JOIN
	countries c 
	ON
	 e.country =c.country 
	WHERE
	c.continent LIKE '%europe%'
	AND e.`year` BETWEEN 
		(SELECT MIN(payroll_year)
		 FROM t_martin_dvorak_project_sql_primary_final
		)
		AND
		(SELECT MAX(payroll_year)
		 FROM t_martin_dvorak_project_sql_primary_final
		)
ORDER BY e.country, e.`year`;
