import React, {useContext} from 'react';
import { UserContext } from '../context/UserContext.jsx'
import './Teacher.css';

function Teacher() {
  const { msg } = useContext(UserContext);

  return (
    <div className="teacher-container">
      <h1 className="teacher-header">Sistema de Encuestas</h1>
      <h2>{msg}</h2>
      <div className="teacher-main">
        <div className="teacher-top-section">
          <div className="teacher-section">
            <h2>Periodo ECOA</h2>
          </div>
        </div>
        <div className="teacher-bottom-sections">
          <div className="teacher-section">
            <h2>Encuesta</h2>
          </div>
          <div className="teacher-section">
            <h2>Detalles de Resultados</h2>
          </div>
        </div>
      </div>
    </div>
  );
}

export default Teacher;