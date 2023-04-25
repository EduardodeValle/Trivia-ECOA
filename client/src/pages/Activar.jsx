import React from 'react';
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


function Activar() {

    const navigate = useNavigate();
    const handleRegresar = () => {
        navigate('/admin');
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
                <InputLabel id="demo-simple-select-label">Encuesta</InputLabel>
                <Select
                    labelId="demo-simple-select-label"
                    id="demo-simple-select"
                    label="Encuesta"
                >
                    <MenuItem>Pregunta 1</MenuItem>
                    <MenuItem>Pregunta 2</MenuItem>
                    <MenuItem>Pregunta 3</MenuItem>
                </Select>
            </FormControl>
            </div>
            <div>
                <div className="config-text2">
                    <LocalizationProvider dateAdapter={AdapterDayjs}>
                        <DemoContainer components={['DatePicker']}>
                            <DatePicker label="Fecha Inicio" />
                        </DemoContainer>
                    </LocalizationProvider>

                    <LocalizationProvider dateAdapter={AdapterDayjs}>
                        <DemoContainer components={['DatePicker']}>
                            <DatePicker label="Fecha Fin" />
                        </DemoContainer>
                    </LocalizationProvider>
                </div>
            </div>
            <div className="config-text3">
                <Button variant="contained">Activar</Button>
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