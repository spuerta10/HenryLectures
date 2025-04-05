/*
Ahora veremos funciones de ranking.
En SQL, las funciones de ranking permiten numerar filas dentro de grupos de datos ordenados sin colapsarlas. 
A diferencia de las funciones de agregación tradicionales (SUM, AVG, etc.), estas funciones preservan cada fila individual y trabajan como una “capa” adicional que te ayuda a analizar posiciones relativas, identificar duplicados o extraer los top N elementos por grupo.

¿Para qué sirven?
Estas funciones son esenciales para tareas como:
- Encontrar los primeros o últimos valores dentro de una categoría.
- Detectar registros duplicados.
- Crear rankings personalizados en reportes.
- Hacer comparaciones entre elementos similares (por ejemplo, los mejores productos por categoría).

¿Cuales son estas funciones?
- RANK(): asigna el mismo número en caso de empates, pero salta números.
- DENSE_RANK(): asigna el mismo número en caso de empates, pero no salta números.
- ROW_NUMBER(): Asigna un número único a cada fila dentro de un grupo ordenado. Si hay empates, igual asigna números distintos (no repite ranking).

Veamos un caso de uso de ROW_NUMBER() para identificar registros duplicados en nuestra tabla de sales.
*/

WITH ventas_con_rn AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY ORDERNUMBER, PRODUCTCODE, QUANTITYORDERED
            ORDER BY ORDERNUMBER 
        ) AS rn
    FROM sales
)
SELECT *
FROM ventas_con_rn
WHERE rn > 1;
-- JEJEJE, no hay duplicados en la tabla sales, pero si los hubiera, el resultado te mostraría las filas duplicadas con su número de fila (rn) dentro de cada grupo de duplicados.

/*
PSS.. Como tarea, puedes intentar:
- Usar RANK() para obtener el ranking de ventas (SALES) por año (YEAR_ID), ordenando de mayor a menor.
- Haz lo mismo con DENSE_RANK().
¿Notas una diferencia entre RANK() y DENSE_RANK() con los valores que siguen a un empate?
¿En qué casos conviene usar RANK() y en cuáles DENSE_RANK()?
*/
