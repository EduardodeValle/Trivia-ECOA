import { pool } from '../db.js'

export const getUser = async (req, res) => {
    try {
        const { id_usuario, contrasenia } = req.body;
        const [result] = await pool.query(
            "SELECT * FROM Usuario WHERE id_usuario = ? AND contrasenia = ?;",
            [id_usuario, contrasenia]
        );
        let resultName = "";
        if (result.length === 0) { res.json({ success: false }) }
        else {
            if (result[0].ocupacion === 'Alumno') {
                const alumno_matricula = id_usuario;
                const [rows] = await pool.query("SELECT nombre FROM Alumno WHERE alumno_matricula = ?;", [alumno_matricula]);
                resultName = rows[0].nombre;
            }
            else if (result[0].ocupacion === 'Profesor') {
                const profesor_nomina = id_usuario;
                const [rows] = await pool.query("SELECT nombre FROM Profesor WHERE profesor_nomina = ?;", [profesor_nomina]);
                resultName = rows[0].nombre;
                console.log("Se encontro el profesor " + resultName);
            }
            else if (result[0].ocupacion === 'Colaborador') {
                const colaborador_nomina = id_usuario;
                const [rows] = await pool.query("SELECT nombre FROM Colaborador WHERE colaborador_nomina = ?;", [colaborador_nomina]);
                resultName = rows[0].nombre;
            }
            else if (result[0].ocupacion === 'ProfesorColaborador') {
                const colaborador_nomina = id_usuario;
                const [rows] = await pool.query("SELECT nombre from Colaborador WHERE colaborador_nomina = ?;", [colaborador_nomina]);
                resultName = rows[0].nombre;
            }

            res.json({ success: true, ocupacion: result[0].ocupacion, nombre: resultName });

        }
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

export const getStudentSurvey = async (req, res) => {
    try {
        const { alumno_matricula } = req.body;
        const [result] = await pool.query("CALL GetSurvey(?);", [alumno_matricula]);
        console.log(result[0]);
        console.log("==============================================");
        res.json(result[0]);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const getSurveys = async (req, res) => {
    try {
        const { archivada } = req.body;

        // obteniendo todas las encuestas archivadas o no archivadas
        const [result] = await pool.query("SELECT * FROM Encuesta WHERE archivada = ?;", [archivada]);

        // se asigna a cada encuesta un nuevo atributo que contiene todas las preguntas de la misma
        for (let i = 0; i < result.length; i++) {
            result[i].preguntas_de_encuesta = [];
            const [survey_questions] = await pool.query("SELECT * FROM Preguntas_de_encuesta WHERE clave_encuesta = ?;", [result[i].clave_encuesta]);
            for (let j = 0; j < survey_questions.length; j++) {
                result[i].preguntas_de_encuesta.push(survey_questions[j].clave_pregunta);
            }
        }

        // finalmente se devuelve un json de todas las encuestas donde cada una tiene las preguntas en un arreglo de objetos
        res.json(result);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const getQuestions = async (req, res) => {
    try {
        const { archivado } = req.body;
        const [result] = await pool.query("SELECT * FROM Banco_preguntas_ECOA WHERE archivada = ?;", [archivado]);
        res.json(result);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const activateSurvey = async (req, res) => {
    try {
        const { clave_encuesta } = req.body;
        const [result_1] = await pool.query("UPDATE Encuesta SET activa = 1 WHERE clave_encuesta = ?;", [clave_encuesta]);
        const [result_2] = await pool.query("CALL setProgresoECOA();");
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const finishSurvey = async (req, res) => {
    try {
        const [result] = await pool.query("CALL finishSurvey();");
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const postQuestion = async (req, res) => {
    try {
        const { clave_pregunta, descripcion, dirigido_a, tipo } = req.body;
        const [result] = await pool.query("INSERT INTO Banco_preguntas_ECOA (clave_pregunta, descripcion, dirigido_a, tipo, archivada) VALUES (?, ?, ?, ?, 0);", [clave_pregunta, descripcion, dirigido_a, tipo, 0]);
        console.log("Se agrego exitosamente la pregunta " + clave_pregunta)
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const archiveQuestion = async (req, res) => {
    try {
        const { clave_pregunta } = req.body;
        console.log("clave de la pregunta: " + clave_pregunta)
        const [result] = await pool.query("UPDATE Banco_preguntas_ECOA SET archivada = 1 WHERE clave_pregunta = ?;", [clave_pregunta]);
        console.log("Se archivo la pregunta " + clave_pregunta + " exitosamente");
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const unarchiveQuestion = async (req, res) => {
    try {
        const { clave_pregunta } = req.body;
        const [result] = await pool.query("UPDATE Banco_preguntas_ECOA SET archivada = 0 WHERE clave_pregunta = ?;", [clave_pregunta]);
        console.log("Se desarchivo la pregunta " + clave_pregunta);
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const updateQuestion = async (req, res) => {
    try {
        const { clave_pregunta, descripcion, dirigido_a, tipo } = req.body;
        console.log("Backend: " + clave_pregunta + " " + descripcion + " " + dirigido_a + " " + tipo);
        const [result] = await pool.query("UPDATE Banco_preguntas_ECOA SET descripcion = ?, dirigido_a = ?, tipo = ? WHERE clave_pregunta = ?;", [descripcion, dirigido_a, tipo, clave_pregunta]);
        console.log("Se modifico exitosamente la pregunta " + clave_pregunta);
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const postSurvey = async (req, res) => {
    try {
        const { clave_encuesta, descripcion, preguntas_de_encuesta } = req.body;
        //console.log("backend");
        //console.log(clave_encuesta + " " + descripcion);
        //console.log(preguntas_de_encuesta);
        // creando la nueva encuesta
        const [result_survey] = await pool.query("INSERT INTO Encuesta (clave_encuesta, descripcion) VALUES (?, ?)", [clave_encuesta, descripcion]);

        // insertando las preguntas de encuesta
        for (let i = 0; i < preguntas_de_encuesta.length; i++) {
            const [result_questions] = await pool.query("INSERT INTO Preguntas_de_encuesta (clave_encuesta, clave_pregunta) VALUES (?, ?)", [clave_encuesta, preguntas_de_encuesta[i]]);
        }

        console.log("Se creo la encuesta " + clave_encuesta + " exitosamente");
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const archiveSurvey = async (req, res) => {
    try {
        const { clave_encuesta } = req.body;
        const [result] = await pool.query("UPDATE Encuesta SET archivada = 1 WHERE clave_encuesta = ?;", [clave_encuesta]);
        console.log("Se archivo exitosamente la encuesta " + clave_encuesta);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}