import React, {useContext} from 'react';
import 'bootstrap/dist/css/bootstrap.min.css';
import './Student.css';
import { UserContext } from '../context/UserContext.jsx'


function StudentSurvey() {
  const { msg } = useContext(UserContext);
  return (
    <div>
      <div className="container student-container">
        <h1 className="text-center mb-4"> {msg} </h1>
        <h5 className="text-center text-blue mb-4">
          ¡Juega la Trivia y Gana Premios!
        </h5>
        <div className="row justify-content-center">
          <div className="col-md-12"> {/* Adjust column size */}
            <div className="game-wrapper">
              <div className="game-container bg-light p-3">
                <iframe
                  src="../Videogame/index.html"
                  width="1200px" 
                  height="610px"
                ></iframe>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default StudentSurvey;