import Admin from "../models/admin.js";
import bcrypt from 'bcrypt'

export const signupAdmin = async (req, res) => {
    console.log(req.body);
    const { name, email, password } = req.body


    try {
        let existingUser = await Admin.findOne({ email })

        if (existingUser) {
            return res.status(400).json({ message: "email already exists" })
        }
        const hashedPassword = bcrypt.hashSync(password, 10);

        const newAdmin = new Admin({
            name,
            email,
            password: hashedPassword
        });


        await newAdmin.save();

        res.status(201).json({ message: "Admin created successfully" });
    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" })
    }
}

export const loginAdmin = async (req, res) => {

    const { email, password } = req.body;
    console.log(req.body);
    try {
        let admin = await Admin.findOne({ email });

        if (!admin) {
            return res.status(404).json({ message: "email doesn't exist" })
        }
        const isPasswordCorrect = bcrypt.compareSync(password, admin.password);
        if (!isPasswordCorrect) {

            return res.status(401).json({ message: "Incorrect Password" })
        } else {
            return res.status(200).json({
                message: "Login Successfull",
                name:admin.name,
                admin: true,
                email: admin.email
            })
        }


    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal server error" })

    }
}
export const forgetPassword = async (req, res) => {
    const { email } = req.body;

    try {
        let admin = await Admin.findOne({ email });

        if (!admin) {
            return res.status(404).json({ message: "Admin doesn't exist" });
        }

        const secret = process.env.JWT_TOKEN + Admin.password;
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

        let admin = await Admin.findOne({ email });

        if (!admin) {
            return res.status(404).json({ message: "Admin doesn't exist" });
        }


        const secret = process.env.JWT_TOKEN + admin.password;
        try {
            const decodedToken = Jwt.verify(token, secret)
        } catch (error) {
            return res.status(401).json({ message: 'Invalid or expired token' });
        }

        const hashedPassword = bcrypt.hashSync(password, 10);

        admin.password = hashedPassword;

        await admin.save();

        return res.status(200).json({ message: 'Password reset successful' });

    } catch (error) {
        console.log(error);
        return res.status(500).json({ message: 'Internal server error' });

    }
}