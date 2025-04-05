/*
Generalmente los JOINS son mas eficientes que las consultas correlacionadas.
*/

.timer ON 
SELECT 
    DISTINCT PRODUCTCODE, PRODUCTLINE
FROM 
    sales s
WHERE QUANTITYORDERED > (
    SELECT AVG(QUANTITYORDERED)
    FROM sales
    WHERE PRODUCTLINE = s.PRODUCTLINE 
)
ORDER BY
    PRODUCTLINE;
-- Run Time: 0.781s

.timer ON 
SELECT DISTINCT
    s.PRODUCTCODE,
    s.PRODUCTLINE
FROM
    sales s
JOIN (
    SELECT
        PRODUCTLINE,
        AVG(QUANTITYORDERED) AS avg_quantity
    FROM
        sales
    GROUP BY PRODUCTLINE
) avg_table ON s.PRODUCTLINE = avg_table.PRODUCTLINE
WHERE s.QUANTITYORDERED > avg_table.avg_quantity
ORDER BY s.PRODUCTLINE;
-- Run Time: 0.003s