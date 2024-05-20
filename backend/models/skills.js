import mongoose from "mongoose"

const skillSchema = new mongoose.Schema({
    sName: {
        type: String,
        required: true,
    },
    eId: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Employee'
    }]
})

const Skill = mongoose.model('Skill', skillSchema);

export default Skill