import React from 'react';
import './Encuestas.css';
import OutlinedInput from '@mui/material/OutlinedInput/index.js';
import InputLabel from '@mui/material/InputLabel/index.js';
import MenuItem from '@mui/material/MenuItem/index.js';
import FormControl from '@mui/material/FormControl/index.js';
import ListItemText from '@mui/material/ListItemText/index.js';
import Select from '@mui/material/Select/index.js';
import Checkbox from '@mui/material/Checkbox/index.js';
import TextField from '@mui/material/TextField/index.js';
import Button from '@mui/material/Button/index.js';
import ArrowBackIcon from '@mui/icons-material/esm/ArrowBack.js';
import { useNavigate } from 'react-router-dom';


const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;
const MenuProps = {
  PaperProps: {
    style: {
      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
      width: 250,
    },
  },
};

const names = [
  'Pregunta 1',
  'Pregunta 2',
  'Pregunta 3',
  'Pregunta 4',
  'Pregunta 5',
  'Pregunta 6',
];

function Encuestas() {
  const [personName, setPersonName] = React.useState([]);

  const handleChange = (event) => {
    const {
      target: { value },
    } = event;
    setPersonName(
      // On autofill we get a stringified value.
      typeof value === 'string' ? value.split(',') : value,
    );
  };

  const navigate = useNavigate();
  const handleRegresar = () => {
    navigate('/admin');
  };


  return (
    <div>
      <main className="encuestas-container">
        <h1 className="encuestas-title">Configuración de Encuestas</h1>
        <div className="encuestas-main">

          <div className="encuestas-grey-container">
            <h2 className="box-title">Crear</h2>
            <div className="crear-text1">
                <TextField fullWidth label="Identificador único" id="Identificador único" />
            </div>
            <div className="crear-text1">
                <TextField fullWidth label="Descripción" id="Descripción" />
            </div>
            <div className="crear-text2"> Preguntas:
                <FormControl sx={{ m: 1, width: 300 }}>
                <InputLabel id="demo-multiple-checkbox-label">Selecciona</InputLabel>
                <Select
                    labelId="demo-multiple-checkbox-label"
                    id="demo-multiple-checkbox"
                    multiple
                    value={personName}
                    onChange={handleChange}
                    input={<OutlinedInput label="Selecciona" />}
                    renderValue={(selected) => selected.join(', ')}
                    MenuProps={MenuProps}
                >
                    {names.map((name) => (
                    <MenuItem key={name} value={name}>
                        <Checkbox checked={personName.indexOf(name) > -1} />
                        <ListItemText primary={name} />
                    </MenuItem>
                    ))}
                </Select>
                </FormControl>
            </div>
            <p className="crear-text4">
                <Button variant="contained">Guardar</Button>
            </p>
          </div>

          <div className="encuestas-grey-container">
            <h2 className="box-title">Archivar</h2>
            <div className="crear-text1">
              <FormControl fullWidth>
                  <InputLabel id="demo-simple-select-label">Identificador Único</InputLabel>
                  <Select
                      labelId="demo-simple-select-label"
                      id="demo-simple-select"
                      label="Identificador Único"
                  >
                      <MenuItem>Pregunta 1</MenuItem>
                      <MenuItem>Pregunta 2</MenuItem>
                      <MenuItem>Pregunta 3</MenuItem>
                  </Select>
              </FormControl>
            </div>
            <div className="crear-text1">
                <TextField fullWidth label="Descripción" id="Descripción" />
            </div>
            <div className="archivar-text11">
              <FormControl fullWidth>
                  <InputLabel id="demo-simple-select-label">Observar Preguntas</InputLabel>
                  <Select
                      labelId="demo-simple-select-label"
                      id="demo-simple-select"
                      label="Observar Preguntas"
                  >
                      <MenuItem>Pregunta 1</MenuItem>
                      <MenuItem>Pregunta 2</MenuItem>
                      <MenuItem>Pregunta 3</MenuItem>
                  </Select>
              </FormControl>
            </div>
            <p className="archivar-text21">
                <Button variant="contained">Archivar</Button>
            </p>
          </div>

          <div className="encuestas-grey-container">
            <h2 className="box-title">Desarchivar</h2>
            <div className="crear-text1">
              <FormControl fullWidth>
                  <InputLabel id="demo-simple-select-label">Identificador Único</InputLabel>
                  <Select
                      labelId="demo-simple-select-label"
                      id="demo-simple-select"
                      label="Identificador Único"
                  >
                      <MenuItem>Pregunta 1</MenuItem>
                      <MenuItem>Pregunta 2</MenuItem>
                      <MenuItem>Pregunta 3</MenuItem>
                  </Select>
              </FormControl>
            </div>
            <div className="crear-text1">
                <TextField fullWidth label="Descripción" id="Descripción" />
            </div>
            <div className="archivar-text11">
              <FormControl fullWidth>
                  <InputLabel id="demo-simple-select-label">Observar Preguntas</InputLabel>
                  <Select
                      labelId="demo-simple-select-label"
                      id="demo-simple-select"
                      label="Observar Preguntas"
                  >
                      <MenuItem>Pregunta 1</MenuItem>
                      <MenuItem>Pregunta 2</MenuItem>
                      <MenuItem>Pregunta 3</MenuItem>
                  </Select>
              </FormControl>
            </div>
            <p className="archivar-text21">
                <Button variant="contained">Desarchivar</Button>
            </p>
          </div>

        </div>
      </main>
      <div className="arrow-back-icon">
        <Button variant="contained" onClick={handleRegresar} startIcon={<ArrowBackIcon />}></Button>
      </div>
    </div>
  );
}

export default Encuestas;