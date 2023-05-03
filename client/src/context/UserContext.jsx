import React, {createContext, useState} from 'react';

const UserContext = createContext();

const UserProvider = (props) => {
    const [msg, setMSG] = useState('');
    const [preguntas, setPreguntas] = useState([]);
    const [encuestas, setEncuestas] = useState([]);
  
    return (
      <MyContext.Provider
        value={{
          msg,
          setMSG,
          preguntas,
          setPreguntas,
          preguntasArchivadas,
          setPreguntasArchivadas,
          encuestas,
          setEncuestas
        }}
      >
        {props.children}
      </MyContext.Provider>
    );
};
  
export { UserContext, UserProvider };