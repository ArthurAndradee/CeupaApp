const mongoose = require('mongoose');

const OhAreaSchema = new mongoose.Schema({
    name: { type: String, required: true },
    isPriority: { type: Boolean, default: false },
    checklist: [{ type: String }] // Array de strings para as tarefas
});

module.exports = mongoose.model('OhArea', OhAreaSchema);