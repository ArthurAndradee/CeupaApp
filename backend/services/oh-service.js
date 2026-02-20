const OhArea = require('../models/OhArea');
const OhTask = require('../models/OhTask');
const User = require('../models/User');

class OhService {
    
    // --- GERENCIAMENTO DE ÁREAS ---
    async createArea(data) {
        const area = await OhArea.create(data);
        // Opcional: Ao criar uma área, adicionar automaticamente tarefas "livres" para todos os dias
        await this._populateTasksForNewArea(area);
        return area;
    }

    async updateArea(id, data) {
        return await OhArea.findByIdAndUpdate(id, data, { new: true });
    }

    async deleteArea(id) {
        // Remove a definição e todas as tarefas associadas na escala
        await OhTask.deleteMany({ area: id });
        return await OhArea.findByIdAndDelete(id);
    }

    async getAllAreas() {
        return await OhArea.find();
    }

    // --- GERENCIAMENTO DA ESCALA (TASKS) ---
    
    // Retorna os dados formatados EXATAMENTE como o Flutter espera (Agrupado por dia)
    async getWeeklySchedule() {
        const days = ['Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo'];
        const tasks = await OhTask.find()
            .populate('area')
            .populate('owner', 'name'); // Traz apenas o nome do morador

        // Transforma a lista plana do DB no formato aninhado do Flutter
        const schedule = days.map(day => {
            const dayTasks = tasks.filter(t => t.dayOfWeek === day);
            
            return {
                day: day,
                tasks: dayTasks.map(t => ({
                    id: t._id, // ID da tarefa para updates
                    areaId: t.area._id,
                    area: t.area.name,
                    status: t.status,
                    owner: t.owner ? t.owner.name : "", // String vazia se null
                    ownerId: t.owner ? t.owner._id : null,
                    isPriority: t.area.isPriority,
                    checklist: t.area.checklist
                }))
            };
        });

        return schedule;
    }

    // Atualiza status ou dono de uma tarefa específica
    async updateTask(taskId, data) {
        // data pode conter { status, ownerId }
        const updatePayload = {};
        if (data.status) updatePayload.status = data.status;
        
        if (data.ownerId !== undefined) {
            // Se vier string vazia, define como null (livre)
            updatePayload.owner = data.ownerId === "" ? null : data.ownerId;
            // Se liberou o dono, status volta pra livre, se atribuiu, vira ocupado
            if (data.ownerId === "") updatePayload.status = 'livre';
            else if (data.status === 'livre') updatePayload.status = 'ocupado';
        }

        return await OhTask.findByIdAndUpdate(taskId, updatePayload, { new: true }).populate('area owner');
    }

    // --- LÓGICA DE AUTO ESCALA (ROTAÇÃO) ---
    async autoRotateSchedule() {
        const tasks = await OhTask.find().populate('area');
        
        // 1. Coleta todos os moradores escalados atualmente (excluindo nulos)
        // Set para evitar duplicatas, mas a lógica de rotação depende da ordem
        let currentOwners = tasks
            .filter(t => t.owner)
            .map(t => t.owner.toString());
        
        // Remove duplicatas mantendo a "fila" (opcional, depende da regra da casa)
        currentOwners = [...new Set(currentOwners)];

        if (currentOwners.length === 0) return { message: "Ninguém para rotacionar" };

        // 2. Rotaciona a lista (O primeiro vai para o final)
        const first = currentOwners.shift();
        currentOwners.push(first);

        // 3. Limpa a escala atual
        await OhTask.updateMany({}, { owner: null, status: 'livre' });

        // 4. Reatribui baseado na prioridade
        // Ordena tarefas: Prioridade TRUE primeiro
        const sortedTasks = tasks.sort((a, b) => {
            return (b.area.isPriority === true) - (a.area.isPriority === true);
        });

        let ownerIndex = 0;
        const updates = [];

        for (const task of sortedTasks) {
            if (ownerIndex < currentOwners.length) {
                updates.push(
                    OhTask.findByIdAndUpdate(task._id, {
                        owner: currentOwners[ownerIndex],
                        status: 'ocupado'
                    })
                );
                ownerIndex++;
            }
        }

        await Promise.all(updates);
        return { message: "Escala rotacionada com sucesso" };
    }

    // Helper para criar tasks em todos os dias quando cria área
    async _populateTasksForNewArea(areaDoc) {
        const days = ['Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo'];
        const tasks = days.map(day => ({
            area: areaDoc._id,
            dayOfWeek: day,
            status: 'livre',
            owner: null
        }));
        await OhTask.insertMany(tasks);
    }
}

module.exports = new OhService();