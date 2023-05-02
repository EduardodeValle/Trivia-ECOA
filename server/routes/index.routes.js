import { Router } from 'express'
import { getUser, getStudentSurvey } from '../controllers/index.controllers.js'

const router = Router();

router.post('/user', getUser)

router.post('/student-survey', getStudentSurvey)

router.get('/getSurveys', getSurveys)

export default router;