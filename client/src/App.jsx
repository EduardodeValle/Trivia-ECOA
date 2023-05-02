import { Route, Routes } from 'react-router-dom'
import Header from './components/Header.jsx'
import Footer from './components/Footer.jsx'
import Login from './pages/Login.jsx'
import StudentSurvey from './pages/StudentSurvey.jsx'
import Student from './pages/Student.jsx'
import Teacher from './pages/Teacher.jsx'
import Admin from './pages/Admin.jsx'
import Preguntas from './pages/Preguntas.jsx'
import Encuestas from './pages/Encuestas.jsx';
import Activar from './pages/Activar.jsx';
import NotFound from './pages/NotFound.jsx'
import { UserContext } from './context/UserContext.jsx'
import React, {useState} from 'react'
import 'bootstrap/dist/css/bootstrap.min.css';

function App() {
  return (
    <>
      <Header />
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/student-survey" element={<StudentSurvey />} />
        <Route path="/student" element={<Student />} />
        <Route path="/teacher" element={<Teacher />} />
        <Route path="/admin" element={<Admin />} />
        <Route path="/preguntas" element={<Preguntas />} />
        <Route path="/encuestas" element={<Encuestas />} />
        <Route path="/activar" element={<Activar />} />
        <Route path="*" element={<NotFound />} />
      </Routes>
      <Footer />
    </>
  )
}

function AppWithContext() {
  const [msg, setMSG] = useState('');
  const [preguntas, setPreguntas] = useState([]);
  const [encuestas, setEncuestas] = useState([]);
  return (
    <UserContext.Provider value={{ msg, setMSG, preguntas, setPreguntas, encuestas, setEncuestas }}>
      <App />
    </UserContext.Provider>
  );
}

export default AppWithContext;