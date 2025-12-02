-- TRABAJO PRÁCTICO - CREACIÓN DE VISTAS MySQL 
create database if not exists libreria3;
USE libreria3; 
 
-- EJERCICIO 1
CREATE OR REPLACE VIEW vista_libros_1 AS
SELECT title, au_id, price
FROM titles;

-- EJERCICIO 2
CREATE OR REPLACE VIEW vista_libros_2 AS
SELECT title, au_id, price, type
FROM titles;

-- EJERCICIO 3
CREATE OR REPLACE VIEW vista_libros_3 AS
SELECT title, au_id, price, pubdate
FROM titles;

-- EJERCICIO 4
CREATE OR REPLACE VIEW vista_sales_1 AS
SELECT t.title, t.au_id, t.price, s.qty
FROM sales s
JOIN titles t ON s.title_id = t.title_id;

-- EJERCICIO 5
CREATE OR REPLACE VIEW vista_sales_tienda AS
SELECT st.stor_name, t.title, t.au_id, t.price, s.qty
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id;

-- EJERCICIO 6
CREATE OR REPLACE VIEW vista_sales_tipo AS
SELECT t.type, t.title, t.au_id, t.price, s.qty
FROM sales s
JOIN titles t ON s.title_id = t.title_id;

-- EJERCICIO 7
CREATE OR REPLACE VIEW vista_sales_tienda_tipo AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id;

-- EJERCICIO 8
CREATE OR REPLACE VIEW vista_sales_tienda_anio AS
SELECT st.stor_name, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id;

-- EJERCICIO 9
CREATE OR REPLACE VIEW vista_sales_tienda_tipo_anio AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id;

-- EJERCICIO 10
CREATE OR REPLACE VIEW vista_sales_tienda_tipo_anio_mes AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty,
       YEAR(t.pubdate) AS anio, MONTH(t.pubdate) AS mes
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id;

-- EJERCICIOS CON WHERE

-- EJERCICIO 11
CREATE OR REPLACE VIEW vista_sales_mas_de_10 AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE s.qty > 10;

-- EJERCICIO 12
CREATE OR REPLACE VIEW vista_sales_1990 AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE YEAR(t.pubdate) = 1990;

-- EJERCICIO 13
CREATE OR REPLACE VIEW vista_sales_90_94 AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE YEAR(t.pubdate) BETWEEN 1990 AND 1994;

-- EJERCICIO 14
CREATE OR REPLACE VIEW vista_sales_store_7066 AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE st.stor_id = 7066;

-- EJERCICIO 15
CREATE OR REPLACE VIEW vista_sales_autor_172 AS
SELECT st.stor_name, t.type, t.title, t.au_id, t.price, s.qty, YEAR(t.pubdate) AS anio
FROM sales s
JOIN titles t ON s.title_id = t.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE t.au_id = 172;

-- EJERCICIOS DE ACTUALIZACIÓN MEDIANTE VISTAS

-- EJERCICIO 16 - Actualizar precios
CREATE OR REPLACE VIEW vista_update_precio AS
SELECT title_id, title, price
FROM titles;

-- EJERCICIO 17 - Actualizar nombre de autor
CREATE OR REPLACE VIEW vista_update_autor AS
SELECT au_id, au_lname, au_fname
FROM authors;

-- EJERCICIO 18 - Actualizar cantidad vendida
CREATE OR REPLACE VIEW vista_update_qty AS
SELECT title_id, stor_id, ord_num, qty
FROM sales;

-- EJERCICIO 19 - Actualizar fecha de publicación
CREATE OR REPLACE VIEW vista_update_pubdate AS
SELECT title_id, title, pubdate
FROM titles;

-- EJERCICIO 20 - Actualizar tipo de libro
CREATE OR REPLACE VIEW vista_update_tipo AS
SELECT title_id, title, type
FROM titles;
