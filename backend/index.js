import express from "express";
import mongoose from "mongoose";
import dotenv from 'dotenv';
import { adminRoute, employeeRoute, projectRoute } from "./routes/index.js";
 

dotenv.config();

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));



app.use("/employee", employeeRoute);
app.use("/projects", projectRoute);
app.use("/admin", adminRoute);


const PORT = process.env.PORT || 5000;






mongoose.connect(process.env.CONNECTION_URL)
    .then(() => {
        const server = app.listen(PORT, () => {
            console.log(`Server running at ${PORT}`);
        });


    })
    .catch((error) => {
        console.log(error);
    });
