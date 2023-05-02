import express from 'express';
import { PORT } from './config.js'
import indexRoutes from './routes/index.routes.js'
import { finishSurvey, getSurveys } from './controllers/index.controllers.js';
import cors from 'cors'
import { CronJob } from 'cron'
import axios from 'axios'

const app = express();

app.use(cors({
    origin: "http://localhost:5173",
    methods: ["GET", "POST", "PUT", "DELETE"]
}));
app.use(express.json());
app.use(indexRoutes);
app.listen(PORT);
console.log(`Server is listening on port ${PORT}`);

//                     'minuto hora * * *'
const job = new CronJob('57 1 * * *', async function () {
    console.log('Esta tarea se ejecutará todos los días a las 00:00 horas');

    try {
        const response = await axios.get('http://localhost:4000/getSurveys'); // obtiene todas las encuestas
        const surveys = response.data;
        const hoy = new Date();
        const fecha_actual = hoy.getFullYear() + '-' + (hoy.getMonth() + 1).toString().padStart(2, '0') + '-' + hoy.getDate().toString().padStart(2, '0'); // obteniendo fecha en formato YEAR-MONTH-DAY
        for (const survey of surveys) {
            console.log(survey.clave_encuesta);
            const fecha_inicio_encuesta = survey.fecha_inicio.slice(0, 10);
            const fecha_final_encuesta = survey.fecha_final.slice(0, 10);
            if ((fecha_actual >= fecha_inicio_encuesta) && (fecha_actual <= fecha_final_encuesta) && (survey.activa === 0)) { 
                console.log("Se encontro que la encuesta " + survey.clave_encuesta + " debe activarse");
                const response = await axios.post('http://localhost:4000/activateSurvey', { clave_encuesta: survey.clave_encuesta }); // se debe activar la encuesta
                console.log("Activada la encuesta " + survey.clave_encuesta + " exitosamente");
                break; // ya no hay mas encuestas por activar
            } 
            else if ((fecha_actual > fecha_final_encuesta) && (survey.activa === 1)) { const response = await axios.get('http://localhost:4000/finishSurvey'); } // se ejecuta el store procedure finishSurvey()
        }
    } catch (error) {
        console.error(error);
    }
});

job.start();
