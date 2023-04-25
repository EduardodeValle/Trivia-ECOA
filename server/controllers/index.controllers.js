import { pool } from '../db.js'

export const getUser = async (req, res) => {
    try {
        const { id_usuario, contrasenia } = req.body
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
      
            console.log("nombre: " + resultName);
            console.log('========================================');
            res.json({ success: true, ocupacion: result[0].ocupacion, nombre: resultName });

        }
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}