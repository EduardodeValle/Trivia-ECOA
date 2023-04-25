import React from 'react';
import { useLocation } from 'react-router-dom';
import 'bootstrap/dist/css/bootstrap.min.css';
import './Student.css';

// las propiedades del videojuego estan en el tag <iframe>, el videojuego se encuentra en el frame contenedor

function Student() {
  const location = useLocation();
  const welcomeText = location.state.welcomeText;

  return (
    <div className="container student-container">
      <h1 className="text-center mb-4">{welcomeText}</h1>
      <h5 className="text-center text-blue mb-4">¡Juega la Trivia y Gana Premios!</h5>
      <div className="row justify-content-center">
        <div className="col-md-8">
          <div className="game-container bg-light p-3">
            <iframe src="../Videogame/index.html" width="300px" height="100px"></iframe> 
          </div>
        </div>
      </div>
    </div>

  );
};

export default Student;