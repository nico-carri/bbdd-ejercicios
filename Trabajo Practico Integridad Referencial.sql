-- Trabajo Practico Integridad Referencial

CREATE DATABASE editoriales2;
USE editoriales2;

CREATE TABLE editoriales (
    id_editorial INT,
    nombre_editorial VARCHAR(100)
);

CREATE TABLE empleados (
    id_empleado INT,
    nombre_empleado VARCHAR(100),
    id_editorial INT
);

CREATE TABLE libros (
    id_libro INT,
    titulo_libro VARCHAR(150),
    id_editorial INT
);

ALTER TABLE editoriales
ADD PRIMARY KEY (id_editorial);

ALTER TABLE empleados
ADD PRIMARY KEY (id_empleado);

ALTER TABLE libros
ADD PRIMARY KEY (id_libro);


ALTER TABLE empleados
ADD CONSTRAINT fk_empleado_editorial
FOREIGN KEY (id_editorial)
REFERENCES editoriales(id_editorial)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE libros
ADD CONSTRAINT fk_libro_editorial
FOREIGN KEY (id_editorial)
REFERENCES editoriales(id_editorial)
ON DELETE CASCADE ON UPDATE CASCADE;

INSERT INTO editoriales (id_editorial, nombre_editorial)
VALUES
    (1, 'Editorial Planeta'),
    (2, 'Editorial Santillana'),
    (3, 'Editorial Anaya'),
    (4, 'Editorial Alfaguara'),
    (5, 'Editorial SM'),
    (6, 'Editorial Fondo de Cultura Económica'),
    (7, 'Editorial Siglo XXI'),
    (8, 'Editorial Cátedra'),
    (9, 'Editorial Tecnos'),
    (10, 'Editorial Ariel');

INSERT INTO empleados (id_empleado, nombre_empleado, id_editorial)
VALUES
    (1, 'Juan Pérez', 1),
    (2, 'María Rodríguez', 1),
    (3, 'Pedro López', 2),
    (4, 'Ana Martínez', 2),
    (5, 'Carlos García', 3),
    (6, 'Laura González', 3),
    (7, 'Luis Fernández', 4),
    (8, 'Elena Sánchez', 4),
    (9, 'Javier Ruiz', 5),
    (10, 'Sofía Torres', 5);

INSERT INTO libros (id_libro, titulo_libro, id_editorial)
VALUES
    (1, 'Cien años de soledad', 1),
    (2, 'Don Quijote de la Mancha', 1),
    (3, 'La sombra del viento', 2),
    (4, 'Rayuela', 2),
    (5, 'Crónica de una muerte anunciada', 3),
    (6, 'Los detectives salvajes', 3),
    (7, 'Ficciones', 4),
    (8, 'La casa de los espíritus', 4),
    (9, 'La ciudad y los perros', 5),
    (10, 'Cien años de soledad', 5);

-- 1. Eliminar una editorial (se eliminan empleados y libros por CASCADE)
DELETE FROM editoriales WHERE id_editorial = 1;

-- 2. Actualizar el nombre de una editorial (se actualiza en libros y empleados)
UPDATE editoriales
SET nombre_editorial = 'Editorial Planeta Nueva'
WHERE id_editorial = 2;

-- 3. Eliminar un empleado (NO afecta libros, porque libros no depende de empleados)
DELETE FROM empleados WHERE id_empleado = 3;

-- 4. Actualizar el nombre de un empleado (no afecta libros)
UPDATE empleados
SET nombre_empleado = 'Pedro López Nuevo'
WHERE id_empleado = 4;

-- 5. Eliminar un libro (no afecta nada más)
DELETE FROM libros WHERE id_libro = 5;

-- 6. Cambiar editorial de un libro (simple UPDATE)
UPDATE libros
SET id_editorial = 4
WHERE id_libro = 6;

-- 7. Intentar eliminar una editorial con empleados (elimina empleados y libros por CASCADE)
DELETE FROM editoriales WHERE id_editorial = 3;

-- 8. Intentar eliminar un empleado que tiene libros
-- No pasa nada: libros NO depende de empleados
DELETE FROM empleados WHERE id_empleado = 9;

-- 9. Eliminar editorial y todos sus empleados (y libros)
DELETE FROM editoriales WHERE id_editorial = 4;

-- 10. Eliminar editorial y transferir sus empleados a otra
UPDATE empleados
SET id_editorial = 2
WHERE id_editorial = 5;

DELETE FROM editoriales WHERE id_editorial = 5;

