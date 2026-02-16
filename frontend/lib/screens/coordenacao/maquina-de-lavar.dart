import 'package:flutter/material.dart';

class WashingMachineControlScreen extends StatefulWidget {
  const WashingMachineControlScreen({super.key});

  @override
  State<WashingMachineControlScreen> createState() => _WashingMachineControlScreenState();
}

class _WashingMachineControlScreenState extends State<WashingMachineControlScreen> {
  // Estrutura de dados: Dias da semana com listas de horários dinâmicas
  final List<Map<String, dynamic>> _weeklySchedule = [
    {
      "day": "Segunda-Feira",
      "slots": [
        {"time": "07:00 - 11:00", "user": "Fulano da Silva"},
        {"time": "13:00 - 15:00", "user": ""},
      ]
    },
    {
      "day": "Terça-Feira",
      "slots": []
    },
    {
      "day": "Quarta-Feira",
      "slots": []
    },
    {
      "day": "Quinta-Feira",
      "slots": []
    },
    {
      "day": "Sexta-Feira",
      "slots": []
    },
    {
      "day": "Sábado",
      "slots": []
    },
    {
      "day": "Domingo",
      "slots": []
    },
  ];

  // --- 1. CRIAR NOVO HORÁRIO (SLOT) ---
  void _showCreateSlotDialog(int dayIndex) {
    final startController = TextEditingController();
    final endController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Novo Horário de Lavagem"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: startController,
              decoration: const InputDecoration(
                labelText: "Início (ex: 08:00)",
                prefixIcon: Icon(Icons.access_time),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: endController,
              decoration: const InputDecoration(
                labelText: "Fim (ex: 12:00)",
                prefixIcon: Icon(Icons.access_time_filled),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), foregroundColor: Colors.white),
            onPressed: () {
              if (startController.text.isNotEmpty && endController.text.isNotEmpty) {
                setState(() {
                  _weeklySchedule[dayIndex]['slots'].add({
                    "time": "${startController.text} - ${endController.text}",
                    "user": "" // Começa vazio
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Criar"),
          ),
        ],
      ),
    );
  }

  // --- 2. REMOVER HORÁRIO INTEIRO ---
  void _deleteSlot(int dayIndex, int slotIndex) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Horário?"),
        content: const Text("Isso removerá este turno da lista permanentemente."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              setState(() {
                _weeklySchedule[dayIndex]['slots'].removeAt(slotIndex);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- 3. RESERVAR/LIBERAR MORADOR (Manter lógica existente) ---
  void _manageReservation(int dayIndex, int slotIndex) {
    String currentUser = _weeklySchedule[dayIndex]['slots'][slotIndex]['user'];
    
    if (currentUser.isNotEmpty) {
      // Se já tem gente -> Perguntar se quer liberar a vaga
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Liberar Vaga?"),
          content: Text("Remover $currentUser deste horário?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
            TextButton(
              onPressed: () {
                setState(() {
                  _weeklySchedule[dayIndex]['slots'][slotIndex]['user'] = "";
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vaga liberada!")));
              },
              child: const Text("Liberar", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      // Se está vazio -> Adicionar morador
      _showAddUserDialog(dayIndex, slotIndex);
    }
  }

  void _showAddUserDialog(int dayIndex, int slotIndex) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reservar para Morador"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Nome do Morador"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                // Validação simples de conflito no mesmo dia
                bool hasConflict = _weeklySchedule[dayIndex]['slots'].any(
                  (slot) => slot['user'].toString().toLowerCase() == nameController.text.toLowerCase()
                );

                if (hasConflict) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Erro: Este morador já tem horário neste dia!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red)
                  );
                } else {
                  setState(() {
                    _weeklySchedule[dayIndex]['slots'][slotIndex]['user'] = nameController.text;
                  });
                  Navigator.pop(ctx);
                }
              }
            },
            child: const Text("Salvar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Gestão Máquina", style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color(0xFFD32F2F), 
        iconTheme: const IconThemeData(color: Colors.white), 
        elevation: 0
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Text(
              "Gerenciar Horários e Reservas", 
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _weeklySchedule.length,
              itemBuilder: (context, dayIndex) {
                final dayData = _weeklySchedule[dayIndex];
                final String dayName = dayData['day'];
                final List slots = dayData['slots'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    title: Text(
                      dayName, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD32F2F), fontSize: 18)
                    ),
                    iconColor: const Color(0xFFD32F2F),
                    collapsedIconColor: const Color(0xFFD32F2F),
                    children: [
                      // LISTA DE HORÁRIOS
                      ...slots.asMap().entries.map<Widget>((entry) {
                        int slotIndex = entry.key;
                        Map<String, dynamic> slot = entry.value;
                        bool isOccupied = slot['user'].toString().isNotEmpty;

                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.access_time, 
                              color: isOccupied ? Colors.grey : Colors.green
                            ),
                            title: Text(slot['time'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              isOccupied ? "Reservado: ${slot['user']}" : "Disponível",
                              style: TextStyle(
                                color: isOccupied ? Colors.black87 : Colors.green,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botão Gerenciar Reserva (Adicionar/Remover Pessoa)
                                IconButton(
                                  icon: Icon(
                                    isOccupied ? Icons.person_remove : Icons.person_add,
                                    color: isOccupied ? Colors.orange : Colors.blue
                                  ),
                                  tooltip: isOccupied ? "Liberar Vaga" : "Reservar",
                                  onPressed: () => _manageReservation(dayIndex, slotIndex),
                                ),
                                // Botão Excluir Horário (Lixeira)
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  tooltip: "Excluir Horário",
                                  onPressed: () => _deleteSlot(dayIndex, slotIndex),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      
                      // BOTÃO ADICIONAR HORÁRIO
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextButton.icon(
                          onPressed: () => _showCreateSlotDialog(dayIndex),
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFFD32F2F)),
                          label: const Text("Adicionar Novo Horário", style: TextStyle(color: Color(0xFFD32F2F), fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}