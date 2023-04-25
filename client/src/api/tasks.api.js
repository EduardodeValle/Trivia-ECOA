import axios from 'axios'

export const RequestLogin = async (credentials) =>
    await axios.post('http://localhost:4000/user', credentials)