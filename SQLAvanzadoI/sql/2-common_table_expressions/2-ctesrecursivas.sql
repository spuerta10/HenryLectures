/*
Las CTEs recursivas son consultas que se llaman a si mismas, generalmente se usan para recorrer estructuras estructuras jerárquicas o datos que se relacionan consigo mismos.
Arboles, grafos y estructuras de empleados y jefes son ejemplos de estructuras que pueden ser recorridas con CTEs recursivas.

¿Cómo funciona una CTE recursiva?
Las CTEs recursivas se componen de dos partes:
1. Parte base: selecciona el primer conjunto de filas (por ejemplo, los nodos raíz).
2. Parte recursiva: hace referencia a la CTE y se repite hasta que ya no hay más filas que agregar.

Con el siguiente ejemplo lo veras mejor:
*/

-- Tenemos una tabla de `employees` y queremos ver la jerarquía de empleados que reportan a David y Gabriel

--SELECT * FROM employees;

WITH RECURSIVE employee_hierarchy AS (
    -- Paso base: empleados cuyo jefe es 4 (David) o 7 (Gabriel)
    SELECT 
        id,
        name,
        boss_id,
        id AS root_id
    FROM employees
    WHERE boss_id == 4 OR boss_id = 7

    UNION ALL

    -- Paso recursivo: empleados cuyo boss_id está en los ya encontrados
    SELECT 
        e.id,
        e.name,
        e.boss_id,
        eh.root_id
    FROM employees e
    INNER JOIN employee_hierarchy eh
        ON e.boss_id = eh.id
)
SELECT *
FROM employee_hierarchy
ORDER BY root_id, id;

/*
Explicando el resultado: El CTE recursivo esta obteniendo todos los empleados que reportan a David y Gabriel directa o indirectamente.
Quienes reportan a Gabriel directamente son:
1. Hugo
Quienes reportan a Gabriel indirectamente son:
1. Ines
2. Julia
Asi mismo, el unico que reporta a David directamente es Kevin.
*/

