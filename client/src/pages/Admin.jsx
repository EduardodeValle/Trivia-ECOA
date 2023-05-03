import React, { useContext } from 'react';
import './Admin.css';
import Button from '@mui/material/Button/index.js';
import { useNavigate } from 'react-router-dom';
import { UserContext } from '../context/UserContext.jsx'

function Admin() {

  const { msg, preguntas, encuestas, encuestasArchivadas } = useContext(UserContext);

  console.log("===================================================");
  console.log(msg);
  console.log("===================================================");
  console.log(encuestas);
  console.log("===================================================");
  console.log(encuestasArchivadas);
  console.log("===================================================");


  const navigate = useNavigate();
  const handleIngresarPreguntas = () => {
    navigate('/preguntas');
  };
  const handleIngresarEncuestas = () => {
    navigate('/encuestas');
  };
  const handleIngresarActivar = () => {
    navigate('/activar');
  };

  return (
    <div className="admin-container">
      <h1 className="admin-header">{msg}</h1>
      <div className="admin-main">
        <div className="admin-left-section">
          <h2 className='admin-title-1'>Generador de Encuestas</h2>
          <div className="text-justify">
            <p>Bienvenido al Generador de Encuestas. Aquí podrás modificar las preguntas disponibles, crear encuestas, y activar las encuestas eliginedo las sección adecuada. </p>
            <p>Configuración de Preguntas te permite crear, archivar, desarchivar, y cambiar preguntas.</p>
            <p>Configuración de Encuestas te permite crear, archivar, y desarchivar encuestas para habilitar su funcionamiento.</p>
            <p>Activación de Encuestas te permite seleccionar una encuesta ya previamente creada y determinar una fecha en la que estará activa.</p>
          </div>

        </div>
        <div className="admin-right-sections">
          <div className="admin-section">
            <h2 className="admin-title">ABC Preguntas</h2>
            <p>Modifica las preguntas disponibles.</p>
            <p className="button1">
              <Button variant="contained" onClick={handleIngresarPreguntas}>Ingresar</Button>
            </p>
          </div>
          <div className="admin-section">
            <h2 className="admin-title">ABC Encuesta</h2>
            <p>Modifica las encuestas disponibles.</p>
            <p className="button2">
              <Button variant="contained" onClick={handleIngresarEncuestas}>Ingresar</Button>
            </p>
          </div>
          <div className="admin-section">
            <h2 className="admin-title">Activar Encuestas</h2>
            <p>Activa las encuestas disponibles.</p>
            <p className="button3">
              <Button variant="contained" onClick={handleIngresarActivar}>Ingresar</Button>
            </p>
          </div>
        </div>
      </div>
    </div>


  );
}

export default Admin;