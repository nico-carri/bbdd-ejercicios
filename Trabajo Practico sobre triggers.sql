-- Trabajo Practico sobre triggers

-- 1. Crear base de datos y tabla

CREATE DATABASE if not exists testDisparador;
USE testDisparador;

CREATE TABLE alumnos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    nota DECIMAL(4,2)
);

-- 2. Trigger BEFORE INSERT

DELIMITER $$

CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.nota < 0 THEN
        SET NEW.nota = 0;
    ELSEIF NEW.nota > 10 THEN
        SET NEW.nota = 10;
    END IF;
END $$

-- 3. Trigger BEFORE UPDATE

CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.nota < 0 THEN
        SET NEW.nota = 0;
    ELSEIF NEW.nota > 10 THEN
        SET NEW.nota = 10;
    END IF;
END $$

DELIMITER ;

-- 4. PRUEBAS DE FUNCIONAMIENTO

-- Caso 1: Insertar una nota negativa -> debe guardarse 0
INSERT INTO alumnos (nombre, apellido, nota) VALUES ('Juan', 'Pérez', -5);

-- Caso 2: Insertar una nota mayor a 10 -> debe guardarse 10
INSERT INTO alumnos (nombre, apellido, nota) VALUES ('María', 'Gómez', 15);

-- Caso 3: Insertar una nota válida → queda igual
INSERT INTO alumnos (nombre, apellido, nota) VALUES ('Pedro', 'López', 7.5);

-- Ver datos luego de los INSERT
SELECT * FROM alumnos;

-- PRUEBAS DE UPDATE
-- Caso 4: Actualizar nota a valor negativo -> debe quedar en 0
UPDATE alumnos SET nota = -20 WHERE id = 3;

-- Caso 5: Actualizar nota a valor mayor a 10 -> debe quedar en 10
UPDATE alumnos SET nota = 90 WHERE id = 1;

-- Caso 6: Actualizar nota válida
UPDATE alumnos SET nota = 8 WHERE id = 2;

-- Ver datos luego de los UPDATE
SELECT * FROM alumnos;
