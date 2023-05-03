import React, { useState, useEffect, useContext } from 'react';
import './Teacher.css';
import { DataGrid } from "@mui/x-data-grid";
import Papa from 'papaparse';
import { UserContext } from '../context/UserContext.jsx'

function Teacher() {
  const [rows, setRows] = useState([]);
  const columns = [
    { field: "Clave Materia", headerName: "Clave Materia", width: 150 },
    { field: "Nombre Materia", headerName: "Nombre Materia", width: 150 },
    { field: "Alumnos Candidatos", headerName: "Alumnos Candidatos", width: 150 },
    { field: "Alumnos que Opinaron", headerName: "Alumnos que Opinaron", width: 150 },
    { field: "Participacion", headerName: "Participación", width: 150 },
    { field: "01DOM_Prom", headerName: "01DOM_Prom", width: 150 },
    { field: "02RET_Prom", headerName: "02RET_Prom", width: 150 },
    { field: "03REC_Prom", headerName: "03REC_Prom", width: 150 },
    { field: "05ASE_Prom", headerName: "04ASE_Prom", width: 150 },
    { field: "05MET_Prom", headerName: "05MET_Prom", width: 150 },
    { field: "Nomina", headerName: "Nomina", width: 150 }
  ];
  const { msg, id_usuarioContext, user_name } = useContext(UserContext);
  console.log("Nomina: " + id_usuarioContext);
  console.log("Nombre: " + user_name);

  useEffect(() => {
    fetch('/InformacionSesionProfesor1.csv')
      .then(response => response.text())
      .then(data => {
        const parsedData = Papa.parse(data, { header: true });
        const allRows = parsedData.data;

        // Filter the rows based on the "Nomina" column value
        const filteredRows = allRows
          .filter(row => row['Nomina'] === id_usuarioContext)
          .map((row, index) => ({
            id: index + 1,
            ...row
          }));

        setRows(filteredRows);
      })
      .catch(error => console.error(error));
  }, []);

  return (
    <div>

      <div className="teacher-container">
        <h1 className="teacher-header">Sistema de Encuestas</h1>
        <div className="teacher-main">
          <div className="teacher-bottom-sections">
            <div className="teacher-section">
              <h2>{user_name}</h2>
            </div>
            <div className="teacher-section">
              <h2>Nomina: {id_usuarioContext}</h2>
            </div>
          </div>
          <div className="teacher-top-section">
            <div className="teacher-section">
              <h2>Resultados</h2>
              <div style={{ height: 300, width: "100%" }}>
                <DataGrid rows={rows} columns={columns} />
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
}

export default Teacher;