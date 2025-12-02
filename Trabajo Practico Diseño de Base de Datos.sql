-- Trabajo Practico Diseño de Base de Datos

create database if not exists ejercicios;

use ejercicios ;


CREATE TABLE TelevisorModelo (
    id_modelo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_modelo VARCHAR(100),
    descripcion TEXT,
    fecha_lanzamiento DATE
);

CREATE TABLE Pieza (
    id_pieza INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    tipo ENUM('importada', 'fabricada'),
    costo_referencia DECIMAL(10,2)
);

--  IMPORTADORES Y COMPRAS 

CREATE TABLE Importador (
    id_importador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    telefono VARCHAR(50)
);

CREATE TABLE FacturaCompra (
    id_factura INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    id_importador INT,
    FOREIGN KEY (id_importador) REFERENCES Importador(id_importador)
);

CREATE TABLE FacturaDetalle (
    id_factura INT,
    id_pieza INT,
    cantidad INT,
    costo_unitario DECIMAL(10,2),
    PRIMARY KEY (id_factura, id_pieza),
    FOREIGN KEY (id_factura) REFERENCES FacturaCompra(id_factura),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id_pieza)
);

--  OPERARIOS Y FABRICACIÓN 

CREATE TABLE Operario (
    id_operario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE HojaConfeccion (
    id_hoja INT PRIMARY KEY AUTO_INCREMENT,
    id_operario INT,
    id_pieza INT,
    fecha DATE,
    cantidad_fabricada INT,
    FOREIGN KEY (id_operario) REFERENCES Operario(id_operario),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id_pieza)
);

--  MAPA DE ARMADO DEL TELEVISOR 

CREATE TABLE MapaArmado (
    id_modelo INT,
    id_pieza INT,
    orden_armado INT,
    ubicacion VARCHAR(100),
    PRIMARY KEY (id_modelo, id_pieza),
    FOREIGN KEY (id_modelo) REFERENCES TelevisorModelo(id_modelo),
    FOREIGN KEY (id_pieza) REFERENCES Pieza(id_pieza)
);

-- INSERCIÓN 

INSERT INTO TelevisorModelo (nombre_modelo, descripcion)
VALUES 
('Modelo A', 'Televisor 50 pulgadas'),
('Modelo B', 'Televisor 65 pulgadas');

INSERT INTO Pieza (nombre, tipo, costo_referencia)
VALUES
('Placa Madre', 'fabricada', 12000),
('Pantalla LED', 'importada', 80000),
('Carcasa', 'fabricada', 5000);
