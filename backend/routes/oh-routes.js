const express = require('express');
const router = express.Router();
const ohController = require('../controllers/ohController');

// --- ÁREAS (DEFINIÇÕES) ---
router.get('/areas', ohController.getAreas);
router.post('/areas', ohController.createArea);
router.put('/areas/:id', ohController.updateArea);
router.delete('/areas/:id', ohController.deleteArea);

// --- ESCALA (TAREFAS DIÁRIAS) ---
router.get('/schedule', ohController.getSchedule); // Popula a tela principal
router.patch('/task/:id', ohController.updateTask); // Atualiza status ou atribui morador
router.post('/rotate', ohController.autoRotate); // Botão Auto Escalar

module.exports = router;