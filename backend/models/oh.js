const mongoose = require('mongoose');

const OHSchema = new mongoose.Schema({
    areaName: { type: String, required: true },
    dayOfWeek: { type: String, required: true }, // e.g., "Segunda-Feira"
    status: { 
        type: String, 
        enum: ['livre', 'ocupado', 'pendente', 'concluida'],
        default: 'livre' 
    },
    assignedTo: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null },
    isPriority: { type: Boolean, default: false },
    checklist: [{ type: String }], // Array of tasks
    evidencePhoto: { type: String }, // URL to image (uploaded via ohs-upload.dart)
    evaluatedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' }
});

module.exports = mongoose.model('OH', OHSchema);