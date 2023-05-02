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
import { postQuestion } from '../api/tasks.api.js'
import { UserContext } from '../context/UserContext.jsx'
import { useNavigate } from 'react-router-dom';

function Preguntas() {

  const [clave_pregunta, setClave] = useState("");
  const [descripcion, setDescripcion] = useState("");
  const [tipo, setTipo] = useState("");
  const [dirigido, setDirigido] = useState("");

  // funcion que agrega nuevas preguntas a la base de datos
  const newQuestion = async () => {
    console.log(clave_pregunta + " " + descripcion + " " + tipo + " " + dirigido);
    const data = {
      clave_pregunta: clave_pregunta,
      descripcion: descripcion,
      tipo: tipo,
      dirigido_a: dirigido
    };
    const response = await postQuestion(data);
  };

  const navigate = useNavigate();
  const handleRegresar = () => {
    navigate('/admin');
  };

  const { preguntas } = useContext(UserContext);

  const [selectedOption1, setSelectedOption1] = useState("");
  const [selectedOption2, setSelectedOption2] = useState("");
  const [selectedOption3, setSelectedOption3] = useState("");

  const handleSelectChange1 = (event) => {
    setSelectedOption1(event.target.value);
  };

  const handleSelectChange2 = (event) => {
    setSelectedOption2(event.target.value);
  };

  const handleSelectChange3 = (event) => {
    setSelectedOption3(event.target.value);
  };

  const MenuItems = preguntas.map(pregunta => ({ value: pregunta.clave_pregunta, label: pregunta.descripcion }));

  return (
    <div>
      <main className="preguntas-container">
        <h1 className="preguntas-title">Configuración de Preguntas</h1>
        <div className="preguntas-main">
          <div className="preguntas-grey-container">
            <h2 className="box-title">Altas</h2>
            <p className="altas-text1">Clave:
              <TextField id="filled-basic" label="Identificador único" variant="outlined" onChange={(e) => setClave(e.target.value)}/>
            </p>
            <p className="altas-text1">Pregunta:
              <TextField id="filled-basic" label="Descripción" variant="outlined" onChange={(e) => setDescripcion(e.target.value)}/>
            </p>
            <p className="altas-text2">Tipo:
              <FormControl>
                <FormLabel id="tipo-preguntas"></FormLabel>
                <RadioGroup
                  aria-labelledby="tipo-preguntas"
                  name="radio-buttons-group"
                  onChange={(e) => setTipo(e.target.value)}
                >
                  <FormControlLabel value="Cerrada" control={<Radio />} label="Cerrada" />
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
                  onChange={(e) => setDirigido(e.target.value)}
                >
                  <FormControlLabel value="Profesor" control={<Radio />} label="Profesor" />
                  <FormControlLabel value="Materia" control={<Radio />} label="Materia" />
                  <FormControlLabel value="Bloque" control={<Radio />} label="Bloque" />
                </RadioGroup>
              </FormControl>
            </p>
            <p className="altas-text4">
              <Button variant="contained" onClick={newQuestion}>Guardar</Button>
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
                    value={selectedOption1}
                    onChange={handleSelectChange1}
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
                <TextField fullWidth label="" value={selectedOption1 ? MenuItems.find(item => item.value === selectedOption1).label : ""} id="descripcion_1" InputProps={{readOnly: true,}} />
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
                    value={selectedOption2}
                    onChange={handleSelectChange2}
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
                <TextField fullWidth label="" value={selectedOption2 ? MenuItems.find(item => item.value === selectedOption2).label : ""} id="descripcion_2" InputProps={{readOnly: true,}}  />
              </p>
              <p className="bajas-text2">
                <Button variant="contained">Archivar</Button>
              </p>
            </div>
          </div>
          <div className="preguntas-grey-container">
            <h2 className="box-title">Cambios</h2>
            <p className="bajas-text1">
              <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Pregunta</InputLabel>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  label="Pregunta"
                  value={selectedOption3}
                  onChange={handleSelectChange3}
                >
                  {MenuItems.map(menuItem => (
                    <MenuItem key={menuItem.value} value={menuItem.value}>
                      {menuItem.value}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </p>
            <p className="altas-text1">
            <TextField fullWidth label="" value={selectedOption3 ? MenuItems.find(item => item.value === selectedOption3).label : ""} id="descripcion_3" />
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