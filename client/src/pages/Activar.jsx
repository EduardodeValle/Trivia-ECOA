import React, { useState, useContext, useEffect } from 'react';
import './Activar.css';
import InputLabel from '@mui/material/InputLabel/index.js';
import MenuItem from '@mui/material/MenuItem/index.js';
import FormControl from '@mui/material/FormControl/index.js';
import Select from '@mui/material/Select/index.js';
import { DemoContainer } from '@mui/x-date-pickers/internals/demo/index.js';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs/index.js';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider/index.js';
import { DatePicker } from '@mui/x-date-pickers/DatePicker/index.js';
import Button from '@mui/material/Button/index.js';
import ArrowBackIcon from '@mui/icons-material/esm/ArrowBack.js';
import { useNavigate } from 'react-router-dom';
import { UserContext } from '../context/UserContext.jsx'
import { SetDatesSurvey } from '../api/tasks.api.js'
import TextField from '@mui/material/TextField';

function Activar() {

  const { encuestas } = useContext(UserContext);

  const navigate = useNavigate();
  const handleRegresar = () => {
    navigate('/admin');
  };

  const [clave_encuesta, setClave] = useState("");
  const [descripcion, setDescripcion] = useState("");
  const [fecha_inicio, set_fecha_inicio] = useState("");
  const [fecha_final, set_fecha_final] = useState("");
  const [selectedOption1Description, setSelectedOption1Description] = useState("");
  const [selectedOption1, setSelectedOption1] = useState(""); // actualiza los valores del FormControl para seleccionar una encuesta

  const handleSelectChange1 = (event) => {
    setSelectedOption1(event.target.value);
    setClave(event.target.value); // obtener el nuevo valor para archivar una encuesta
  };

  useEffect(() => {
    if (selectedOption1) {
      const selectedEncuesta = encuestas.find(encuesta => encuesta.clave_encuesta === selectedOption1);
      setSelectedOption1Description(selectedEncuesta.descripcion);
    } else {
      setSelectedOption1Description("");
    }
  }, [selectedOption1]);

  const setDatesSurvey = async () => {
    const fechaInicioObjeto = new Date(fecha_inicio); 
    const fechaFinalObjeto = new Date(fecha_final); 

    const fechaInicioFormateada = `${fechaInicioObjeto.getFullYear()}-${fechaInicioObjeto.getMonth() + 1}-${fechaInicioObjeto.getDate()}`;
    const fechaFinalFormateada = `${fechaFinalObjeto.getFullYear()}-${fechaFinalObjeto.getMonth() + 1}-${fechaFinalObjeto.getDate()}`;

    //console.log("Activando la encuesta " + clave_encuesta + " para las fechas " + fechaInicioFormateada + " - " + fechaFinalFormateada);

    const data = {
      clave_encuesta: clave_encuesta,
      fecha_inicio: fechaInicioFormateada,
      fecha_final: fechaFinalFormateada
    };
    const response = await SetDatesSurvey(data);
  };

  return (
    <div>
      <main className="activar-container">
        <h1 className="activar-title">Activación de Encuestas</h1>
        <div className="activar-main">
          <div className="activar-grey-container">
            <h2 className="box-title">Confirmar Encuesta</h2>
            <div className="config-text1">
              <FormControl fullWidth>
                <InputLabel id="demo-simple-select-label">Identificador Único</InputLabel>
                <Select
                  labelId="demo-simple-select-label"
                  id="demo-simple-select"
                  label="Identificador Único"
                  value={selectedOption1}
                  onChange={handleSelectChange1}
                >
                  {encuestas.map(encuesta => (
                    <MenuItem key={encuesta.clave_encuesta} value={encuesta.clave_encuesta}>
                      {encuesta.clave_encuesta}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            </div>
            <div className="config-text1">
              <TextField fullWidth label="Descripción" value={selectedOption1Description} id="Descripción" />
            </div>
            <div>
              <div className="config-text2">
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                  <DemoContainer components={['DatePicker']}>
                    <DatePicker label="Fecha Inicio" onChange={(date) => set_fecha_inicio(date)} value={fecha_inicio} />
                  </DemoContainer>
                </LocalizationProvider>

                <LocalizationProvider dateAdapter={AdapterDayjs}>
                  <DemoContainer components={['DatePicker']}>
                    <DatePicker label="Fecha Final" onChange={(date) => set_fecha_final(date)} value={fecha_final} />
                  </DemoContainer>
                </LocalizationProvider>
              </div>
            </div>
            <div className="config-text3">
              <Button variant="contained" onClick={setDatesSurvey}>Activar</Button>
            </div>
          </div>
        </div>
      </main>
      <div className="arrow-back-icon3">
        <Button variant="contained" onClick={handleRegresar} startIcon={<ArrowBackIcon />}></Button>
      </div>
    </div>
  );
}

export default Activar;