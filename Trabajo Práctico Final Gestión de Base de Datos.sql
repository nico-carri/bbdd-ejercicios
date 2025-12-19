-- TP FINAL - Gestión de Base de Datos
DROP DATABASE IF EXISTS trabajo_final_bbdd;
CREATE DATABASE trabajo_final_bbdd;
USE trabajo_final_bbdd;

-- ///===============================================================================///
-- base "pubs" que se solicita en los puntos 5, 9 y 10
DROP DATABASE IF EXISTS pubs;
CREATE DATABASE pubs;

USE trabajo_final_bbdd;

-- ///===============================================================================///
-- TABLAS E INSERCIÓN DE DATOS PARA VERIFICACIÓN (asi no de error)

-- Tabla para Punto 1
CREATE TABLE ventas (
    monto DECIMAL(12,2),
    fecha_venta DATE
);
INSERT INTO ventas VALUES (5000.00, '2024-03-10'), (2500.00, '2024-03-20');

-- Tabla para Punto 2 y 7
CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    edad INT,
    antiguedad INT
);
INSERT INTO empleados (nombre, apellido, edad, antiguedad) VALUES ('Juan', 'Pérez', 30, 5);

-- Tablas para Punto 3
CREATE TABLE cursos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);
CREATE TABLE calificaciones (
    id_curso INT,
    nota DECIMAL(4,2),
    FOREIGN KEY (id_curso) REFERENCES cursos(id)
);
INSERT INTO cursos (nombre) VALUES ('Matemática');
INSERT INTO calificaciones VALUES (1, 8.0), (1, 10.0);

-- Tabla para Punto 4 y 6
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    id_fabricante INT,
    nombre_producto VARCHAR(255) NOT NULL,
    fecha_lanzamiento DATE,
    codigo VARCHAR(50),
    stock INT
);
INSERT INTO productos (id_producto, id_fabricante, nombre_producto, codigo, stock) 
VALUES (1, 1, 'Producto X', 'A100', 10);

-- Tabla para Punto 5
CREATE TABLE titles (
    title VARCHAR(100),
    author VARCHAR(100),
    price DECIMAL(10,2),
    publisher VARCHAR(100),
    type VARCHAR(50)
);
INSERT INTO titles VALUES ('Cocina Fácil', 'Chef Pepe', 1500.00, 'Planeta', 'cooking');

-- Tabla para Punto 8
CREATE TABLE empleados_salarios (
    codigo_empleado VARCHAR(10) PRIMARY KEY,
    salario DECIMAL(10,2)
);
INSERT INTO empleados_salarios VALUES ('E001', 35000.00);

-- ///===============================================================================///

-- 1 - Crear una función llamada "calcular_total_ventas" que tome como parámetro el mes y el año, y devuelva el total de ventas realizadas en ese mes. Verificar mediante consulta.

DELIMITER $$
CREATE FUNCTION calcular_total_ventas(mes INT, anio INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);

    SELECT SUM(monto)
    INTO total
    FROM ventas
    WHERE MONTH(fecha_venta) = mes
      AND YEAR(fecha_venta) = anio;

    RETURN IFNULL(total, 0);
END$$
DELIMITER ;

-- Verificación
SELECT calcular_total_ventas(3, 2024) AS total_marzo_2024;

-- 2 - Crear una función llamada "obtener_nombre_empleado" que tome como parámetro el ID de un empleado y devuelva su nombre completo. Verificar mediante consulta.

DELIMITER $$
CREATE FUNCTION obtener_nombre_empleado(id_empleado INT)
RETURNS VARCHAR(200)
DETERMINISTIC
BEGIN
    DECLARE nombre_completo VARCHAR(200);

    SELECT CONCAT(nombre, ' ', apellido)
    INTO nombre_completo
    FROM empleados
    WHERE id = id_empleado;

    RETURN nombre_completo;
END$$
DELIMITER ;

-- Verificación
SELECT obtener_nombre_empleado(1) AS nombre_empleado;

-- 3 - Crear un procedimiento almacenado llamado "obtener_promedio" que tome como parámetro de entrada el nombre de un curso y calcule el promedio de las calificaciones de todos los alumnos inscriptos en ese curso. Verificar mediante ejecución del procedimiento.
DELIMITER $$
CREATE PROCEDURE obtener_promedio(IN nombre_curso VARCHAR(100))
BEGIN
    SELECT AVG(c.nota) AS promedio_notas
    FROM calificaciones c
    INNER JOIN cursos cu ON cu.id = c.id_curso
    WHERE cu.nombre = nombre_curso;
END$$
DELIMITER ;

-- Verificación
CALL obtener_promedio('matemática');

-- 4 Crear un procedimiento almacenado "actualizar_stock" que tome como parámetros de entrada el código del producto y la cantidad a agregar al stock actual. El procedimiento debe actualizar el stock sumando la cantidad especificada al stock actual del producto correspondiente. Verificar mediante ejecución del procedimiento.
SET SQL_SAFE_UPDATES = 0;
DELIMITER $$
CREATE PROCEDURE actualizar_stock(IN codigo_producto VARCHAR(50), IN cantidad_producto INT)
BEGIN
    UPDATE productos
    SET stock = stock + cantidad_producto 
    WHERE codigo = codigo_producto;
END$$
DELIMITER ;

-- Verificación
CALL actualizar_stock('A100', 20);
SELECT * FROM productos WHERE codigo = 'A100';

-- 5 - Crear una vista que muestre el título, el autor, el precio y la editorial de todos los libros de cocina de la base pubs.
USE pubs;
CREATE TABLE titles (title VARCHAR(100), author VARCHAR(100), price DECIMAL(10,2), publisher VARCHAR(100), type VARCHAR(50));
INSERT INTO titles VALUES ('Cocina China', 'Lee Hong', 25.50, 'HK Ed.', 'cooking');

CREATE OR REPLACE VIEW vista_libros_cocina AS
SELECT title AS titulo,
       author AS autor,
       price AS precio,
       publisher AS editorial
FROM titles
WHERE type = 'cooking';

-- Verificación
SELECT * FROM vista_libros_cocina;

-- 6 – Dadas las siguientes tablas:
DROP TABLE IF EXISTS fabricantes;
CREATE TABLE fabricantes (
    id_fabricante INT PRIMARY KEY,
    nombre_fabricante VARCHAR(255) NOT NULL
);

INSERT INTO fabricantes (id_fabricante, nombre_fabricante)
VALUES(1, 'Fabricante A'),(2, 'Fabricante B'),(3, 'Fabricante C');

DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    id_fabricante INT,
    nombre_producto VARCHAR(255) NOT NULL,
    fecha_lanzamiento DATE,
    FOREIGN KEY (id_fabricante) REFERENCES fabricantes(id_fabricante)
);

INSERT INTO productos (id_producto, id_fabricante, nombre_producto, fecha_lanzamiento)
VALUES(1, 1, 'Producto X', '2020-01-01'),(2, 2, 'Producto Y', '2019-12-01'), (3, 3, 'Producto Z', '2021-05-15'); 

-- a) Crear un índice compuesto
CREATE INDEX idx_productos_id_fabricante_nombre
ON productos (id_fabricante, nombre_producto);

-- b) Crear un índice único en id_producto
CREATE UNIQUE INDEX idx_productos_id_producto
ON productos (id_producto);

-- c) Modificar el índice para que sea único en id_fabricante
CREATE UNIQUE INDEX idx_productos_id_fabricante
ON productos (id_fabricante);

-- d) Crear un nuevo índice único en id_fabricante (con otro nombre como pide la consigna)
CREATE UNIQUE INDEX idx_unico_id_fabricante
ON productos (id_fabricante);

-- e) Eliminar el índice idx_productos_id_fabricante
DROP INDEX idx_productos_id_fabricante ON productos;
DROP INDEX idx_productos_id_fabricante_nombre ON productos;

-- 7 -  Se desea modificar un sistema de gestión de empleados para incluir  un mecanismo automático que transfiera a los empleados que cumplen con ciertos criterios de jubilación a una tabla especializada llamada jubilados. 
 -- Los criterios de jubilación son: los empleados deben tener 30 años o más de antigüedad y 65 años o más de edad. Además, se requiere que cualquier inserción en la tabla empleados que cumpla con estos criterios resulte en una inserción automática en la tabla jubilados.
DROP TABLE IF EXISTS empleados;
CREATE TABLE empleados (
  nombre VARCHAR(50) NOT NULL,
  edad INT NOT NULL,
  antiguedad INT NOT NULL
);

DROP TABLE IF EXISTS jubilados;
CREATE TABLE jubilados (
  nombre VARCHAR(50) NOT NULL,
  edad INT NOT NULL,
  antiguedad INT NOT NULL
);
DELIMITER $$

CREATE TRIGGER trg_insert_jubilados
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    IF NEW.antiguedad >= 30 AND NEW.edad >= 65 THEN
        INSERT INTO jubilados (nombre, edad, antiguedad)
        VALUES (NEW.nombre, NEW.edad, NEW.antiguedad);
    END IF;
END$$
DELIMITER ;

 -- Verificacion 
 INSERT INTO empleados VALUES ('Juan Pérez', 66, 32);
SELECT * FROM jubilados;

-- 8 - Crear un procedimiento almacenado llamado ActualizarEmpleados que tome dos  parámetros de entrada:
-- codigo_empleado (VARCHAR, 10): El identificador del empleado a actualizar.
-- salario_actualizado (DECIMAL): El nuevo salario del empleado.
-- En el procedimiento, utilizar una transacción para realizar la actualización del salario del empleado:
-- Obtener la información actual del empleado especificado.
-- Verificar si el nuevo salario es válido (no puede ser menor que el salario actual).
-- Si el salario es válido, realizar la actualización del salario del empleado.
-- Si el salario actualizado fuere menor que el salario actual, mostrar un mensaje al usuario indicando que la operación se cancela y realizar un rollback.
-- Llamar al procedimiento ActualizarEmpleados con diferentes valores de codigo_empleado y salario_actualizado, incluyendo casos donde el salario actualizado sea menor que el salario actual.

DROP TABLE IF EXISTS empleados_salarios;
CREATE TABLE empleados_salarios (
    codigo_empleado VARCHAR(10) PRIMARY KEY,
    salario DECIMAL(10,2)
);

DELIMITER $$

CREATE PROCEDURE ActualizarEmpleados(
    IN codigo_empleado VARCHAR(10),
    IN salario_actualizado DECIMAL(10,2)
)
BEGIN
    DECLARE salario_actual DECIMAL(10,2);

    START TRANSACTION;

    SELECT salario
    INTO salario_actual
    FROM empleados_salarios
    WHERE codigo_empleado = codigo_empleado;

    IF salario_actualizado < salario_actual THEN
       ROLLBACK;
       SIGNAL SQLSTATE '45000' 
       SET MESSAGE_TEXT = 'Error: El salario actualizado es menor al actual. Operación cancelada.';
	ELSE
        UPDATE empleados_salarios
        SET salario = salario_actualizado
        WHERE codigo_empleado = codigo_empleado;

        COMMIT;
        SELECT 'Salario actualizado correctamente.' AS mensaje;
    END IF;
END$$

DELIMITER ;

-- Verificar que el procedimiento funcione correctamente y que se muestren mensajes de error y se realice un rollback cuando corresponda.
CALL ActualizarEmpleados('E001', 50000);
CALL ActualizarEmpleados('E001', 20000);

-- 9 - Gestión de Usuarios

-- a) Usuario sin privilegios
-- Eliminamos primero por si ya existe de una ejecución previa
DROP USER IF EXISTS 'user_sin_priv'@'localhost';
CREATE USER 'user_sin_priv'@'localhost' IDENTIFIED BY '1234';

-- b) Lectura sobre pubs
DROP USER IF EXISTS 'user_read'@'localhost';
CREATE USER 'user_read'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT ON pubs.* TO 'user_read'@'localhost';

-- c) Escritura sobre pubs
DROP USER IF EXISTS 'user_write'@'localhost';
CREATE USER 'user_write'@'localhost' IDENTIFIED BY '1234';
GRANT INSERT, UPDATE, DELETE ON pubs.* TO 'user_write'@'localhost';

-- d) Todos los privilegios
DROP USER IF EXISTS 'user_admin'@'localhost';
CREATE USER 'user_admin'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON pubs.* TO 'user_admin'@'localhost';

-- e) Lectura solo en titles
DROP USER IF EXISTS 'user_titles'@'localhost';
CREATE USER 'user_titles'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT ON pubs.titles TO 'user_titles'@'localhost';

-- f) Eliminar user_admin
DROP USER 'user_admin'@'localhost';

-- g) Eliminar dos usuarios
DROP USER 'user_read'@'localhost', 'user_write'@'localhost';

-- h) Eliminar usuario y privilegios
DROP USER 'user_titles'@'localhost';

-- i) Ver privilegios
SHOW GRANTS FOR 'user_sin_priv'@'localhost';
-- 10 - Mongo DB (Sintaxis de Consola)
/*
use local
show collections

use test
show collections

use baseEjemplo2
show collections

db.usuarios.insertMany([
  { nombre: "Ana", clave: "123" },
  { nombre: "Luis", clave: "abc" }
])
show collections

use pubs
db.clientes.insertMany([
  { _id: 1, nombre: "Cliente A" },
  { _id: 2, nombre: "Cliente B" }
])
db.clientes.insertOne({ _id: 1, nombre: "Cliente C" }) 
db.libros.find()

use blog
db.posts.insertOne({ titulo: "Mi primer post", autor: "Admin", fecha: new Date() })
show dbs
db.posts.drop()
db.dropDatabase()
show dbs
*/


-- 11 - DISEÑO DE BASE DE DATOS: FÁBRICA DE SMART TV (HONG KONG)

/*
a) Entidades relevantes al Sistema:
   1. Modelo_TV (Los productos finales)
   2. Componente (Piezas individuales)
   3. Empleado (Personal de fabricación interna)
   4. Importador (Proveedores externos)
   5. Orden_Compra (Registro de compras al importador)
   6. Hoja_Trabajo (Registro de producción de empleados)
   7. Mapa_Armado (Relación técnica entre modelos y componentes)
*/

/*
b) Atributos de cada entidad:
   - Modelo_TV: id_modelo (PK), nombre_modelo, descripcion.
   - Componente: id_componente (PK), nombre_componente, tipo_origen (comprado/fabricado).
   - Empleado: id_empleado (PK), nombre, especialidad.
   - Importador: id_importador (PK), nombre, pais.
   - Orden_Compra: id_orden (PK), fecha, id_importador (FK).
   - Hoja_Trabajo: id_hoja (PK), fecha, cantidad_fabricada, id_empleado (FK), id_componente (FK).
   - Mapa_Armado: id_modelo (FK), id_componente (FK), ubicacion, orden_montaje.
*/

/* c) Confección del DER (Diagrama Entidad Relación) y Diccionario de Datos:
   - Modelo_TV <-> Componente: Relación N:M (Muchos a Muchos). Un TV tiene entre 275 y 430 componentes. 
     Se resuelve mediante la tabla asociativa 'mapa_armado'.
   - Empleado <-> Componente: Relación N:M. Un empleado se dedica a un tipo de componente, 
     pero un componente puede ser fabricado por varios empleados. Se registra en 'hoja_trabajo'.
   - Importador <-> Orden_Compra: Relación 1:N. Un importador puede tener múltiples órdenes.
*/


/*
d) Implementación de Tablas:
   diccionario de datos abreviado y  codigo en SQL
   
   Tabla         Campo               Tipo        Descripción
   -----------   -----------------   ----------  ---------------------------
   Componente    id_componente       INT (PK)    Identificador único
   Componente    tipo_origen         VARCHAR     'Comprado' o 'Fabricado'
   Hoja_Trabajo  cantidad_fabricada  INT         Cantidad producida por turno
   Mapa_Armado   orden_montaje       INT         Secuencia lógica de ensamble
   */

CREATE TABLE modelo_tv (
    id_modelo INT PRIMARY KEY,
    nombre_modelo VARCHAR(50),
    descripcion VARCHAR(100)
);

CREATE TABLE componente (
    id_componente INT PRIMARY KEY,
    nombre_componente VARCHAR(50),
    tipo_origen VARCHAR(20)
);

CREATE TABLE empleado (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50),
    especialidad VARCHAR(50)
);

CREATE TABLE importador (
    id_importador INT PRIMARY KEY,
    nombre VARCHAR(50),
    pais VARCHAR(50)
);


DROP TABLE IF EXISTS orden_compra;
CREATE TABLE orden_compra (
    id_orden INT PRIMARY KEY,
    fecha DATE,
    id_importador INT,
    FOREIGN KEY (id_importador) REFERENCES importador(id_importador)
);

DROP TABLE IF EXISTS hoja_trabajo;
CREATE TABLE hoja_trabajo (
    id_hoja INT PRIMARY KEY,
    fecha DATE,
    cantidad_fabricada INT,
    id_empleado INT,
    id_componente INT,
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_componente) REFERENCES componente(id_componente)
);

DROP TABLE IF EXISTS mapa_armado;
CREATE TABLE mapa_armado (
    id_modelo INT,
    id_componente INT,
    ubicacion VARCHAR(50),
    orden_montaje INT,
    PRIMARY KEY (id_modelo, id_componente),
    FOREIGN KEY (id_modelo) REFERENCES modelo_tv(id_modelo),
    FOREIGN KEY (id_componente) REFERENCES componente(id_componente)
);

-- e) Crear al menos 2 consultas relacionadas para poder probar la Base de Datos.
-- producción total por empleado 
SELECT e.nombre, SUM(h.cantidad_fabricada) AS total_producido
FROM empleado e
JOIN hoja_trabajo h ON e.id_empleado = h.id_empleado
GROUP BY e.nombre;

-- componentes y orden de armado de un modelo de TV
SELECT m.nombre_modelo, c.nombre_componente, ma.orden_montaje
FROM mapa_armado ma
JOIN modelo_tv m ON ma.id_modelo = m.id_modelo
JOIN componente c ON ma.id_componente = c.id_componente
ORDER BY ma.orden_montaje;
 