-- Trabajo Práctico Sistema de Usuarios y Permisos

-- 1 - Crear un usuario sin privilegios específicos

CREATE USER 'usuario_sin_priv'@'localhost' IDENTIFIED BY 'Password123!';


-- 2 - Crear un usuario con privilegios de lectura sobre la base pubs

CREATE USER 'usuario_lectura'@'localhost' IDENTIFIED BY 'Password123!';

GRANT SELECT ON pubs.* TO 'usuario_lectura'@'localhost';

-- 3 - Crear un usuario con privilegios de escritura sobre la base pubs

CREATE USER 'usuario_escritura'@'localhost' IDENTIFIED BY 'Password123!';

GRANT INSERT, UPDATE, DELETE ON pubs.* TO 'usuario_escritura'@'localhost';

-- 4 - Crear un usuario con todos los privilegios sobre la base pubs

CREATE USER 'usuario_full'@'localhost' IDENTIFIED BY 'Password123!';

GRANT ALL PRIVILEGES ON pubs.* TO 'usuario_full'@'localhost';

-- 5 - Crear un usuario con privilegios de lectura solo sobre la tabla titles

CREATE USER 'usuario_titles'@'localhost' IDENTIFIED BY 'Password123!';

GRANT SELECT ON pubs.titles TO 'usuario_titles'@'localhost';

-- 6 - Eliminar al usuario que tiene todos los privilegios sobre pubs

DROP USER 'usuario_full'@'localhost';

-- 7 - Eliminar a dos usuarios a la vez

DROP USER 
    'usuario_lectura'@'localhost',
    'usuario_escritura'@'localhost';

-- 8 - Eliminar un usuario y sus privilegios asociados

DROP USER 'usuario_titles'@'localhost';

-- 9 - Revisar los privilegios de un usuario

-- Ver privilegios del usuario_sin_priv
SHOW GRANTS FOR 'usuario_sin_priv'@'localhost';

-- Ver privilegios del usuario_lectura (si no fue eliminado)
SHOW GRANTS FOR 'usuario_lectura'@'localhost';