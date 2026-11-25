
-- =============================================
-- PROYECTO RETAILPRO
-- MODULO 5: CONSULTAS CON JOINS
-- Base de datos: Ventas_Tech_DB
-- =============================================

USE Ventas_Tech_DB;
GO

-- =============================================
-- CONSULTA 1: VISTA BASE DEL PROYECTO
-- Propósito: enriquecer las ventas con información
-- de clientes, productos y categorías.
-- =============================================

SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta

FROM ventas v
INNER JOIN clientes c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos p
    ON v.id_producto = p.id_producto
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria;

-- Hallazgo: Las 10 ventas registradas se enriquecen
-- con información de clientes, productos, categorías y ciudades.


-- =============================================
-- CONSULTA 2: CLIENTES SIN VENTAS
-- Propósito: detectar clientes registrados
-- que nunca realizaron una compra.
-- =============================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro

FROM clientes c
LEFT JOIN ventas v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 de los 5 clientes registrados están sin compras.
-- CRM no necesita realizar acciones de captación inicial
-- por clientes que nunca hayan comprado.


-- =============================================
-- CONSULTA 3: PRODUCTOS SIN VENTAS
-- Propósito: identificar artículos del catálogo
-- que nunca registraron una venta.
-- =============================================

SELECT
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio

FROM productos p
INNER JOIN categorias cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: 0 de los 6 productos del catálogo están sin ventas.
-- El área de producto puede observar que todos los artículos
-- registraron movimiento comercial.


-- =============================================
-- CONSULTA 4: CONSOLIDADO POR CANAL
-- Propósito: comparar las ventas de dos períodos
-- mediante UNION ALL.
-- =============================================

SELECT
    canal,
    SUM(total) AS total_canal

FROM (

    SELECT
        cantidad * precio_unitario AS total,
        'Primera parte de marzo' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT
        cantidad * precio_unitario AS total,
        'Segunda parte de marzo' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'

) AS consolidado

GROUP BY canal;

-- Hallazgo: La primera parte de marzo generó $3.620
-- y la segunda parte $2.824. El primer período
-- registró el mayor importe de ventas.
