import mongoose from "mongoose"

const projectSchema = new mongoose.Schema({
    pName: {
        type: String,
        required: true,
    },
    startDate: {
        type: Date,
        required: true,
    },
    endDate: {
        type: Date,
        required: true,
    },
    Skill: [{
        type: String,
        required:true
    }]
})

const Project = mongoose.model('Project', projectSchema);

export default Project