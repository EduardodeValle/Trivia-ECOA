import React, { useContext, useState } from 'react';
import './Preguntas.css';
import TextField from '@mui/material/TextField';
import FormControlLabel from '@mui/material/FormControlLabel';
import Button from '@mui/material/Button';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import Radio from '@mui/material/Radio';
import RadioGroup from '@mui/material/RadioGroup';
import FormLabel from '@mui/material/FormLabel';
import { UserContext } from '../context/UserContext.jsx'
import { useNavigate } from 'react-router-dom';

function Preguntas() {

  const navigate = useNavigate();
  const handleRegresar = () => {
    navigate('/admin');
  };

  const { preguntas } = useContext(UserContext);

  const [selectedOption, setSelectedOption] = useState('');

  const handleSelectChange = (event) => {
    setSelectedOption(event.target.value);
  }

  const MenuItems = preguntas.map(pregunta => ({ value: pregunta.clave_pregunta, label: pregunta.descripcion }));
  //const menuItems = preguntas.map(pregunta => ({ value: pregunta.clave_pregunta, label: pregunta.clave_pregunta }));

  //console.log(preguntas.data);
  //console.log("MenuItems: " + menuItems);

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
              <FormControl>
                <FormLabel id="tipo-preguntas"></FormLabel>
                <RadioGroup
                  aria-labelledby="tipo-preguntas"
                  name="radio-buttons-group"
                >
                  <FormControlLabel value="Rango" control={<Radio />} label="Rango" />
                  <FormControlLabel value="Abierta" control={<Radio />} label="Abierta" />
                </RadioGroup>
              </FormControl>
            </p>
            <p className="altas-text3">Dirigido a:
              <FormControl>
                <FormLabel id="dirigido-preguntas"></FormLabel>
                <RadioGroup
                  aria-labelledby="dirigido-preguntas"
                  name="radio-buttons-group"
                >
                  <FormControlLabel value="Profesor" control={<Radio />} label="Profesor" />
                  <FormControlLabel value="Materia" control={<Radio />} label="Materia" />
                  <FormControlLabel value="Bloque" control={<Radio />} label="Bloque" />
                </RadioGroup>
              </FormControl>
            </p>
            <p className="altas-text4">
              <Button variant="contained">Guardar</Button>
            </p>
          </div>
          <div className="preguntas-middle">
            <div className="grey-container-middle1">
              <h2 className="box-title">Archivar</h2>
              <p className="bajas-text1">
                <FormControl fullWidth>
                  <InputLabel id="demo-simple-select-label">Pregunta</InputLabel>
                  <Select
                    labelId="demo-simple-select-label"
                    id="demo-simple-select"
                    label="Pregunta"
                    value={selectedOption}
                    onChange={handleSelectChange}
                  >
                    {MenuItems.map(menuItem => (
                      <MenuItem key={menuItem.value} value={menuItem.value}>
                        {menuItem.value}
                      </MenuItem>
                    ))}
                  </Select>
                </FormControl>
              </p>
              <p className="archivar-text1">
                <TextField fullWidth label={selectedOption ? MenuItems.find(item => item.value === selectedOption).label : ""} id="Descripción" />
              </p>
              <p className="bajas-text2">
                <Button variant="contained">Archivar</Button>
              </p>
            </div>
            <div className="grey-container-middle2">
              <h2 className="box-title">Desarchivar</h2>
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
              <p className="archivar-text1">
                <TextField fullWidth label="Descripción" id="Descripción" />
              </p>
              <p className="bajas-text2">
                <Button variant="contained">Archivar</Button>
              </p>
            </div>
          </div>
          <div className="preguntas-grey-container">
            <h2 className="box-title">Cambios</h2>
            <p className="altas-text1">Clave:
              <TextField id="filled-basic" label="Identificador único" variant="outlined" />
            </p>
            <p className="altas-text1">Pregunta:
              <TextField id="filled-basic" label="Descripción" variant="outlined" />
            </p>
            <p className="altas-text2">Tipo:
              <FormControl>
                <FormLabel id="tipo-preguntas"></FormLabel>
                <RadioGroup
                  aria-labelledby="tipo-preguntas"
                  name="radio-buttons-group"
                >
                  <FormControlLabel value="Rango" control={<Radio />} label="Rango" />
                  <FormControlLabel value="Abierta" control={<Radio />} label="Abierta" />
                </RadioGroup>
              </FormControl>
            </p>
            <p className="altas-text3">Dirigido a:
              <FormControl>
                <FormLabel id="dirigido-preguntas"></FormLabel>
                <RadioGroup
                  aria-labelledby="dirigido-preguntas"
                  name="radio-buttons-group"
                >
                  <FormControlLabel value="Profesor" control={<Radio />} label="Profesor" />
                  <FormControlLabel value="Materia" control={<Radio />} label="Materia" />
                  <FormControlLabel value="Bloque" control={<Radio />} label="Bloque" />
                </RadioGroup>
              </FormControl>
            </p>
            <p className="altas-text4">
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