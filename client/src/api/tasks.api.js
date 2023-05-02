import axios from 'axios'

export const RequestLogin = async (credentials) =>
    await axios.post('http://localhost:4000/user', credentials)

export const RequestStudentSurvey = async (matricula) =>
    await axios.post('http://localhost:4000/student-survey', matricula)

export const RequestSurveys = async () =>
    await axios.get('http://localhost:4000/getSurveys')

export const RequestQuestions = async () =>
    await axios.get('http://localhost:4000/getQuestions')