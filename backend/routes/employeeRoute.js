import express from 'express'
import { createEmployee, forgetPassword, getAllEmployeeDetails, getEmployeeSkills, loginEmployee, resetPassword } from '../controllers/employeeController.js'

const router = express.Router()

router.route("/add")
    .post(createEmployee)

router.route("/login")
    .post(loginEmployee)

router.route("/forget-password")
    .post(forgetPassword)

router.route("/reset-password")
    .post(resetPassword)

router.route("/get-employees")
    .get(getAllEmployeeDetails)

router.route("/get-employee-skills")
    .get(getEmployeeSkills)
export default router