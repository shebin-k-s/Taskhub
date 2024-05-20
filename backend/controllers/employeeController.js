import bcrypt from 'bcrypt'
import Employee from '../models/employee.js';
import nodemailer from 'nodemailer'
import Skill from '../models/skills.js';

export const createEmployee = async (req, res) => {
    const { eName, email, skills, password } = req.body;
    console.log(req.body);
    try {
        let existingEmployee = await Employee.findOne({ email });

        if (existingEmployee) {
            return res.status(400).json({ message: "email already exists" });
        }

        const hashedPassword = bcrypt.hashSync(password, 10);

        const newEmployee = new Employee({
            eName,
            email,
            password: hashedPassword
        });
        await newEmployee.save();

        const newSkills = [];
        for (const skillName of skills) {
            const lowercaseSkillName = skillName.toLowerCase();

            const existingSkill = await Skill.findOne({ sName: lowercaseSkillName });

            if (existingSkill) {
                existingSkill.eId.push(newEmployee._id);
                await existingSkill.save();
            } else {
                newSkills.push({
                    sName: lowercaseSkillName,
                    eId: [newEmployee._id]
                });
            }
        }

        if (newSkills.length > 0) {
            await Skill.insertMany(newSkills);
        }

        res.status(201).json({ message: 'Employee created successfully' });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};


export const loginEmployee = async (req, res) => {

    const { email, password } = req.body;
    try {
        let employee = await Employee.findOne({ email });

        if (!employee) {
            return res.status(404).json({ message: "email doesn't exist" })
        }
        const isPasswordCorrect = bcrypt.compareSync(password, employee.password);
        if (!isPasswordCorrect) {

            return res.status(401).json({ message: "Incorrect Password" })
        } else {
            return res.status(200).json({
                message: "Login Successfull",
                name: employee.eName,
                email: employee.email,
                admin: false,
                eId: employee._id
            })
        }


    } catch (error) {
        return res.status(500).json({ message: "Internal server error" })

    }
}

export const forgetPassword = async (req, res) => {
    const { email } = req.body;

    try {
        let employee = await Employee.findOne({ email });

        if (!employee) {
            console.log("here");
            return res.status(404).json({ message: "employee doesn't exist" });
        }

        const secret = process.env.JWT_TOKEN + employee.password;
        const payload = {
            email: employee.email,
            id: employee._id
        };
        const token = Jwt.sign(payload, secret, { expiresIn: '15min' });

        const transporter = nodemailer.createTransport({
            service: 'gmail',
            host: process.env.SMTP_HOST,
            port: process.env.SMTP_PORT,
            auth: {
                user: process.env.SMTP_USER,
                pass: process.env.SMTP_PASS
            }
        });

        const mailOptions = {
            from: "saroninnovations",
            to: employee.email,
            subject: 'Password Reset',
            text: `Your token for reseting password is\n ${token}`
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                return res.status(500).json({ message: 'Failed to send reset password email' });
            } else {
                return res.status(200).json({ message: 'Reset password email sent successfully' });
            }
        });

    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Internal server error' });
    }
};

export const resetPassword = async (req, res) => {
    const { email, token, password } = req.body;
    try {

        let employee = await Employee.findOne({ email });

        if (!employee) {
            return res.status(404).json({ message: "employee doesn't exist" });
        }


        const secret = process.env.JWT_TOKEN + employee.password;
        try {
            const decodedToken = Jwt.verify(token, secret)
        } catch (error) {
            return res.status(401).json({ message: 'Invalid or expired token' });
        }

        const hashedPassword = bcrypt.hashSync(password, 10);

        employee.password = hashedPassword;

        await employee.save();

        return res.status(200).json({ message: 'Password reset successful' });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Internal server error' });

    }
}


export const getAllEmployeeDetails = async (req, res) => {
    try {
        const employees = await Employee.find().sort({ _id: -1 });
        ;

        const employeesWithSkills = [];

        for (const employee of employees) {
            const employeeSkills = await Skill.find({ eId: employee._id });

            const skillNames = employeeSkills.map(skill => skill.sName);

            employeesWithSkills.push({
                eName: employee.eName,
                email: employee.email,
                skills: skillNames
            });
        }

        res.status(200).json({ employees: employeesWithSkills });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

export const getEmployeeSkills = async (req, res) => {
    try {
        const { eId } = req.query;
        console.log(eId);
        const employeeSkills = await Skill.find({ eId }).select('sName')

        console.log(employeeSkills);

        return res.status(200).json({ employeeSkills: employeeSkills });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Internal server error' });
    }
};
