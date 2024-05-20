import mongoose from "mongoose"

const workSchema = new mongoose.Schema({
    pId: {
        type: mongoose.Schema.Types.ObjectId,
        ref:'Project',
        required: true,
    },
    eId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Employee'
    },
    techName: {
        type: String,
        required: true
    },
    startDate: {
        type:Date,
        required:true
    },
    endDate:{
        type: Date,
        required: true
    },
    status: {
        type: String,
        enum: ['PENDING', 'INPROGRESS', 'COMPLETE'],
        default: 'PENDING'
    }
})

const Work = mongoose.model('Work', workSchema);

export default Work