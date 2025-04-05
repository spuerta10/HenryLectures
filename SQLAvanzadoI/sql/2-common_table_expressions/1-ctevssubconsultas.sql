/*
Ahora veremos como las Common Table Expressions (CTE) pueden ser utilizadas para mejorar la legibilidad de las consultas SQL.
Las CTE son una forma de definir una consulta temporal que puede ser referenciada dentro de otra consulta. 
Esto hace que las consultas sean más fáciles de entender y mantener, especialmente cuando se trabaja con subconsultas complejas o anidadas.
Veamoslo por medio de este ejemplo:
Queremos obtener los productos con precio mayor al promedio de su línea
*/

-- OPCION 1: Usando subconsultas
.timer ON 
SELECT *
FROM sales s
WHERE s.PRICEEACH > (
    SELECT AVG(PRICEEACH)
    FROM sales
    WHERE PRODUCTLINE = s.PRODUCTLINE
);
-- Run Time: 0.805s

-- OPCION 2: Usando CTE
.timer ON 
WITH avg_prices AS (
    SELECT PRODUCTLINE, AVG(PRICEEACH) AS avg_price
    FROM sales
    GROUP BY PRODUCTLINE
)
SELECT s.*
FROM sales s
JOIN avg_prices ap ON s.PRODUCTLINE = ap.PRODUCTLINE
WHERE s.PRICEEACH > ap.avg_price;
-- Run Time: 0.017s

/*
Las CTE tiene varias ventajas:
- Separan el calculo de los promedios, lo cual lo hace mas legible y mantenible.
- La consulta principal es mas clara.
- Se puede hacer uso de la CTE multiples veces en la misma consulta. 
*/