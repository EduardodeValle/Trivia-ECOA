import { Router } from 'express'
import { getUser, getStudentSurvey, getSurveys, getQuestions, postQuestion, activateSurvey, finishSurvey } from '../controllers/index.controllers.js'

const router = Router();

router.post('/user', getUser)

router.post('/student-survey', getStudentSurvey)

router.get('/getSurveys', getSurveys)

router.get('/getQuestions', getQuestions)

router.post('/postQuestion', postQuestion)

router.post('/activateSurvey', activateSurvey)

router.get('/finishSurvey', finishSurvey)

export default router;