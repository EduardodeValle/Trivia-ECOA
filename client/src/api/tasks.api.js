import axios from 'axios'

export const RequestLogin = async (credentials) =>
    await axios.post('http://localhost:4000/user', credentials)

export const RequestStudentSurvey = async (matricula) =>
    await axios.post('http://localhost:4000/student-survey', matricula)

export const RequestQuestions = async (archivado) =>
    await axios.post('http://localhost:4000/getQuestions', archivado)

export const ArchiveQuestion = async (data) =>
    await axios.post('http://localhost:4000/archiveQuestion', data)

export const UnarchiveQuestion = async (data) =>
    await axios.post('http://localhost:4000/unarchiveQuestion', data)

export const UpdateQuestion = async (data) =>
    await axios.post('http://localhost:4000/updateQuestion', data)

export const RequestSurveys = async (archivada) =>
    await axios.post('http://localhost:4000/getSurveys', archivada)

export const PostQuestion = async (data) =>
    await axios.post('http://localhost:4000/postQuestion', data)

export const PostSurvey = async (data) =>
    await axios.post('http://localhost:4000/postSurvey', data)