import React from 'react';
import './Preguntas.css';
import TextField from '@mui/material/TextField/index.js';
import Checkbox from '@mui/material/Checkbox/index.js';
import FormGroup from '@mui/material/FormGroup/index.js';
import FormControlLabel from '@mui/material/FormControlLabel/index.js';
import Button from '@mui/material/Button/index.js';
import InputLabel from '@mui/material/InputLabel/index.js';
import MenuItem from '@mui/material/MenuItem/index.js';
import FormControl from '@mui/material/FormControl/index.js';
import Select from '@mui/material/Select/index.js';
import ArrowBackIcon from '@mui/icons-material/esm/ArrowBack.js';
import { useNavigate } from 'react-router-dom';

function Preguntas() {

  const navigate = useNavigate();
  const handleRegresar = () => {
    navigate('/admin');
  };

  return (
    <div>
      <main className="preguntas-container">
        <h1 className="preguntas-title">Configuración de Preguntas</h1>
        <div className="preguntas-main">
          <div className="preguntas-grey-container">
            <h2 className="box-title">Altas</h2>
            <p className="altas-text1">Clave:
              <TextField id="filled-basic" label="Identificador único" variant="outlined" />
            </p>
            <p className="altas-text1">Pregunta:
              <TextField id="filled-basic" label="Descripción" variant="outlined" />
            </p>
            <p className="altas-text2">Tipo:
              <FormGroup>
                <FormControlLabel control={<Checkbox />} label="Rango" />
                <FormControlLabel control={<Checkbox />} label="Abierta" />
              </FormGroup>
            </p>
            <p className="altas-text3">Dirigido a:
              <FormGroup>
                <FormControlLabel control={<Checkbox />} label="Profesor" />
                <FormControlLabel control={<Checkbox />} label="Materia" />
                <FormControlLabel control={<Checkbox />} label="Bloque" />
              </FormGroup>
            </p>
            <p className="altas-text4">
              <Button variant="contained">Guardar</Button>
            </p>
          </div>
          <div className="preguntas-grey-container">
            <h2 className="box-title">Bajas</h2>
            <p className="bajas-text1">
              <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Pregunta</InputLabel>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  label="Pregunta"
                >
                  <MenuItem>Pregunta 1</MenuItem>
                  <MenuItem>Pregunta 2</MenuItem>
                  <MenuItem>Pregunta 3</MenuItem>
                </Select>
              </FormControl>
            </p>
            <label>Textbox with question description here</label>
            <p className="bajas-text2">
              <Button variant="contained">Archivar</Button>
            </p>
          </div>
          <div className="preguntas-grey-container">
            <h2 className="box-title">Cambios</h2>
            <p className="cambios-text1">
              <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Clave</InputLabel>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  label="Pregunta"
                >
                  <MenuItem>Pregunta 1</MenuItem>
                  <MenuItem>Pregunta 2</MenuItem>
                  <MenuItem>Pregunta 3</MenuItem>
                </Select>
              </FormControl>
            </p>
            <p className="cambios-text1">Pregunta:
              <TextField id="filled-basic" label="Descripción" variant="outlined" />
            </p>
            <p className="cambios-text2">Tipo:
              <FormGroup>
                <FormControlLabel control={<Checkbox />} label="Rango" />
                <FormControlLabel control={<Checkbox />} label="Abierta" />
              </FormGroup>
            </p>
            <p className="cambios-text3">Dirigido a:
              <FormGroup>
                <FormControlLabel control={<Checkbox />} label="Profesor" />
                <FormControlLabel control={<Checkbox />} label="Materia" />
                <FormControlLabel control={<Checkbox />} label="Bloque" />
              </FormGroup>
            </p>
            <p className="cambios-text4">
              <Button variant="contained">Guardar</Button>
            </p>
          </div>
        </div>
      </main>
      <div className="arrow-back-icon2">
        <Button variant="contained" onClick={handleRegresar} startIcon={<ArrowBackIcon />}></Button>
      </div>
    </div>
  );
}

export default Preguntas;