/*
Existen dos tipos de subconsultas:
1. Subconsultas NO correlacionadas
2. Subconsultas correlacionadas
*/

/* 
Subconsultas NO correlacionadas
*/
SELECT * FROM sales
WHERE PRICEEACH > (SELECT AVG(PRICEEACH) FROM productos);
-- No dependen de la consulta externa, se ejecutan una sola vez antes de la consulta externa.

-- Es como si estuvieras haciendo esto:
SELECT AVG(PRICEEACH) FROM sales;  /*83.65854410201914*/

SELECT * FROM sales WHERE PRICEEACH > 83.65854410201914;

/*
Subconsultas correlacionadas
*/
SELECT * FROM sales s
WHERE PRICEEACH > (
    SELECT AVG(PRICEEACH) FROM sales WHERE YEAR_ID = s.YEAR_ID
);
-- Se ejecutan UNA VEZ POR CADA FILA de la consulta externa
/*
Por cada fila de la tabla de `sales` calculas el promedio de `PRICEEACH` para el año que contiene esa fila.
Si el precio de la fila actual es mayor al promedio calculado, la guardas en el resultado.

Esto quiere decir que por cada fila el promedio de `PRICEEACH` se recalcula nuevamente. 
Para este conjunto de datos el promedio de `PRICEEACH` se recalcula 2.824 (💀) veces.
*/

/*
¿Y su impacto en el rendimiento?
- Las subconsultas NO correlacionadas son rapidas ya que solo son dos consultas "independientes".
Consulta externa + filtro.
- Las subconsultas correlacionadas son LENTISIMAS ya que por cada fila se ejecuta una subconsulta.
El numero de filas de la tabla externa sera igual al numero total de consultas a la base de datos.
Imagina una base de datos de 100 millones de registros, eso significa 100 millones de consultas (😱) a la base de datos.
*/
