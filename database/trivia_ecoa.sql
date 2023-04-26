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
    archivada BOOL,
    PRIMARY KEY (clave_pregunta)
);



SELECT * FROM Banco_preguntas_ECOA;

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

# ---------------------------------------------------------------------------------------------------------

# Trigger 4
# Cada vez que un usuario responde una pregunta de ECOA se guarda ese registro en ECOA_temporal y se marca
# esa pregunta como contestada en Progreso_ECOA

# =========================================================================================================

# Store procedures 1
# Cada vez que se activa una encuesta se seleccionan todas las materias que pertenecen a esa encuesta, luego se seleccionan 
# todos los alumnos de cada materia para crear n registros por cada alumno en la tabla Progreso_ECOA donde n es el numero 
# de preguntas de la encuesta

SELECT Encuesta.clave_encuesta, Alumno.alumno_matricula, Materia.nombre_materia_largo FROM Encuesta INNER JOIN materias_de_encuesta ON (Encuesta.clave_encuesta = Materias_de_encuesta.clave_encuesta)
INNER JOIN Materia ON (Materias_de_encuesta.CRN = Materia.CRN)
INNER JOIN Cursa ON (Materia.CRN = Cursa.CRN)
INNER JOIN Alumno ON (Cursa.alumno_matricula = Alumno.alumno_matricula);

# ---------------------------------------------------------------------------------------------------------

# Store procedures 2
# Cada vez que se activa una encuesta se seleccionan las materias que pertenecen a esa encuesta y luego las matriculas
# unicas de los alumnos que estudian esas materias para crear un registro por cada alumno en Elementos_de_partida

# ---------------------------------------------------------------------------------------------------------

# Store procedures 3
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

# Store procedures 4
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

# Store procedures 5
# Este store procedure revisa si hay encuestas disponibles para el alumno, si no hay encuestas disponibles
# entonces devuelve 0 registros
DELIMITER //
CREATE PROCEDURE GetSurvey(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT * FROM Alumno 
	INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
	INNER JOIN Materias_de_encuesta ON (Cursa.CRN = Materias_de_encuesta.CRN)
	INNER JOIN Encuesta ON (Materias_de_encuesta.clave_encuesta = Encuesta.clave_encuesta)
	WHERE Alumno.alumno_matricula = matricula AND Encuesta.activa = 1;
END //
DELIMITER ;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 6
# Este store procedure devuelve una tabla con todas las preguntas dirigidas a un profesor paraa todos los profesores
# que le dan clases al alumno. Se ejecuta en la plantilla que renderiza el juego y es obligatorio este store procedure
DELIMITER //
CREATE PROCEDURE GetTeachersQuestions(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Profesor.profesor_nomina, Profesor.nombre, Banco_preguntas_ECOA.descripcion
	FROM Alumno INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
	INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
	INNER JOIN Imparte ON (Cursa.CRN = Imparte.CRN)
	INNER JOIN Profesor ON (Imparte.profesor_nomina = Profesor.profesor_nomina)
	INNER JOIN Materias_de_encuesta ON (Cursa.CRN = Materias_de_encuesta.CRN)
	INNER JOIN Encuesta ON (Materias_de_encuesta.clave_encuesta = Encuesta.clave_encuesta)
	INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
	INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
	WHERE Alumno.alumno_matricula = matricula AND Banco_preguntas_ECOA.dirigido_a = 'Profesor';
END //
DELIMITER ;

# L00622354
# L00621869
# L00621927
# A00228079

CALL GetTeachersQuestions('A00228079');
DROP PROCEDURE GetTeachersQuestions;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 7
# Este store procedure devuelve una tabla con todas las preguntas dirigidas a una materia paraa todas las materias
# que estudia el alumno. Se ejecuta en la plantilla que renderiza el juego solamente si el alumno cursa al 
# menos una 'Materia'
DELIMITER //
CREATE PROCEDURE GetTeachersQuestions(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Profesor.profesor_nomina, Profesor.nombre, Banco_preguntas_ECOA.descripcion
	FROM Alumno INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
	INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
	INNER JOIN Imparte ON (Cursa.CRN = Imparte.CRN)
	INNER JOIN Profesor ON (Imparte.profesor_nomina = Profesor.profesor_nomina)
	INNER JOIN Materias_de_encuesta ON (Cursa.CRN = Materias_de_encuesta.CRN)
	INNER JOIN Encuesta ON (Materias_de_encuesta.clave_encuesta = Encuesta.clave_encuesta)
	INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
	INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
	WHERE Alumno.alumno_matricula = matricula AND Banco_preguntas_ECOA.dirigido_a = 'Profesor';
END //
DELIMITER ;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 8
# Este store procedure devuelve una tabla con todas las preguntas dirigidas a un bloque o concentracion a todas
# las UdF de este tipo que estudia el alumno. Se ejecuta en la plantilla que renderiza el juego solamente si el 
# alumno cursa al menos un 'Bloque' o 'Concentracion'

# =========================================================================================================


# Otros querys 1
# Cada vez que termina el periodo de ECOAS se eliminan todos los registros de ECOA_temporal y de Elementos_de_partida


SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
GROUP BY Materia.nombre_materia_largo
HAVING count(Cursa.alumno_matricula) < 25;

SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Materia.nombre_materia_largo = 'Análisis de circuitos eléctricos de corriente alterna';

SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF FROM Cursa INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Cursa.alumno_matricula = 'A00228208';

# Este query devuelve las materias que estudian todos los alumnos que estudian la materia ingresada
# La clausula IN devuelve todos los registros de una tabla o subconsulta que se encuentran en la 
# columna adentro de la clausula. Es importante que adentro de la clausula IN solo se devuelva
# una coluna
SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN FROM Cursa
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
WHERE Cursa.alumno_matricula IN (
	SELECT Cursa.alumno_matricula FROM Cursa INNER JOIN Materia M ON Cursa.CRN = M.CRN WHERE M.nombre_materia_largo = 'Aplicación de la teoría electromagnética'
) ORDER BY Cursa.alumno_matricula;

SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN, count(*) AS total_alumnos FROM Cursa
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
SELECT * FROM Materia;
SELECT * FROM Usuario WHERE id_usuario = "A00226903" AND contrasenia = "A00226903";
SELECT * FROM Usuario WHERE ocupacion = "ProfesorColaborador";
SELECT * FROM ProfesorColaborador;
UPDATE Usuario SET ocupacion = 'ProfesorColaborador' WHERE ocupacion = 'Profesor Colaborador';

insert into Encuesta(clave_encuesta, descripcion, fecha_inicio, fecha_final, periodo_de_activacion, activa) values ("s1", "encuesta1", "2023-04-25", "2023-04-30", "p1", 0);
insert into Encuesta(clave_encuesta, descripcion, periodo_de_activacion, activa) values ("s2", "encuesta2", "p2", 0);

insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta1", "El profesor(a) muestra dominio y experiencia en los temas de la Materia:", "Profesor", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta2", "Los temas, las actividades y el reto durante el Bloque:A) Me permitieron aprender y desarrollarme.", "Bloque", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta3", "Los temas, las actividades y la situación-problema durante la Materia:A) Me permitieron aprender y desarrollarme.", "Materia", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta4", "El profesor(a) promovió un ambiente de confianza y de respeto:", "Profesor", "Cerrada");

insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta1");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta2");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta3");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta4");

insert into Materias_de_encuesta(clave_encuesta, CRN) values("s1", 31696);
insert into Materias_de_encuesta(clave_encuesta, CRN) values("s1", 41765);

SELECT * FROM Banco_preguntas_ECOA;
SELECT * FROM Materias_de_encuesta;
SELECT * FROM Preguntas_de_encuesta;
SELECT * FROM Encuesta;
SELECT * FROM Materia WHERE CRN = 32701;
SET @matricula = 'A00228079'; 
# Alumnos con encuesta en todas sus materias (2 encuestas) A00228187 A00228208 A00229540 A00228079
# Alumno que estudia las mismas materias pero diferentes grupos (0 encuestas) A00234284
# Alumno que estudia una materia que no aplica encuesta (0 encuestas) A01620861
# Alumno que estudia 3 materias al mismo tiempo pero solo tieneencuesta de 2 materias: A00230099

CALL GetSurvey('A00230099'); 

# "Aplicación de la teoría electromagnética"	41765	L00621869	L00621927
# "Análisis de circuitos eléctricos de corriente alterna"	31696	L00622354

# obteniendo todas las materias que estudia el alumno
SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Cursa.CRN FROM Alumno
INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula) 
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Alumno.alumno_matricula = @matricula;

# obteniendo todos los profesores que imparten una materia
SELECT * FROM Materia 
INNER JOIN Imparte ON (Materia.CRN = Imparte.CRN)
INNER JOIN Profesor ON (Imparte.profesor_nomina = Profesor.profesor_nomina)
WHERE Materia.CRN = 41765;

# obteniendo todas las preguntas de la encuesta por materia
SELECT * FROM Alumno 
INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
INNER JOIN Materias_de_encuesta ON (Cursa.CRN = Materias_de_encuesta.CRN)
INNER JOIN Preguntas_de_encuesta ON (Materias_de_encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
WHERE Alumno.alumno_matricula = @matricula;