import React from 'react';
import './Notfound.css';

function NotFound() {
  return (
    <div>
      <div>
        <h1 className="notf-header">¡Página No Encontrada!</h1>
        <div className="notf-container">
          <p className="notf-text1">La página que buscas no fue encontrada. Porfavor regresa y vuelve a ingresar con tu cuenta.</p>
        </div>
      </div>
    </div>
  );
}

export default NotFound;