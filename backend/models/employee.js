import mongoose from "mongoose"

const employeeSchema = new mongoose.Schema({
    eId: {
        type: Number,
        unique: true
    },
    eName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        required: true
    },
    availDate: {
        type: Date,
    },
    password: {
        type: String,
        required: true
    }

})
employeeSchema.pre('save', async function (next) {
    if (!this.eId) {
        try {
            const count = await Employee.countDocuments();
            this.eId = count + 1;
            next();
        } catch (error) {
            next(error);
        }
    } else {
        next();
    }
});

const Employee = mongoose.model('Employee', employeeSchema);

export default Employee