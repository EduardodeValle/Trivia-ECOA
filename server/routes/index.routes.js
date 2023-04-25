import { Router } from 'express'
import { getUser } from '../controllers/index.controllers.js'

const router = Router();

router.post('/user', getUser)

export default router;