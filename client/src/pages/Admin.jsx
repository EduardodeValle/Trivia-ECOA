import React, {useContext} from 'react';
import './Admin.css';
import Button from '@mui/material/Button/index.js';
import { useNavigate } from 'react-router-dom';
import UserContext from '../context/UserContext.jsx'

function Admin() {

  const { msg } = useContext(UserContext);

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
          <h2>Generador de Encuestas</h2>
          <p>Genera más encuestas para agregar a la ECOA.</p>
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