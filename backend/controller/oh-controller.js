const ohService = require('../services/ohService');

exports.getSchedule = async (req, res) => {
    try {
        const schedule = await ohService.getWeeklySchedule();
        res.status(200).json(schedule);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.getAreas = async (req, res) => {
    try {
        const areas = await ohService.getAllAreas();
        res.status(200).json(areas);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.createArea = async (req, res) => {
    try {
        // Body: { name: "Cozinha", isPriority: true, checklist: ["Lavar", "Secar"] }
        const newArea = await ohService.createArea(req.body);
        res.status(201).json(newArea);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.updateArea = async (req, res) => {
    try {
        const updatedArea = await ohService.updateArea(req.params.id, req.body);
        res.status(200).json(updatedArea);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.deleteArea = async (req, res) => {
    try {
        await ohService.deleteArea(req.params.id);
        res.status(200).json({ message: "Área removida" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.updateTask = async (req, res) => {
    try {
        // Params: id da tarefa (não da área)
        // Body: { status: "concluida", ownerId: "12345" }
        const updatedTask = await ohService.updateTask(req.params.id, req.body);
        res.status(200).json(updatedTask);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

exports.autoRotate = async (req, res) => {
    try {
        const result = await ohService.autoRotateSchedule();
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};