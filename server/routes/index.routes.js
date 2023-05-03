import { Router } from 'express'
import { getUser, getStudentSurvey, getSurveys, getQuestions, postQuestion, archiveQuestion, unarchiveQuestion, updateQuestion, activateSurvey, finishSurvey } from '../controllers/index.controllers.js'

const router = Router();

router.post('/user', getUser)

router.post('/student-survey', getStudentSurvey)

router.get('/getSurveys', getSurveys)

router.post('/getQuestions', getQuestions)

router.post('/archiveQuestion', archiveQuestion)

router.post('/unarchiveQuestion', unarchiveQuestion)

router.post('/postQuestion', postQuestion)

router.post('/updateQuestion', updateQuestion)

router.post('/activateSurvey', activateSurvey)

router.get('/finishSurvey', finishSurvey)

export default router;