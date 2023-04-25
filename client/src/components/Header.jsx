import React from 'react';
import './Header.css';

function Header() {
  const logoURL = 'https://encuestastec.tec.mx/images/logo-tec-light.png';

  return (
    <header className="header">
      <h1 className="title"> Sistema de Encuestas</h1>
      <img src={logoURL} alt="Logo" className="logo" />
    </header>
  );
};

export default Header;