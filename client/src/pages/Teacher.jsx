import React from 'react';
import { useLocation } from 'react-router-dom';
import './Teacher.css';

function Teacher() {
  const location = useLocation();
  const welcomeText = location.state.welcomeText;

  return (
    <div className="teacher-container">
      <h1 className="teacher-header">Sistema de Encuestas</h1>
      <h2>{welcomeText}</h2>
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