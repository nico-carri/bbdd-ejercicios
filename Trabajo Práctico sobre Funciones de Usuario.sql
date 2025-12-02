-- Trabajo Práctico sobre Funciones de Usuario
CREATE DATABASE tp_funciones;
USE tp_funciones;

CREATE TABLE autores (
    autor_id INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100)
);

CREATE TABLE libros (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(255),
    tipo VARCHAR(100),
    precio DECIMAL(10,2),
    id_editorial INT
);

CREATE TABLE autores_libros (
    autor_id INT,
    libro_id INT,
    porcentaje DECIMAL(5,2),
    ventas INT,
    precio DECIMAL(10,2),
    FOREIGN KEY (autor_id) REFERENCES autores(autor_id),
    FOREIGN KEY (libro_id) REFERENCES libros(id_libro)
);

CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libro_id INT,
    cantidad INT,
    FOREIGN KEY (libro_id) REFERENCES libros(id_libro)
);

CREATE TABLE empleados (
    codigo VARCHAR(10) PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100)
);

CREATE TABLE editoriales (
    id_editorial INT PRIMARY KEY,
    nombre_editorial VARCHAR(255)
);

-- Autores
INSERT INTO autores VALUES
(1,'Gabriel','García Márquez'),
(2,'Julio','Cortázar'),
(3,'J.K.','Rowling');

-- Editoriales
INSERT INTO editoriales VALUES
(1,'Planeta'),
(2,'Alfaguara'),
(3,'Salamandra');

-- Libros
INSERT INTO libros VALUES
(1,'Cien años de soledad','Novela',2500,1),
(2,'Rayuela','Novela',2300,2),
(3,'Harry Potter y la piedra filosofal','Fantasia',3000,3),
(4,'Final del juego','Cuento',1800,2);

-- Autores – Libros – Regalías
INSERT INTO autores_libros VALUES
(1,1,10,500,2500),
(2,2,12,300,2300),
(3,3,15,1000,3000),
(2,4,8,150,1800);

-- Ventas por libro
INSERT INTO ventas (libro_id, cantidad) VALUES
(1, 40),
(2, 30),
(3, 100),
(4, 20);

-- Empleados
INSERT INTO empleados VALUES
('E001','Juan','López'),
('E002','María','Gómez'),
('E003','Carlos','Pérez');

-- Ejercicio 1: Crear una función para calcular la regalía total de cada autor.

DELIMITER //
CREATE FUNCTION RegalíaTotal(autor INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM((ventas * precio) * (porcentaje / 100))
    INTO total
    FROM autores_libros
    WHERE autor_id = autor;

    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- Ejercicio 2: Crear una función para obtener el precio máximo de cada tipo de libro.

DELIMITER //
CREATE FUNCTION PrecioMaximoPorTipo(tipo_libro VARCHAR(50))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE precio_max DECIMAL(10,2);

    SELECT MAX(precio)
    INTO precio_max
    FROM libros
    WHERE tipo = tipo_libro;

    RETURN IFNULL(precio_max, 0);
END //
DELIMITER ;

-- Ejercicio 3: Crear una función para calcular el ingreso (cantidad vendida multiplicada por el precio) de cada título.
 
 DELIMITER //
CREATE FUNCTION IngresoPorTitulo(id_lib INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE ingreso DECIMAL(10,2);

    SELECT SUM(v.cantidad * l.precio)
    INTO ingreso
    FROM ventas v
    JOIN libros l ON l.id_libro = v.libro_id
    WHERE v.libro_id = id_lib;

    RETURN IFNULL(ingreso, 0);
END //
DELIMITER ;
 
-- Ejercicio 4: Crear una función para obtener el nombre completo de un empleado a partir de su código.

DELIMITER //
CREATE FUNCTION NombreCompleto(cod VARCHAR(10))
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE nombre VARCHAR(100);
    DECLARE apellido VARCHAR(100);

    SELECT e.nombre, e.apellido
    INTO nombre, apellido
    FROM empleados e
    WHERE e.codigo = cod;

    RETURN CONCAT(nombre, ' ', apellido);
END //
DELIMITER ;

-- Ejercicio 5: Crear una función para calcular el precio promedio de libros publicados de cada editorial.

DELIMITER //
CREATE FUNCTION PrecioPromedioEditorial(editorial INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT AVG(precio)
    INTO promedio
    FROM libros
    WHERE id_editorial = editorial;

    RETURN IFNULL(promedio, 0);
END //
DELIMITER ;
