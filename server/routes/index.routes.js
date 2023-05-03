import { Router } from 'express'
import { getUser, getStudentSurvey, getSurveys, getQuestions, postQuestion, archiveQuestion, unarchiveQuestion, updateQuestion, postSurvey, archiveSurvey, unarchiveSurvey, activateSurvey, getTeachersQuestions, getSubjectsQuestions, getCoreSubjectsQuestions, finishSurvey } from '../controllers/index.controllers.js'

const router = Router();

router.post('/user', getUser)

router.post('/student-survey', getStudentSurvey)

router.post('/getSurveys', getSurveys)

router.post('/getQuestions', getQuestions)

router.post('/archiveQuestion', archiveQuestion)

router.post('/unarchiveQuestion', unarchiveQuestion)

router.post('/postQuestion', postQuestion)

router.post('/postSurvey', postSurvey)

router.post('/updateQuestion', updateQuestion)

router.post('/activateSurvey', activateSurvey)

router.get('/finishSurvey', finishSurvey)

router.post('/archiveSurvey', archiveSurvey)

router.post('/unarchiveSurvey', unarchiveSurvey);

router.post('/getTeachersQuestions', getTeachersQuestions)

router.post('/getSubjectsQuestions', getSubjectsQuestions) 

router.post('/getCoreSubjectsQuestions', getCoreSubjectsQuestions)

export default router;