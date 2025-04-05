/*
Las funciones de agregación tradicionales como SUM(), AVG(), COUNT() y similares, colapsan filas en un grupo único.
El resultado te da una sola fila por combinación de YEAR_ID y MONTH_ID, y pierdes los datos originales de cada venta. 
*/
.timer ON
SELECT YEAR_ID, MONTH_ID, AVG(SALES)
FROM sales
GROUP BY YEAR_ID, MONTH_ID;  -- Run Time: 0.002s 

-- Es útil si solo quieres ver los totales o promedios, pero no puedes ver el detalle por fila al mismo tiempo.

/*
Por otro lado, con las funciones de ventana (como AVG() OVER (...)), puedes conservar cada fila original, pero agregarle una columna con el cálculo agregado correspondiente a su grupo.
*/
.timer ON
SELECT 
  YEAR_ID,
  MONTH_ID,
  SALES,
  AVG(SALES) OVER (PARTITION BY YEAR_ID, MONTH_ID) AS avg_monthly_sales
FROM sales;  -- Run Time: 0.010s
--Así, puedes comparar cada venta con su contexto mensual sin perder detalle.

/*✅ En resumen: la ventana no colapsa filas como GROUP BY; conserva el contexto de cada una.*/