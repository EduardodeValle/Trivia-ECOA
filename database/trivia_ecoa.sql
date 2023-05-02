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
    activa BOOL DEFAULT 0,
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

CREATE TABLE Progreso_ECOA(
	alumno_matricula VARCHAR(9),
    clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    contestado BOOL,
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (clave_encuesta) REFERENCES Encuesta(clave_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE ECOA_temporal(
    alumno_matricula VARCHAR(9),
    clave_encuesta VARCHAR(10),
    clave_pregunta VARCHAR(10),
    respuesta VARCHAR(3000),
    CRN INT,
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
    CRN INT,
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

CREATE TABLE Elementos_de_partida(
	alumno_matricula VARCHAR(9),
    puntos INT NOT NULL,
    ronda INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Usuario(id_usuario)
);

CREATE TABLE ArchivoCSV (
    id_usuario VARCHAR(9),
    ocupacion VARCHAR(22),
    contrasenia VARCHAR(30),
    nombre VARCHAR(50)
);

# =========================================================================================================
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
# =========================================================================================================

# Store procedures 1
# Cada vez que se activa una encuesta se seleccionan todas las materias activas que reciben la encuesta y 
# luego a todos los alumnos unicos que estudian esas materias, luego se ejecuta el producto cartesiano para 
# aplicar todas las preguntas de la encuesta a todos los alumnos y ademas se crea un perfil de juego en 
# Elementos_de_partida para cada alumno que recibe una encuesta
DELIMITER //
CREATE PROCEDURE setProgresoECOA()
BEGIN
	INSERT INTO Progreso_ECOA (alumno_matricula, clave_encuesta, clave_pregunta, contestado)
	SELECT usuarios_unicos.alumno_matricula, preguntas_de_encuesta.clave_encuesta, preguntas_de_encuesta.clave_pregunta, 0
	FROM (
			SELECT DISTINCT(Cursa.alumno_matricula)
			FROM Materia 
			INNER JOIN Cursa ON (Materia.CRN = Cursa.CRN)
			WHERE Materia.activa = 1
		 ) AS usuarios_unicos
	CROSS JOIN
		 (
			SELECT Encuesta.clave_encuesta, Banco_preguntas_ECOA.clave_pregunta
			FROM Encuesta
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
			WHERE Encuesta.activa = 1
		 ) AS preguntas_de_encuesta;

	# Creando los perfiles de partida para cada alumno que recibe una encuesta
	INSERT INTO Elementos_de_partida (alumno_matricula, puntos, ronda)
	SELECT alumno_matricula, 0, 1
	FROM (
			SELECT DISTINCT(Cursa.alumno_matricula)
			FROM Materia
			INNER JOIN Cursa ON (Materia.CRN = Cursa.CRN)
			WHERE Materia.activa = 1
		 ) AS usuarios_unicos;
END //
DELIMITER ;

TRUNCATE TABLE Progreso_ECOA;
TRUNCATE TABLE Elementos_de_partida;
DROP PROCEDURE setProgresoECOA;
CALL setProgresoECOA();
           
SELECT * FROM Progreso_ECOA;
SELECT * FROM Elementos_de_partida;
# ---------------------------------------------------------------------------------------------------------

# Store procedures 2
# Cuando el usuario termina de responder todas las preguntas de una encuesta sus registros de la tabla de ECOA_temporal
# pasan a la tabla ECOA_definitiva generando el folio y eliminando los registros de ese usuario en ECOA_temporal,
# tambien se actualiza el tipo de ronda y se guardan los puntos ganados en su cuenta
DELIMITER //
CREATE PROCEDURE moveECOA_answers(
	IN matricula VARCHAR(9),
	IN puntos INT)
BEGIN
	INSERT INTO ECOA_definitiva (clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina)
    SELECT clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina FROM ECOA_temporal
    WHERE ECOA_temporal.alumno_matricula = matricula;
    DELETE FROM ECOA_temporal WHERE ECOA_temporal.alumno_matricula = matricula;
    UPDATE Elementos_de_partida SET puntos=0, ronda=2
    WHERE Elementos_de_partida.alumno_matricula = matricula;
    UPDATE Perfil_juego SET balance_monedas=puntos
    WHERE alumno_matricula = matricula;
END//
DELIMITER ;

DROP PROCEDURE moveECOA_answers;
CALL moveECOA_answers('A00230117', 100);

SELECT * FROM ECOA_temporal;
SELECT * FROM ECOA_definitiva;
SELECT * FROM Elementos_de_partida WHERE alumno_matricula = 'A00230117'; # puntos = 0; ronda = 1
SELECT * FROM Perfil_juego WHERE alumno_matricula = 'A00230117'; # balance_monedas = 0

SELECT * FROM Elementos_de_partida;
SELECT * FROM Perfil_juego;

UPDATE Elementos_de_partida SET ronda = 1 WHERE alumno_matricula = 'A00230117';
UPDATE Perfil_juego SET balance_monedas = 0 WHERE alumno_matricula = 'A00230117';
# ---------------------------------------------------------------------------------------------------------

# Store procedures 3
# Este store procedure revisa si hay encuestas disponibles para el alumno por materia, si no hay encuestas 
# disponibles entonces devuelve 0 registros
DELIMITER //
CREATE PROCEDURE getSurvey(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Materia.CRN 
    FROM Alumno 
	INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
    INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
	WHERE Alumno.alumno_matricula = matricula AND Materia.activa = 1;
END //
DELIMITER ;

CALL getSurvey('A00228079');

DROP PROCEDURE getSurvey;

# ---------------------------------------------------------------------------------------------------------

# Store procedures 4
# Este store procedure devuelve una tabla con todas las preguntas no respondidas dirigidas a un profesor para todos 
# los profesores que le dan clases al alumno. Se ejecuta en la plantilla que renderiza el juego y es obligatorio este 
# store procedure. El primer subquery obtiene todas las preguntas de encuesta para los profesores, el segundo obtiene 
# las preguntas ya respondidas y se hace un left join para devolver unicamente las preguntas no respondidas
DELIMITER //
CREATE PROCEDURE getTeachersQuestions(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT profesores_por_materia.alumno_matricula, profesores_por_materia.nombre_materia_largo, profesores_por_materia.CRN, profesores_por_materia.profesor_nomina, preguntas_profesores.clave_encuesta, preguntas_profesores.clave_pregunta,  preguntas_profesores.descripcion
	FROM (
			SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Materia.CRN, Profesor.profesor_nomina
			FROM Alumno
			INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
			INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
			INNER JOIN Imparte ON (Materia.CRN = Imparte.CRN)
			INNER JOIN Profesor ON (Imparte.profesor_nomina = Profesor.profesor_nomina)
			WHERE Alumno.alumno_matricula = matricula AND Materia.activa = 1 ) AS profesores_por_materia
	CROSS JOIN (
			SELECT Encuesta.clave_encuesta, Banco_preguntas_ECOA.clave_pregunta, Banco_preguntas_ECOA.descripcion
			FROM Encuesta 
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
			WHERE Encuesta.activa = 1 AND Banco_preguntas_ECOA.dirigido_a = 'Profesor' ) AS preguntas_profesores
	LEFT JOIN (
			SELECT ECOA_temporal.clave_encuesta, ECOA_temporal.clave_pregunta, ECOA_temporal.alumno_matricula, ECOA_temporal.CRN, ECOA_temporal.profesor_nomina
			FROM Encuesta
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN ECOA_temporal ON (Preguntas_de_encuesta.clave_pregunta = ECOA_temporal.clave_pregunta)
			WHERE Encuesta.activa = 1) AS respuestas_temporales
	ON (profesores_por_materia.alumno_matricula = respuestas_temporales.alumno_matricula AND preguntas_profesores.clave_encuesta = respuestas_temporales.clave_encuesta AND preguntas_profesores.clave_pregunta = respuestas_temporales.clave_pregunta AND profesores_por_materia.profesor_nomina = respuestas_temporales.profesor_nomina)
	WHERE respuestas_temporales.clave_encuesta IS NULL
	ORDER BY profesores_por_materia.profesor_nomina;
END //
DELIMITER ;

# L00622354
# L00621869
# L00621927
# A00228079
# A00228187
# A00229540
# A00230117

DROP PROCEDURE getTeachersQuestions;
CALL getTeachersQuestions('A00230117');

SELECT * FROM Preguntas_de_encuesta;
SELECT * FROM ECOA_temporal;
    
# ---------------------------------------------------------------------------------------------------------

# Store procedures 5
# Este store procedure devuelve una tabla con todas las preguntas dirigidas a una materia para todas las materias
# que estudia el alumno. Se ejecuta en la plantilla que renderiza el juego. No hace falta comprobar si el alumno
# lleva materias o bloques, puesto que en el peor de los casos requeriria 3 stores procedures (uno para comprobarlo
# otro para traer las materias y otro para traer los bloques) mientras que ejecutar este y el store procedure para
# traer los bloques seria como maximo en el peor de los casos 2 stores procedures
DELIMITER //
CREATE PROCEDURE getSubjectsQuestions(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT materias_unicas.alumno_matricula, materias_unicas.nombre_materia_largo, materias_unicas.CRN, preguntas_materias.clave_encuesta, preguntas_materias.clave_pregunta,  preguntas_materias.descripcion
	FROM (
			SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Materia.CRN
			FROM Alumno
			INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
			INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
			WHERE Alumno.alumno_matricula = matricula AND Materia.tipodeUdF = 'Materia' AND Materia.activa = 1 ) AS materias_unicas
	CROSS JOIN (
			SELECT Encuesta.clave_encuesta, Banco_preguntas_ECOA.clave_pregunta, Banco_preguntas_ECOA.descripcion
			FROM Encuesta 
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
			WHERE Encuesta.activa = 1 AND Banco_preguntas_ECOA.dirigido_a = 'Materia' ) AS preguntas_materias
	LEFT JOIN (
			SELECT ECOA_temporal.clave_encuesta, ECOA_temporal.clave_pregunta, ECOA_temporal.alumno_matricula, ECOA_temporal.CRN, ECOA_temporal.profesor_nomina, ECOA_temporal.respuesta
			FROM Encuesta
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN ECOA_temporal ON (Preguntas_de_encuesta.clave_pregunta = ECOA_temporal.clave_pregunta)
			WHERE Encuesta.activa = 1) AS respuestas_temporales
	ON (materias_unicas.alumno_matricula = respuestas_temporales.alumno_matricula AND preguntas_materias.clave_encuesta = respuestas_temporales.clave_encuesta AND preguntas_materias.clave_pregunta = respuestas_temporales.clave_pregunta AND materias_unicas.CRN = respuestas_temporales.CRN)
	WHERE respuestas_temporales.clave_encuesta IS NULL
	ORDER BY materias_unicas.CRN;
END //
DELIMITER ;

# L00622354
# L00621869
# L00621927
# A00228079
# A00228187
# A00229540
# A00230117

DROP PROCEDURE getSubjectsQuestions;
CALL getSubjectsQuestions('A00230117');

# ---------------------------------------------------------------------------------------------------------

# Store procedures 6
# Este store procedure devuelve una tabla con todas las preguntas dirigidas a un bloque o concentracion a todas
# las UdF de este tipo que estudia el alumno. Se ejecuta en la plantilla que renderiza el juego solamente si el 
# alumno cursa al menos un 'Bloque' o 'Concentracion'. No hace falta comprobar si el alumno lleva materias o bloques, 
# puesto que en el peor de los casos requeriria 3 stores procedures (uno para comprobarlo otro para traer las materias 
# y otro para traer los bloques) mientras que ejecutar este y el store procedure para traer las materias seria como 
# maximo en el peor de los casos 2 stores procedures.
DELIMITER //
CREATE PROCEDURE getCoreSubjectsQuestions(
	IN matricula VARCHAR(9))
BEGIN 
	SELECT materias_unicas.alumno_matricula, materias_unicas.nombre_materia_largo, materias_unicas.CRN, preguntas_materias.clave_encuesta, preguntas_materias.clave_pregunta,  preguntas_materias.descripcion
	FROM (
			SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Materia.CRN
			FROM Alumno
			INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula)
			INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
			WHERE Alumno.alumno_matricula = matricula AND (Materia.tipodeUdF = 'Bloque' OR Materia.tipodeUdF = 'Concentración') AND Materia.activa = 1 ) AS materias_unicas
	CROSS JOIN (
			SELECT Encuesta.clave_encuesta, Banco_preguntas_ECOA.clave_pregunta, Banco_preguntas_ECOA.descripcion
			FROM Encuesta 
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta)
			WHERE Encuesta.activa = 1 AND (Banco_preguntas_ECOA.dirigido_a = 'Bloque' OR Banco_preguntas_ECOA.dirigido_a = 'Concentración') ) AS preguntas_materias
	LEFT JOIN (
			SELECT ECOA_temporal.clave_encuesta, ECOA_temporal.clave_pregunta, ECOA_temporal.alumno_matricula, ECOA_temporal.CRN, ECOA_temporal.profesor_nomina
			FROM Encuesta
			INNER JOIN Preguntas_de_encuesta ON (Encuesta.clave_encuesta = Preguntas_de_encuesta.clave_encuesta)
			INNER JOIN ECOA_temporal ON (Preguntas_de_encuesta.clave_pregunta = ECOA_temporal.clave_pregunta)
			WHERE Encuesta.activa = 1) AS respuestas_temporales
	ON (materias_unicas.alumno_matricula = respuestas_temporales.alumno_matricula AND preguntas_materias.clave_encuesta = respuestas_temporales.clave_encuesta AND preguntas_materias.clave_pregunta = respuestas_temporales.clave_pregunta AND materias_unicas.CRN = respuestas_temporales.CRN)
	WHERE respuestas_temporales.clave_encuesta IS NULL
	ORDER BY materias_unicas.CRN;
END //
DELIMITER ;

# L00622354
# L00621869
# L00621927
# A00228079
# A00228187
# A00229540
# A00230117

CALL getCoreSubjectsQuestions('A00229540');

# ---------------------------------------------------------------------------------------------------------

# Store procedure 7
# Cada vez que termina el periodo de una encuesta se eliminan todos los registros de las tablas 
# ECOA_temporal, Progreso_ECOA y Elementos_de_partida, se desactivan todas las materias que reciben
# encuestas y se desactiva la encuesta dispoinble.
DELIMITER //
CREATE PROCEDURE finishSurvey()
BEGIN
	SET SQL_SAFE_UPDATES = 0;
	TRUNCATE TABLE ECOA_temporal;
	TRUNCATE TABLE Progreso_ECOA;
    TRUNCATE TABLE Elementos_de_partida;
    UPDATE Materia SET activa = 0 WHERE activa = 1;
    UPDATE Encuesta SET activa = 0 WHERE activa = 1;
    SET SQL_SAFE_UPDATES = 1;
END //
DELIMITER ;

DROP PROCEDURE finishSurvey;
CALL finishSurvey();

SELECT * FROM ECOA_temporal;
SELECT * FROM Progreso_ECOA;
SELECT * FROM ELementos_de_partida;
SELECT * FROM Materia WHERE Materia.activa = 1;
SELECT * FROM Encuesta;

UPDATE Encuesta SET activa = 1 WHERE clave_encuesta = "s1";
UPDATE Materia SET activa = 1 WHERE CRN = 41765;
UPDATE Materia SET activa = 1 WHERE CRN = 31696;
CALL setProgresoECOA();

# =========================================================================================================
# =========================================================================================================

# Otros querys 1
# Cuando el alumno responde una pregunta de ecoa se insertan los datos en ECOA_temporal, no vale la pena que sea
# un store procedure porque solo ejecuta una sola accion que es insertar datos en una sola tabla. Si el tipo de
# pregunta va dirigida a un profesor entonces el atributo CRN será NULL mientras que si al pregunta va dirigida a
# una materia o bloque el atributo profesor_nomina sera NULL. Se envia en un json todas las respuestas de la ecoa
# junto con los puntos para establecer 

# Otros querys 2
# si el alumno termino de responder una pregunta para todos sus profesores, materias o bloques dicha pregunta
# se marca como completada en Progreso_ECOA, no vale la pena que sea un store procedure porque solo se ejecuta
# hasta que se completan todas las preguntas de algun tipo (profesor, materia, bloque) mientras que las respuestas
# de ecoa se alamcenan cada vez que el alumno responde una pregunta

# Otros querys 4
# Cuando un alumno hace una tirada en el gashapon primero se restan los puntos desde unity y al final se actualiza
# el nuevo valor de monedas con un query

SELECT * FROM Materia WHERE activa = 1;
UPDATE Materia SET activa = 1 WHERE CRN = 15073;

# Alumnos que cursan la materia
SELECT Cursa.alumno_matricula, Materia.nombre_materia_largo, Materia.clave_materia FROM Cursa 
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Materia.CRN = 15073;

# Profesores que imparten la materia
SELECT Imparte.profesor_nomina, Materia.nombre_materia_largo, Materia.clave_materia FROM Imparte 
INNER JOIN Materia ON (Imparte.CRN = Materia.CRN)
WHERE Materia.CRN = 15073;

UPDATE Encuesta SET activa = 1 WHERE clave_encuesta = "s1";

SELECT * FROM Encuesta;
SELECT * FROM Preguntas_de_encuesta;
SELECT * FROM Banco_preguntas_ECOA;
SELECT * FROM ECOA_temporal;

SELECT * FROM Progreso_ECOA;
SELECT * FROM Elementos_de_partida;
TRUNCATE TABLE ECOA_temporal;
TRUNCATE TABLE Progreso_ECOA;
TRUNCATE TABLE Elementos_de_partida;

CALL setProgresoECOA();						# crear registros de videojuegos de los alumnos que reciben encuesta
CALL getSurvey('A00242489'); 				# ver si el alumno actual tiene encuesta disponible
CALL getTeachersQuestions('A00242489'); 	# otener preguntas faltantes de profesores de todas las materias
CALL getSubjectsQuestions('A00242489');  	# obtener preguntas faltantes de las materias que cursa el alumno	    
CALL getCoreSubjectsQuestions('A00242489'); # obtener preguntas faltantes de los bloques que cursa el alumno
CALL finishSurvey();						# eliminar preguntas sin terminar, desactivar encuesta y materias al finalizar periodo


# =========================================================================================================
# =========================================================================================================

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
	SELECT C.alumno_matricula FROM Cursa C INNER JOIN Materia M ON C.CRN = M.CRN WHERE M.CRN = 41765
) ORDER BY Cursa.alumno_matricula;

# 31696
# 41765

# Este query hace lo mismo que el anterior solo que agrupa los resultados por materia e indica
# el numero de alumnos en cada una
SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN, count(*) AS total_de_alumnos FROM Cursa
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
WHERE Cursa.alumno_matricula IN (
	SELECT C.alumno_matricula FROM Cursa C INNER JOIN Materia M ON C.CRN = M.CRN WHERE M.CRN = 41765
) GROUP BY Materia.nombre_materia_largo 
ORDER BY Cursa.alumno_matricula;


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

insert into Encuesta(clave_encuesta, descripcion, fecha_inicio, fecha_final, activa) values ("s1", "encuesta1", "2023-04-25", "2023-04-30", 0);
insert into Encuesta(clave_encuesta, descripcion, activa) values ("s2", "encuesta2", 0);

insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta1", "El profesor(a) muestra dominio y experiencia en los temas de la Materia:", "Profesor", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta2", "Los temas, las actividades y el reto durante el Bloque:A) Me permitieron aprender y desarrollarme.", "Bloque", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta3", "Los temas, las actividades y la situación-problema durante la Materia:A) Me permitieron aprender y desarrollarme.", "Materia", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta4", "El profesor(a) promovió un ambiente de confianza y de respeto:", "Profesor", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta5", "Los temas vistos en la UdF son aplicables y de valor en la industria:", "Materia", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta6", "El bloque se desarrolló de manera coordinada entre los (as) profesores (as):", "Bloque", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta7", "Los temas, las actividades y el reto durante el Bloque son aplicables y de valor:", "Bloque", "Cerrada");
insert into Banco_preguntas_ECOA(clave_pregunta, descripcion, dirigido_a, tipo) values ("pregunta8", "El acompañamiento que recibí por parte del profesor fue adecuado:", "Profesor", "Cerrada");

insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta1");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta2");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta3");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta4");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta5");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta6");
insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s1","pregunta7");

insert into Preguntas_de_encuesta(clave_encuesta, clave_pregunta) values ("s2","pregunta8");

SELECT * FROM Banco_preguntas_ECOA;
SELECT * FROM Preguntas_de_encuesta;
SELECT * FROM Encuesta;
SELECT * FROM Materia WHERE CRN = 32701;
SET @matricula = 'A00228079'; 
# Alumnos con encuesta en todas sus materias (2 encuestas) A00228187 A00228208 A00229540 A00228079
# Alumno que estudia las mismas materias pero diferentes grupos (0 encuestas) A00234284
# Alumno que estudia una materia que no aplica encuesta (0 encuestas) A01620861
# Alumno que estudia 3 materias al mismo tiempo pero solo tieneencuesta de 2 materias: A00230099



CALL GetSurvey('A00230099'); 

# "Aplicación de la teoría electromagnética" (15 alumnos) 41765	L00621869	L00621927 
# "Análisis de circuitos eléctricos de corriente alterna" (31 alumnos)	31696	L00622354
# Al obtener todas las demas materias que estudian los alumnos del CRN 41765 se obtiene que 
# solo 15 estudian el CRN 31696, no se obtendran los 31 alumnos que estudian esta ultima materia
# porque hay 15 alumnos del grupo 31696 que estudian al mismo tiempo en el grupo 41765 mientras que
# los otros 16 alumnos del grupo 31696 no estudian al mismo tiempo en el grupo 41765, quizas estudien 
# en otros grupos y solo hay un alumno que estudia en 41765 y 30634 al mismo tiempo (15 + 15 + 1 = 31)

SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN FROM Cursa
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
WHERE Cursa.CRN = 31696;

# obteniendo todas las materias que estudia el alumno
SELECT Alumno.alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Cursa.CRN FROM Alumno
INNER JOIN Cursa ON (Alumno.alumno_matricula = Cursa.alumno_matricula) 
INNER JOIN Materia ON (Cursa.CRN = Materia.CRN)
WHERE Alumno.alumno_matricula = 'A01620860';
# A00228079 A00228187 A00229540 A00230117

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

# ===================================================================================================

# Alumnos que solo estudian 41765 (0, todos los alumnos de 41765 cursan al mismo tiempo 31696)
SELECT A.Alumno_matricula, A.nombre_materia_largo, A.tipodeUdF, A.CRN 
FROM 
(SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 41765) A
 LEFT JOIN
 (SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 31696) B
 ON (A.Alumno_matricula = B.Alumno_matricula)
 WHERE B.alumno_matricula IS NULL;

# Alumnos que solo estudian 31696 (16)
SELECT A.Alumno_matricula, A.nombre_materia_largo, A.tipodeUdF, A.CRN, B.alumno_matricula
FROM 
(SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 31696) A
 LEFT JOIN
 (SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 41765) B
 ON (A.Alumno_matricula = B.Alumno_matricula)
 WHERE B.alumno_matricula IS NULL;

# Alumnos que estudian ambas materias (15)
SELECT A.Alumno_matricula, A.nombre_materia_largo, A.tipodeUdF, A.CRN 
FROM 
(SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 31696) A
 INNER JOIN
 (SELECT Cursa.Alumno_matricula, Materia.nombre_materia_largo, Materia.tipodeUdF, Materia.CRN 
 FROM Cursa
 INNER JOIN Materia ON (Cursa.CRN = Materia.CRN) 
 WHERE Cursa.CRN = 41765) B
 ON (A.Alumno_matricula = B.Alumno_matricula);
 
 
 
 
# 31696
# 41765
SELECT * FROM Banco_preguntas_ECOA;
SELECT * FROM Preguntas_de_encuesta;
SELECT * FROM Encuesta;
SELECT * FROM Materia WHERE CRN = 32701;
SET @matricula = 'A00228079'; 

# obteniendo todos los profesores que imparten una materia
SELECT * FROM Materia 
INNER JOIN Imparte ON (Materia.CRN = Imparte.CRN)
INNER JOIN Profesor ON (Imparte.profesor_nomina = Profesor.profesor_nomina)
WHERE Materia.CRN = 41765;

CALL getSurvey('A01620860');

SELECT * FROM ECOA_temporal;
SELECT * FROM Preguntas_de_encuesta
INNER JOIN Banco_preguntas_ECOA ON (Preguntas_de_encuesta.clave_pregunta = Banco_preguntas_ECOA.clave_pregunta);
 

 -- A00228079 alumno que no ha terminado todas las preguntas de profesores, faltan las preguntas de materias y bloques
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228079", "s1", "pregunta1", "8", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228079", "s1", "pregunta4", "10", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228079", "s1", "pregunta1", "5", NULL, 'L00621927');

-- A00228187 alumno que ha contestado todas las preguntas de profesores pero no todas de las materias, faltan todas del bloque
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta1", "1", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta4", "2", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta1", "3", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta4", "4", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta1", "5", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta4", "6", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00228187", "s1", "pregunta3", "10", 31696, NULL);

-- A00229540 alumno que ha contestado todas las de profesores, todas materias y algunas de bloques
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta1", "7", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta4", "7", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta1", "6", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta4", "8", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta1", "9", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta4", "10", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta3", "0", 31696, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta5", "3", 31696, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta2", "5", 41765, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00229540", "s1", "pregunta6", "5", 41765, NULL);

-- A00230117 alumno que ya contesto todas las preguntas de profesores, materias y bloques
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta1", "1", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta4", "1", NULL, 'L00622354');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta1", "1", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta4", "1", NULL, 'L00621869');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta1", "1", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta4", "1", NULL, 'L00621927');
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta3", "0", 31696, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta5", "0", 31696, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta2", "2", 41765, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta6", "2", 41765, NULL);
insert into ECOA_temporal(alumno_matricula, clave_encuesta, clave_pregunta, respuesta, CRN, profesor_nomina) values ("A00230117", "s1", "pregunta7", "2", 41765, NULL);

UPDATE Encuesta SET fecha_inicio = '2023-05-01', fecha_final = '2023-05-03', activa = 0 WHERE clave_encuesta = "s1";
UPDATE Encuesta SET fecha_inicio = '2023-04-28', fecha_final = '2023-05-01', activa = 1 WHERE clave_encuesta = "s1";
SELECT * FROM Encuesta;