/*
Veamos los tiempos de ejecucion de ambas consultas para el siguiente caso:
Obtener todos los productos cuyo precio (PRICEEACH) es mayor al precio promedio de su misma línea de producto (PRODUCTLINE).
*/

-- OPCION 1: Subconsulta correlacionada
.timer ON 
SELECT *
FROM sales s
WHERE PRICEEACH > (
    SELECT AVG(PRICEEACH)
    FROM sales
    WHERE PRODUCTLINE = s.PRODUCTLINE
);
-- Run Time: 0.796s

-- OPCION 2: Subconsulta no correlacionada + JOIN
.timer ON 
SELECT s.*
FROM sales s
JOIN (
    SELECT PRODUCTLINE, AVG(PRICEEACH) AS avg_price
    FROM sales
    GROUP BY PRODUCTLINE
) avg_table ON s.PRODUCTLINE = avg_table.PRODUCTLINE
WHERE s.PRICEEACH > avg_table.avg_price;
-- Run Time: 0.025s

