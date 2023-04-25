CREATE TABLE Usuario(
	id_usuario VARCHAR(9),
    ocupacion VARCHAR(22),
    contrasenia VARCHAR(30),
    PRIMARY KEY (id_usuario)
);

CREATE TABLE Alumno(
	alumno_matricula VARCHAR(9),
    nombre VARCHAR(50),
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Materia(
	CRN INT NOT NULL,
    nombre_materia_largo VARCHAR(150),
    clave_materia VARCHAR(10),
    clave_ejercicio_academico INT NOT NULL,
    tipodeUdF VARCHAR(30),
    campus VARCHAR(50),
    PRIMARY KEY (CRN)
);

CREATE TABLE Profesor(
	profesor_nomina VARCHAR(9),
    nombre VARCHAR(50),
    FOREIGN KEY (profesor_nomina) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Colaborador(
	colaborador_nomina VARCHAR(9),
    nombre VARCHAR(50),
    FOREIGN KEY (colaborador_nomina) REFERENCES Usuario(id_usuario)
);

CREATE TABLE ProfesorColaborador(
	profesor_nomina VARCHAR(9),
    colaborador_nomina VARCHAR(9),
    FOREIGN KEY (profesor_nomina) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (colaborador_nomina) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Cursa(
	alumno_matricula VARCHAR(9),
    CRN INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN)
);

CREATE TABLE Imparte(
	profesor_nomina VARCHAR(9),
    CRN INT NOT NULL,
    FOREIGN KEY (profesor_nomina) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN)
);

CREATE TABLE Premio(
	id_premio INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(50),
    descripcion VARCHAR(300),
    nombre_tienda VARCHAR(50),
    PRIMARY KEY (id_premio)
);

CREATE TABLE Ganar(
	id_recompensa INT NOT NULL AUTO_INCREMENT,
	id_premio INT NOT NULL,
    alumno_matricula VARCHAR(9),
    codigo VARCHAR(30),
    canjeado BOOL, 
    fecha_expiracion DATE,
    PRIMARY KEY (id_recompensa),
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio),
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Perfil_juego(
	alumno_matricula VARCHAR(9),
    balance_monedas INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Banco_preguntas_ECOA(
	clave_pregunta VARCHAR(10),
    descripcion VARCHAR(200),
    dirigido_a VARCHAR(13),
    tipo VARCHAR(7),
    PRIMARY KEY (clave_pregunta)
);

CREATE TABLE Encuesta(
	clave_encuesta VARCHAR(10),
    descripcion VARCHAR(150),
    fecha_inicio DATE,
    fecha_final DATE,
    periodo_de_activacion VARCHAR(50),
    activa BOOL,
    PRIMARY KEY (clave_encuesta)
);

CREATE TABLE Preguntas_de_encuesta(
	clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE Materias_de_encuesta(
	clave_encuesta VARCHAR(10),
    CRN INT NOT NULL,
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN)
);

CREATE TABLE Progreso_ECOA(
	alumno_matricula VARCHAR(9),
    clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE ECOA_temporal(
    alumno_matricula VARCHAR(9),
    clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    respuesta VARCHAR(3000),
    CRN INT NOT NULL,
    profesor_nomina VARCHAR(9),
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN),
    FOREIGN KEY (profesor_nomina) REFERENCES Usuario(id_usuario)
);

CREATE TABLE ECOA_definitiva(
	folio INT NOT NULL AUTO_INCREMENT,
    clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    respuesta VARCHAR(3000),
    CRN INT NOT NULL,
    profesor_nomina VARCHAR(9),
    PRIMARY KEY (folio),
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN),
    FOREIGN KEY (profesor_nomina) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Pregunta_trivia(
	id_pregunta_trivia INT NOT NULL AUTO_INCREMENT,
    descripcion VARCHAR(250),
    respuesta VARCHAR(200),
    inciso_1 VARCHAR(200),
    inciso_2 VARCHAR(200),
    inciso_3 VARCHAR(200),
    PRIMARY KEY (id_pregunta_trivia)
);

CREATE TABLE Progreso_trivia(
	id_pregunta_trivia INT NOT NULL,
    alumno_matricula VARCHAR(9),
    estado VARCHAR(10),
    FOREIGN KEY (id_pregunta_trivia) REFERENCES Pregunta_trivia(id_pregunta_trivia),
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Elementos_de_partida(
	alumno_matricula VARCHAR(9),
    puntos INT NOT NULL,
    ronda INT NOT NULL,
    partida_pendiente BOOL,
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE ArchivoCSV (
    id_usuario VARCHAR(9),
    ocupacion VARCHAR(22),
    contrasenia VARCHAR(30),
    nombre VARCHAR(50)
);

# =========================================================================================================

# Trigger 1
# Primero los datos se insertan en la tabla ArchivoCSV con todas las columnas y el trigger 1 debe insertar automaticamente los datos
# en la tabla Usuario mientras que el trigger 2 debe insertar en las demas tablas los datos que van ingresando en la tabla Usuario
show triggers;
DELIMITER //
CREATE TRIGGER insertar_datos_CSV AFTER INSERT ON ArchivoCSV
FOR EACH ROW
BEGIN
	INSERT INTO Usuario(id_usuario, ocupacion, contrasenia) VALUES(NEW.id_usuario, NEW.ocupacion, NEW.contrasenia);
END//
DELIMITER ;
# ---------------------------------------------------------------------------------------------------------

# Trigger 2
# Al insertar un nuevo dato en la tabla Usuario también se debe insertar en la tabla correspondiente (Alumno, Profesor, Colaborador 
# o ProfesorColaborador) dependiendo de la ocupacion del usuario, aparte de que la tabla Usuario usa atributos que las demas tablas
# no usan y viceversa. Para resolverlo hay que seugir los siguientes pasos:
# 1. Crear el trigger para redireccionar los registros dependiendo de la ocupacion de cada usuario
DELIMITER //
CREATE TRIGGER insertar_datos_de_usuario AFTER INSERT ON Usuario
FOR EACH ROW
BEGIN
    IF NEW.ocupacion = 'Alumno' THEN
        INSERT INTO Alumno (alumno_matricula, nombre)
        SELECT id_usuario, nombre
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
    ELSEIF NEW.ocupacion = 'Profesor' THEN
        INSERT INTO Profesor (profesor_nomina, nombre)
        SELECT id_usuario, nombre
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
    ELSEIF NEW.ocupacion = 'Colaborador' THEN
        INSERT INTO Colaborador (colaborador_nomina, nombre)
        SELECT id_usuario, nombre
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
    ELSEIF NEW.ocupacion = 'ProfesorColaborador' THEN
        INSERT INTO Profesor (profesor_nomina, nombre)
        SELECT id_usuario, nombre
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
        INSERT INTO Colaborador (colaborador_nomina, nombre)
        SELECT id_usuario, nombre
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
        INSERT INTO ProfesorColaborador (profesor_nomina, colaborador_nomina)
        SELECT id_usuario, id_usuario
        FROM ArchivoCSV
        WHERE ArchivoCSV.id_usuario = NEW.id_usuario;
    END IF;
END//
DELIMITER ;

# ---------------------------------------------------------------------------------------------------------

# Trigger 3
# Cada vez que se inserta un nuevo alumno también se debe crear su perfil de juego con su balance de monedas en 0

DELIMITER //
CREATE TRIGGER crear_perfil_de_juego AFTER INSERT ON Alumno
FOR EACH ROW
BEGIN
	INSERT INTO Perfil_juego (alumno_matricula, balance_monedas) VALUES (NEW.alumno_matricula, 0);
END//
DELIMITER ;

# =========================================================================================================

# Store procedures 1
# Cuando el usuario termina de responder todas las preguntas de una encuesta sus registros de la tabla de ECOA_temporal
# pasan a la tabla ECOA_definitiva generando el folio y eliminando los registros de ese usuario en ECOA_temporal
DELIMITER //
CREATE PROCEDURE mover_respuestas_ECOA(
IN matricula VARCHAR(9))
BEGIN
	INSERT INTO ECOA_definitiva (clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina)
    SELECT (clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) FROM ECOA_temporal
    WHERE ECOA_temporal.alumno_matricula = matricula;
    DELETE FROM ECOA_temporal WHERE ECOA_temporal.alumno = matricula;
END//
DELIMITER ;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 2
# Cuando el usuario termina cualquier ronda de juego se eliminan sus registros de la tabla Progreso_trivia y se reinician
# sus registros de la tabla Elementos_de_partida
DELIMITER //
CREATE PROCEDURE borrar_registros_de_juego(
IN matricula VARCHAR(9))
BEGIN
	DELETE FROM Progreso_trivia WHERE Progreso_trivia.alumno_matricula = matricula;
    UPDATE Elementos_de_partida SET puntos=0, ronda=2, partida_pendiente=0
    WHERE Elementos_de_partida.alumno_matricula = matricula;
END//
DELIMITER ;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 3
# Cada vez que se activa una encuesta se seleccionan todas las materias que pertenecen a esa encuesta, luego se seleccionan 
# todos los alumnos de cada materia para crear un perfil de cada alumno en Elementos_de_partida y tambien para crear n 
# registros por cada alumno en la tabla Progreso_ECOA donde n es el numero de preguntas de la encuesta

SELECT Encuesta.clave_encuesta, Alumno.alumno_matricula, Materia.nombre_materia_largo FROM Encuesta INNER JOIN materias_de_encuesta ON (Encuesta.clave_encuesta = Materias_de_encuesta.clave_encuesta)
INNER JOIN Materia ON (Materias_de_encuesta.CRN = Materia.CRN)
INNER JOIN Cursa ON (Materia.CRN = Cursa.CRN)
INNER JOIN Alumno ON (Cursa.alumno_matricula = Alumno.alumno_matricula);
# =========================================================================================================

# Otros querys 1
# Cada vez que un usuario responde una pregunta de ECOA se guarda ese registro en ECOA_temporal

# Otros querys 2
# Cada vez que termina el periodo de ECOAS se eliminan todos los registros de ECOA_temporal y de Elementos_de_partida


SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
GROUP BY Materia.nombre_materia_largo
HAVING count(Cursa.alumno_matricula) < 25;

# Aplicación de la teoría electromagnética
# Análisis de circuitos eléctricos de corriente alterna
# Análisis de esfuerzos y deformaciones

SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Materia.nombre_materia_largo = 'Análisis de circuitos eléctricos de corriente alterna';

SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Cursa.alumno_matricula = 'A00228150';

# Alumnos de 'Herramientas básicas para la modelación de situaciones reales' (materia)
# A00237794 2 materias y 1 bloque
# A00238449 1 materia
# A00240159 1 materia
# A00240830 1 materia
# A00242322 1 materia
# A00242809 1 materia 

# Este query devuelve las materias que estudian todos los alumnos que estudian la materia ingresada
# La clausula IN devuelve todos los registros de una tabla o subconsulta que se encuentran en la 
# columna adentro de la clausula. Es importante que adentro de la clausula IN solo se devuelva
# una coluna
SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
WHERE Cursa.alumno_matricula IN (
	SELECT Cursa.alumno_matricula FROM Cursa INNER JOIN Materia M ON Cursa.CRN = M.CRN WHERE M.nombre_materia_largo = 'Aplicación de la teoría electromagnética'
) ORDER BY Cursa.alumno_matricula;

SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, count(*) AS total_alumnos FROM Cursa
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
WHERE Cursa.alumno_matricula IN (
	SELECT Cursa.alumno_matricula FROM Cursa INNER JOIN Materia M ON Cursa.CRN = M.CRN WHERE M.nombre_materia_largo = 'Aplicación de la teoría electromagnética'
) GROUP BY Materia.nombre_materia_largo;


SET SQL_SAFE_UPDATES = 0;
DELETE FROM ArchivoCSV;

SELECT * FROM Usuario;

SELECT * FROM Alumno;
SELECT * FROM Profesor;
SELECT * FROM Colaborador;
SELECT * FROM Usuario WHERE id_usuario = "A00226903" AND contrasenia = "A00226903";
SELECT * FROM Usuario WHERE ocupacion = "ProfesorColaborador";
SELECT * FROM ProfesorColaborador;
UPDATE Usuario SET ocupacion = 'ProfesorColaborador' WHERE ocupacion = 'Profesor Colaborador';