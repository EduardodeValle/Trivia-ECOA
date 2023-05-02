import './Student.css';
import {useContext} from 'react'
import { UserContext } from '../context/UserContext.jsx'

function Student() {
    const { msg } = useContext(UserContext);
    return (
        <h3 className="center margin-top">No hay encuestas disponibles, que tengas un excelente día</h3>
    )
}

export default Student