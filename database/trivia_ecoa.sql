CREATE DATABASE IF NOT EXISTS trivia_ecoa;

CREATE TABLE Alumno(
	alumno_matricula VARCHAR(9),
    contrasenia VARCHAR(30),
    nombre VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    semestre INT NOT NULL,
    carrera VARCHAR(50),
    PRIMARY KEY (alumno_matricula)
);

CREATE TABLE Materia(
	CRN INT NOT NULL,
    nombre_materia VARCHAR(50),
    clave_materia VARCHAR(10),
    grupo INT NOT NULL,
    PRIMARY KEY (CRN)
);

CREATE TABLE Profesor(
	profesor_nomina VARCHAR(10),
    nombre VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    PRIMARY KEY (profesor_nomina)
);

CREATE TABLE Cursa(
	alumno_matricula VARCHAR(9),
    CRN INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN)
);

CREATE TABLE Imparte(
	profesor_nomina VARCHAR(10),
    CRN INT NOT NULL,
    FOREIGN KEY (profesor_nomina) REFERENCES Profesor(profesor_nomina),
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
	id_premio INT NOT NULL,
    alumno_matricula VARCHAR(9),
    QR BLOB,
    canjeado BOOL, 
    fecha_expiracion DATE,
    FOREIGN KEY (id_premio) REFERENCES Premio(id_premio),
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula)
);

CREATE TABLE Perfil_juego(
	alumno_matricula VARCHAR(9),
    ecoas_respondidas INT NOT NULL,
    balance_monedas INT NOT NULL,
    total_preguntas_respondidas INT NOT NULL,
    total_respuestas_correctas INT NOT NULL,
    maximo_puntaje INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula)
);

CREATE TABLE Banco_preguntas_ECOA(
	clave_pregunta VARCHAR(10),
    descripcion VARCHAR(200),
    tipo VARCHAR(50),
    PRIMARY KEY (clave_pregunta)
);

CREATE TABLE Encuesta(
	id_encuesta INT NOT NULL AUTO_INCREMENT,
    nombre_encuesta VARCHAR(100),
    fecha_inicio DATE,
    fecha_final DATE,
    PRIMARY KEY (id_encuesta)
);

CREATE TABLE Preguntas_de_encuesta(
	id_encuesta INT NOT NULL,
    clave_pregunta VARCHAR(10),
    FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE ECOA_temporal(
	id_encuesta INT NOT NULL,
    alumno_matricula VARCHAR(9),
    CRN INT NOT NULL,
    profesor_nomina VARCHAR(10),
    clave_pregunta VARCHAR(10),
    respuesta VARCHAR(3000),
    FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta),
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN),
    FOREIGN KEY (profesor_nomina) REFERENCES Profesor(profesor_nomina),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE ECOA_definitiva(
	folio INT NOT NULL AUTO_INCREMENT,
    id_encuesta INT NOT NULL,
    CRN INT NOT NULL,
    profesor_nomina VARCHAR(10),
    clave_pregunta VARCHAR(10),
    respuesta VARCHAR(3000),
    PRIMARY KEY (folio),
    FOREIGN KEY (id_encuesta) REFERENCES Encuesta(id_encuesta),
    FOREIGN KEY (CRN) REFERENCES Materia(CRN),
    FOREIGN KEY (profesor_nomina) REFERENCES Profesor(profesor_nomina),
    FOREIGN KEY (clave_pregunta) REFERENCES Banco_preguntas_ECOA(clave_pregunta)
);

CREATE TABLE Progreso_ECOA(
	alumno_matricula VARCHAR(9),
    avance INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula)
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
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula)
);

CREATE TABLE Elementos_de_partida(
	alumno_matricula VARCHAR(9),
    puntos INT NOT NULL,
    vidas INT NOT NULL,
    ronda INT NOT NULL,
    FOREIGN KEY (alumno_matricula) REFERENCES Alumno(alumno_matricula)
);