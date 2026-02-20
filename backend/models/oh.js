const mongoose = require('mongoose');

const OhTaskSchema = new mongoose.Schema({
    area: { type: mongoose.Schema.Types.ObjectId, ref: 'OhArea', required: true },
    dayOfWeek: { 
        type: String, 
        required: true,
        enum: ['Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo']
    },
    owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User', default: null }, // Referência ao User
    status: { 
        type: String, 
        enum: ['livre', 'ocupado', 'pendente', 'concluida'],
        default: 'livre' 
    },
    // Snapshot dos dados da área caso a definição mude, mas opcional
    isPrioritySnapshot: { type: Boolean, default: false }
});

module.exports = mongoose.model('OhTask', OhTaskSchema);