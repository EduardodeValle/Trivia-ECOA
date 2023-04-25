import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { RequestLogin } from '../api/tasks.api.js'
import './Login.css';


function Login() {
  const [id_usuario, setid_usuario] = useState('');
  const [contrasenia, setPassword] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (event) => {
    event.preventDefault();
    const credentials = {
      "id_usuario": id_usuario,
      "contrasenia": contrasenia
    };
    const response = await RequestLogin(credentials);
    if (response.data.success) {
      const msg = 'Bienvenido ' + response.data.nombre;
      if (response.data.ocupacion === 'Alumno') { navigate('/student', { state: { welcomeText: msg } }); }
      else if (response.data.ocupacion === 'Profesor') { navigate('/teacher', { state: { welcomeText: msg } } ); }
      else if (response.data.ocupacion === 'Colaborador' || response.data.ocupacion === 'ProfesorColaborador') { navigate('/admin', { state: { welcomeText: msg } } ); }
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
                    type="contrasenia"
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