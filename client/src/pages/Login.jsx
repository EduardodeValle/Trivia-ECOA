import React, { useState, useContext, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { RequestLogin, RequestStudentSurvey, RequestQuestions, RequestSurveys } from '../api/tasks.api.js'
import { UserContext } from '../context/UserContext.jsx'
import './Login.css';


function Login() {
  const [id_usuario, setid_usuario] = useState('');
  const [contrasenia, setPassword] = useState('');
  const navigate = useNavigate();
  const { id_usuarioContext, setIDusuario, user_name, setUserName, msg, setMSG, preguntas, setPreguntas, preguntasArchivadas, setPreguntasArchivadas, encuestas, setEncuestas, encuestasArchivadas, setEncuestasArchivadas } = useContext(UserContext);

  const handleSubmit = async (event) => {
    event.preventDefault();
    const credentials = {
      "id_usuario": id_usuario,
      "contrasenia": contrasenia
    };
    const response_login = await RequestLogin(credentials);
    if (response_login.data.success) {
      const message = 'Bienvenido ' + response_login.data.nombre;
      setid_usuario(id_usuario);
      setIDusuario(id_usuario);
      setUserName(response_login.data.nombre);

      setMSG(message);
      if (response_login.data.ocupacion === 'Alumno') { 
        const response_survey = await RequestStudentSurvey({ "alumno_matricula": id_usuario });
        console.log("===================================================")
        console.log("El alumno tiene encuestas en " + response_survey.data.length + " materias");
        console.log("===================================================")
        if (response_survey.data.length === 0) { navigate('/student'); }
        else { navigate('/student-survey');  }
      }
      else if (response_login.data.ocupacion === 'Profesor') { navigate('/teacher'); }
      else if (response_login.data.ocupacion === 'Colaborador' || response_login.data.ocupacion === 'ProfesorColaborador') { 
        let questions_response = await RequestQuestions( {archivado: 0} );
        setPreguntas(questions_response.data); // estableciendo preguntas no archivadas
        questions_response = await RequestQuestions( {archivado: 1} );
        setPreguntasArchivadas(questions_response.data); // estableciendo preguntas archivadas
        let surveys_response = await RequestSurveys( {archivada: 0} ); 
        setEncuestas(surveys_response.data); // estableciendo encuestas no archivadas
        surveys_response = await RequestSurveys( {archivada: 1} ); 
        setEncuestasArchivadas(surveys_response.data); // estableciendo encuestas archivadas
        console.log("===============================================");
        console.log(preguntas)
        console.log("===============================================");
        console.log(encuestas)
        console.log("===============================================");
        navigate('/admin'); 
      }
    } else {
      console.log('Credenciales incorrectas, por favor intente de nuevo.');
    }
  };

  return (
    <div className="container">
      <div className="row justify-content-center align-items-center vh-100">
        <div className="col-4">
          <div className="card">
            <div className="card-body">
              <h1 className="card-title text-center">¡Bienvenido!</h1>
              <form onSubmit={handleSubmit}>
                <div className="mb-3">
                  <label htmlFor="id_usuario" className="form-label">Correo:</label>
                  <input
                    type="text"
                    className="form-control"
                    id="id_usuario"
                    placeholder="Ingresa tu correo"
                    value={id_usuario} onChange={(e) => setid_usuario(e.target.value)}
                  />
                </div>
                <div className="mb-3">
                  <label htmlFor="contrasenia" className="form-label">Contraseña:</label>
                  <input
                    type="password"
                    className="form-control"
                    id="contrasenia"
                    placeholder="Ingresa tu contraseña"
                    value={contrasenia} onChange={(e) => setPassword(e.target.value)}
                  />
                </div>
                <div className="d-grid">
                  <button type="submit" className="btn btn-primary">Ingresa</button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login;