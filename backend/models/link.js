const mongoose = require('mongoose');

const LinkSchema = new mongoose.Schema({
    title: { type: String, required: true },
    content: { type: String, required: true }, // The URL, Password, or Pix Key
    type: { 
        type: String, 
        enum: ['link', 'info', 'wifi'], 
        required: true 
    }
});

module.exports = mongoose.model('Link', LinkSchema);