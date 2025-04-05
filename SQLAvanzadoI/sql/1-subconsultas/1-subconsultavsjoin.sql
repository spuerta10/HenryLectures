/*
¿Cuando debo de usar JOIN o una sub-consulta? Hay varias situaciones en las que es mejor
usar una sub-consulta en lugar de un JOIN. Estas son algunas:
*/

/* 
Caso 1: Cuando hay que comparar contra un valor AGREGADO GLOBAL
En esta situacion, no tiene sentido un JOIN, porque solo necesitas un valor (el promedio total).
*/

-- Hallar los productos que tienen un precio mayor al promedio del precio de todos los productos.
SELECT 
    DISTINCT PRODUCTCODE
FROM
    sales
WHERE PRICEEACH > (
    SELECT AVG(PRICEEACH)
    FROM sales
);


/*
Caso 2: Cuando la subconsulta encapsula una lógica específica
*/
-- Hallar los productos de la linea de productos "Motorcycles" que tienen un precio mayor al promedio del precio de todos los productos en el año 2005.
SELECT
    DISTINCT PRODUCTCODE, PRICEEACH, PRODUCTLINE
FROM
    sales
WHERE PRICEEACH > (
    SELECT AVG(PRICEEACH) FROM sales WHERE YEAR_ID = 2005
)
AND PRODUCTLINE = "Motorcycles"
ORDER BY PRODUCTLINE;