/*
Ahora veremos un ejemplo de uso de CTEs. 
Calcularemos el porcentaje de valores nulos de la columna `state` de la tabla `customers`. 
*/

WITH total_rows AS (
    SELECT COUNT(*) AS total FROM customers
),
null_emails AS (
    SELECT COUNT(*) AS nulls FROM customers WHERE state IS NULL
)
SELECT 
    nulls,
    total,
    ROUND((CAST(nulls AS REAL) / total) * 100, 2) AS null_percentage
FROM null_emails, total_rows;