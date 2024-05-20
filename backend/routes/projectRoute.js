import express from 'express'
import { addProject, getProjectsForAdmin, getProjectsForEmp } from '../controllers/projectController.js'

const router = express.Router()

router.route("/add")
    .post(addProject)

router.route("/get-emp-projects")
    .get(getProjectsForEmp)

router.route("/get-projects")
    .get(getProjectsForAdmin)

export default router