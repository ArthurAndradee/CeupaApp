const mongoose = require('mongoose');

const WashingSlotSchema = new mongoose.Schema({
    day: { type: String, required: true },
    startTime: { type: String, required: true }, // e.g., "07:00"
    endTime: { type: String, required: true },   // e.g., "11:00"
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null }
});

module.exports = mongoose.model('WashingSlot', WashingSlotSchema);