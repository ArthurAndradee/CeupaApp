const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    house: { type: Number, required: true },
    active: { type: Boolean, default: true } // Se o morador ainda mora na casa
});

module.exports = mongoose.model('User', UserSchema);