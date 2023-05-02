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
        const [result] = await pool.query("SELECT * FROM Encuesta;");
        res.json(result);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const getQuestions = async (req, res) => {
    try {
        const [result] = await pool.query("SELECT * FROM Banco_preguntas_ECOA;");
        console.log(result)
        res.json(result);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const activateSurvey = async (req, res) => {
    try {
        const { clave_encuesta } = req.body;
        console.log("backend 1: " + clave_encuesta);
        const [result] = await pool.query("UPDATE Encuesta SET activa = 1 WHERE clave_encuesta = ?;", [clave_encuesta]);
        console.log("backend 2: " + clave_encuesta);
        res.sendStatus(200);
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}

export const finishSurvey = async (req, res) => {
    try {
        const [result] = await pool.query("CALL finishSurvey();");
    } catch (error) {
        console.log(error.message);
        return res.status(500).json({ message: error.message })
    }
}