/*
Finalmente, veremos para que sirven y como usar las funciones LAG() y LEAD().
Estas funciones pertenecen al conjunto de funciones de ventana y permiten acceder a filas anteriores o posteriores en relación con la fila actual, sin perder el contexto de la fila en sí.

Son extremadamente útiles cuando queremos:
- Comparar valores entre periodos (por ejemplo, crecimiento mes a mes),
- Detectar cambios en valores entre registros,
- Analizar tendencias o diferencias entre registros consecutivos.

🔹LAG(valor, [offset], [default])
Devuelve el valor de una fila anterior dentro de la ventana.

🔹LEAD(valor, [offset], [default])
Devuelve el valor de una fila posterior dentro de la ventana.
*/

-- EJEMPLO 1: Calcular el crecimiento mensual en ventas
WITH ventas_mensuales AS (
    SELECT 
        YEAR_ID,
        MONTH_ID,
        SUM(SALES) AS total_sales
    FROM sales
    GROUP BY YEAR_ID, MONTH_ID
),
ventas_con_lag AS (
    SELECT 
        YEAR_ID,
        MONTH_ID,
        total_sales,
        LAG(total_sales) OVER (PARTITION BY YEAR_ID ORDER BY MONTH_ID) AS ventas_mes_anterior
    FROM ventas_mensuales
)
SELECT 
    YEAR_ID,
    MONTH_ID,
    total_sales,
    ventas_mes_anterior,
    ROUND(
        100.0 * (total_sales - ventas_mes_anterior) / ventas_mes_anterior,
        2
    ) AS crecimiento_pct
FROM ventas_con_lag
ORDER BY YEAR_ID, MONTH_ID;
/*
¿Qué hace este query?
- CTE ventas_mensuales: Agrupa las ventas por mes y año, para que solo haya una fila por cada combinación.
- CTE ventas_con_lag: Aplica LAG() sobre estos totales ordenados por mes.
- Cálculo final: Compara ventas del mes actual con el mes anterior.
*/

-- Usando la función LEAD() para obtener las ventas del siguiente mes para cada fila. Mostrar las ventas actuales y las del mes siguiente lado a lado.

WITH ventas_mensuales AS (
    SELECT 
        YEAR_ID,
        MONTH_ID,
        SUM(SALES) AS total_sales
    FROM sales
    GROUP BY YEAR_ID, MONTH_ID
),
ventas_con_lead AS (
    SELECT 
        YEAR_ID,
        MONTH_ID,
        total_sales,
        LEAD(total_sales) OVER (PARTITION BY YEAR_ID ORDER BY MONTH_ID) AS ventas_mes_siguiente
    FROM ventas_mensuales
)
SELECT 
    YEAR_ID,
    MONTH_ID,
    total_sales,
    ventas_mes_siguiente
FROM ventas_con_lead
ORDER BY YEAR_ID, MONTH_ID;

/*
¿Qué hace este query?
- ventas_mensuales: resume las ventas por año y mes.
- ventas_con_lead: usa la función LEAD() para obtener las ventas del mes siguiente sin perder la fila actual.
- En el SELECT final se muestran las ventas actuales y las del mes siguiente, para facilitar comparaciones.
*/