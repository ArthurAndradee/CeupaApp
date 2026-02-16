import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/coordenacao/controle-oh.dart'; // Importe a tela criada no Passo 2 

class OhsControlScreen extends StatefulWidget {
  const OhsControlScreen({super.key});

  @override
  State<OhsControlScreen> createState() => _OhsControlScreenState();
}

class _OhsControlScreenState extends State<OhsControlScreen> {
  final List<String> _statusOptions = ['livre', 'ocupado', 'pendente', 'concluida'];

  // 1. LISTA DE TODOS OS MORADORES DA CASA (MOCK)
  final List<String> _allResidents = [
    "Fulano", "Ciclana", "Beltrano", 
    "João", "Maria", "Pedro", "Ana", "Sofia", "Carlos", "Mariana"
  ];

  // MOCK INICIAL DAS DEFINIÇÕES DE ÁREA
  List<OhsAreaDefinition> _areaDefinitions = [
    OhsAreaDefinition(id: '1', name: 'Cozinha', isPriority: true, checklist: ['Lavar Louça', 'Limpar Fogão']),
    OhsAreaDefinition(id: '2', name: 'Banheiros', isPriority: true, checklist: ['Lavar Vaso', 'Tirar Lixo']),
    OhsAreaDefinition(id: '3', name: 'Pátio', isPriority: false, checklist: ['Varrer folhas']),
  ];

  late List<Map<String, dynamic>> _weeklySchedule;

  @override
  void initState() {
    super.initState();
    _initializeSchedule();
  }

  void _initializeSchedule() {
    List<String> days = ['Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo'];
    
    _weeklySchedule = days.map((day) {
      List<Map<String, dynamic>> dailyTasks = _areaDefinitions.map((def) {
        return {
          "id": def.id, 
          "area": def.name,
          "status": "livre",
          "owner": "", // Começa vazio
          "isPriority": def.isPriority,
        };
      }).toList();

      return {
        "day": day,
        "tasks": dailyTasks
      };
    }).toList();
  }

  // --- NAVEGAR PARA TELA DE GERENCIAMENTO DE ÁREAS ---
  void _goToAreaManagement() async {
    final updatedDefinitions = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OhsAreasManagementScreen(initialAreas: _areaDefinitions),
      ),
    );

    if (updatedDefinitions != null) {
      setState(() {
        _areaDefinitions = updatedDefinitions as List<OhsAreaDefinition>;
        _syncScheduleWithDefinitions(); 
      });
    }
  }

  void _syncScheduleWithDefinitions() {
    for (var day in _weeklySchedule) {
      List<Map<String, dynamic>> currentTasks = List.from(day['tasks']);
      List<Map<String, dynamic>> newTasks = [];

      for (var def in _areaDefinitions) {
        var existing = currentTasks.firstWhere(
          (t) => t['id'] == def.id || t['area'] == def.name, 
          orElse: () => {},
        );

        if (existing.isNotEmpty) {
          existing['area'] = def.name;
          existing['isPriority'] = def.isPriority;
          existing['id'] = def.id;
          newTasks.add(existing);
        } else {
          newTasks.add({
            "id": def.id,
            "area": def.name,
            "status": "livre",
            "owner": "",
            "isPriority": def.isPriority,
          });
        }
      }
      day['tasks'] = newTasks;
    }
  }

  void _generatePdfReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Relatório PDF gerado com Checklists!"), backgroundColor: Colors.green)
    );
  }

  void _autoScheduleResidents() {
    setState(() {
      for (var day in _weeklySchedule) {
        List<dynamic> tasks = day['tasks'];
        List<String> owners = [];
        
        for (var t in tasks) {
          if (t['owner'] != null && t['owner'].toString().isNotEmpty) owners.add(t['owner']);
        }

        if (owners.isEmpty) continue;

        String first = owners.removeAt(0);
        owners.add(first);

        List<dynamic> priorityTasks = tasks.where((t) => t['isPriority'] == true).toList();
        List<dynamic> normalTasks = tasks.where((t) => t['isPriority'] == false).toList();
        List<dynamic> sortedTasksToFill = [...priorityTasks, ...normalTasks];

        for (var t in tasks) {
          t['owner'] = ""; 
          t['status'] = "livre";
        }

        int ownerIndex = 0;
        for (var t in sortedTasksToFill) {
          if (ownerIndex < owners.length) {
            var originalTask = tasks.firstWhere((x) => x['area'] == t['area']);
            originalTask['owner'] = owners[ownerIndex];
            originalTask['status'] = "ocupado";
            ownerIndex++;
          }
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Escala rotacionada!"))
    );
  }

  // --- DIALOG: EDITAR TAREFA DO DIA (COM FILTRO DE MORADORES) ---
  void _showEditTaskDialog(int dayIndex, int taskIndex, Map<String, dynamic> task) {
    // Estado local para o dialog
    String currentStatus = task['status'];
    String currentOwner = task['owner'] ?? ""; 

    // 2. LÓGICA DE FILTRAGEM
    // Pega todas as tarefas desse dia específico
    List<dynamic> todaysTasks = _weeklySchedule[dayIndex]['tasks'];
    
    // Lista de quem já está trabalhando hoje (excluindo a pessoa da tarefa atual que estamos editando)
    List<String> busyResidentsToday = [];
    for (var t in todaysTasks) {
      // Se não for a tarefa atual E tiver dono
      if (t != task && t['owner'] != null && t['owner'].toString().isNotEmpty) {
        busyResidentsToday.add(t['owner']);
      }
    }

    // Filtra: Todos os moradores MENOS os ocupados
    List<String> availableResidents = _allResidents.where((r) => !busyResidentsToday.contains(r)).toList();

    // Adiciona opção vazia (Ninguém) no topo
    availableResidents.insert(0, ""); 

    // Verifica se o dono atual está na lista (para não quebrar o dropdown se ele já estiver selecionado)
    // Se o dono atual não está na lista de disponíveis (erro de lógica ou ele foi removido da lista global),
    // mas ele é o dono atual desta tarefa, mantemos ele visualmente.
    if (currentOwner.isNotEmpty && !availableResidents.contains(currentOwner)) {
      availableResidents.add(currentOwner);
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Editar: ${task['area']}"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: currentStatus,
                    decoration: const InputDecoration(labelText: "Status", border: OutlineInputBorder()),
                    items: _statusOptions.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => currentStatus = val);
                    },
                  ),
                  const SizedBox(height: 15),
                  
                  // 3. DROPDOWN DE MORADORES DISPONÍVEIS
                  DropdownButtonFormField<String>(
                    value: currentOwner, // Valor atual
                    decoration: const InputDecoration(labelText: "Responsável (Disponíveis)", border: OutlineInputBorder()),
                    isExpanded: true,
                    items: availableResidents.map((resident) {
                      return DropdownMenuItem<String>(
                        value: resident,
                        child: Text(resident.isEmpty ? "Ninguém (Livre)" : resident),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          currentOwner = val;
                          // Se selecionou alguém, muda status pra ocupado automaticamente
                          if (currentOwner.isNotEmpty && currentStatus == 'livre') {
                            currentStatus = 'ocupado';
                          }
                          // Se removeu alguém, muda pra livre
                          if (currentOwner.isEmpty) {
                            currentStatus = 'livre';
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), foregroundColor: Colors.white),
                  onPressed: () {
                    setState(() {
                      _weeklySchedule[dayIndex]['tasks'][taskIndex]['status'] = currentStatus;
                      _weeklySchedule[dayIndex]['tasks'][taskIndex]['owner'] = currentOwner;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Gestão de OH's", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: "Gerar Relatório PDF",
            onPressed: _generatePdfReport,
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _autoScheduleResidents,
                icon: const Icon(Icons.autorenew),
                label: const Text("AUTO ESCALAR (Rotacionar)", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Visão da Coordenação",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _weeklySchedule.length,
              itemBuilder: (context, dayIndex) {
                final dayData = _weeklySchedule[dayIndex];
                final String dayName = dayData['day'];
                final List tasks = dayData['tasks'];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ExpansionTile(
                    title: Text(
                      dayName,
                      style: const TextStyle(
                        color: Color(0xFFD32F2F),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    iconColor: const Color(0xFFD32F2F),
                    collapsedIconColor: const Color(0xFFD32F2F),
                    children: tasks.isEmpty
                        ? [const Padding(padding: EdgeInsets.all(15.0), child: Text("Nenhuma área cadastrada."))]
                        : tasks.asMap().entries.map<Widget>((entry) {
                            int taskIndex = entry.key;
                            Map<String, dynamic> task = entry.value;
                            return _buildTaskRow(dayIndex, taskIndex, task);
                          }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToAreaManagement,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFFD32F2F),
        icon: const Icon(Icons.edit_road),
        label: const Text("Editar Áreas e Tarefas", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTaskRow(int dayIndex, int taskIndex, Map<String, dynamic> task) {
    String statusText = "";
    Color statusColor = Colors.grey;
    bool isPriority = task['isPriority'] ?? false;

    switch (task['status']) {
      case 'ocupado':
        statusText = "Ocupado: ${task['owner']}";
        statusColor = Colors.red;
        break;
      case 'pendente':
        statusText = "Pendente: ${task['owner']}";
        statusColor = Colors.orange;
        break;
      case 'concluida':
        statusText = "Concluída: ${task['owner']}";
        statusColor = Colors.green;
        break;
      case 'livre':
        statusText = "Livre";
        statusColor = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
      ),
      child: Row(
        children: [
          if (isPriority) 
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.star, color: Colors.amber, size: 20),
            ),
          Expanded(
            flex: 3,
            child: Text(
              task['area'],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              statusText,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w500),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt, color: Colors.grey),
            onPressed: () => _showEditTaskDialog(dayIndex, taskIndex, task),
          )
        ],
      ),
    );
  }
}