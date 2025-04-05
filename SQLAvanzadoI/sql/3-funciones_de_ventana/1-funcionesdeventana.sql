/*
¿Que es una funcion de ventana?
Una función de ventana permite realizar cálculos sobre un subconjunto de filas relacionadas con la fila actual, sin agrupar los datos (a diferencia de GROUP BY).
📌 La clave es la cláusula OVER(...), que define la ventana sobre la cual se aplica la función.
Veamoslo con un ejemplo:
*/

-- Queremos hallar el promedio de ventas por mes y año, pero sin agrupar los datos.
WITH ventas_con_promedio AS ( 
    SELECT 
        YEAR_ID,
        MONTH_ID,
        SALES,
        AVG(SALES) OVER  -- Función de ventana que calcula el promedio de SALES
            (PARTITION BY YEAR_ID, MONTH_ID)  -- Agrupa lógicamente por año y mes (sin eliminar filas)
        AS avg_monthly_sales
    FROM sales
)
SELECT DISTINCT YEAR_ID, MONTH_ID, avg_monthly_sales
FROM ventas_con_promedio
ORDER BY YEAR_ID, MONTH_ID;

/*
¿Como se ejecuta internamente?
1. Cargar los datos
Primero, el motor de la base de datos carga todas las filas de la tabla sales con las columnas necesarias: YEAR_ID, MONTH_ID, y SALES.
2. Organizar los datos en "ventanas"
Luego, la base de datos agrupa las filas lógicamente en ventanas, sin eliminar ninguna. En este caso, se agrupan por YEAR_ID y MONTH_ID. Cada grupo es tratado como una "ventana".
3. Aplicar la funcion de ventana
Para cada grupo/ventana (YEAR_ID, MONTH_ID), calcula el AVG(SALES) y asigna ese valor a todas las filas del mismo grupo.
4. Seleccionar lo que pides (DISTINCT)
Finalmente, si haces un SELECT DISTINCT de YEAR_ID, MONTH_ID, avg_monthly_sales, entonces se eliminan duplicados y te queda solo una fila por mes con el promedio.
*/