-- Módulo 4 - Consultas SQL de negocio
-- Base de datos: Ventas_Tech_DB
-- Tabla utilizada: ventas
-- Motor: SQL Server

USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen ejecutivo mensual
-- Calcula total facturado, cantidad de pedidos y ticket promedio por mes.

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


-- CONSULTA 2: Ranking de los 5 productos con mayor facturación
-- Muestra unidades vendidas y total generado por cada producto.

SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


-- CONSULTA 3: Clientes recurrentes
-- Muestra los clientes que realizaron más de un pedido y cuánto gastaron.

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;
GO


-- CONSULTA 4: Facturación por producto comparada con el promedio
-- Primero se calcula la facturación total de cada producto.
-- Después se obtiene el promedio de esos totales y se compara cada producto.

WITH facturacion_producto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)
SELECT
    fp.id_producto,
    fp.total_facturado,
    CASE
        WHEN fp.total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_producto
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_con_promedio
FROM facturacion_producto AS fp
ORDER BY fp.total_facturado DESC;
GO


-- BLOQUE DE CIERRE: 3 hallazgos del análisis
-- 1. En marzo de 2024 se facturaron $6.444 en un total de 10 pedidos, con un ticket promedio de $644,40.
-- 2. El producto ID 1 fue el que más facturó, generando $3.600, aproximadamente el 55,9% de la facturación total.
-- 3. El cliente ID 1 fue el que más gastó entre los clientes recurrentes, con un total de $2.640 en 2 pedidos.
