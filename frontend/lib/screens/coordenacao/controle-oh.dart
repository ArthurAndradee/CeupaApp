import 'package:flutter/material.dart';

// Modelo de Dados (Pode ficar em arquivo separado)
class OhsAreaDefinition {
  String id;
  String name;
  bool isPriority;
  List<String> checklist;

  OhsAreaDefinition({
    required this.id,
    required this.name,
    this.isPriority = false,
    required this.checklist,
  });
}

class OhsAreasManagementScreen extends StatefulWidget {
  // Recebe a lista atual para editar
  final List<OhsAreaDefinition> initialAreas;

  const OhsAreasManagementScreen({super.key, required this.initialAreas});

  @override
  State<OhsAreasManagementScreen> createState() => _OhsAreasManagementScreenState();
}

class _OhsAreasManagementScreenState extends State<OhsAreasManagementScreen> {
  late List<OhsAreaDefinition> _areas;

  @override
  void initState() {
    super.initState();
    _areas = List.from(widget.initialAreas);
  }

  // --- NAVEGAR PARA TELA DE EDIÇÃO/CRIAÇÃO ---
  void _openAreaEditor({OhsAreaDefinition? area, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AreaEditorScreen(areaToEdit: area),
      ),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          // Editando existente
          _areas[index] = result;
        } else {
          // Criando novo
          _areas.add(result);
        }
      });
    }
  }

  void _deleteArea(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Área Definitivamente?"),
        content: const Text("Isso removerá a área e seu checklist da lista de opções."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              setState(() {
                _areas.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Gerenciar Áreas & Tarefas", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFD32F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Retorna a lista atualizada para a tela anterior
            Navigator.pop(context, _areas);
          },
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Defina aqui as áreas que aparecerão na escala e suas respectivas tarefas de limpeza.",
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: _areas.isEmpty 
                ? const Center(child: Text("Nenhuma área cadastrada.")) 
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: _areas.length,
                    itemBuilder: (context, index) {
                      final area = _areas[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: area.isPriority 
                            ? const Icon(Icons.star, color: Colors.amber) 
                            : const Icon(Icons.cleaning_services, color: Colors.grey),
                          title: Text(area.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${area.checklist.length} tarefas no checklist"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _openAreaEditor(area: area, index: index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteArea(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAreaEditor(),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text("Nova Área"),
      ),
    );
  }
}

// --- TELA DE EDIÇÃO DE UMA ÚNICA ÁREA (NOME + CHECKLIST) ---
class AreaEditorScreen extends StatefulWidget {
  final OhsAreaDefinition? areaToEdit;

  const AreaEditorScreen({super.key, this.areaToEdit});

  @override
  State<AreaEditorScreen> createState() => _AreaEditorScreenState();
}

class _AreaEditorScreenState extends State<AreaEditorScreen> {
  final _nameController = TextEditingController();
  bool _isPriority = false;
  List<String> _checklist = [];
  final _taskController = TextEditingController(); // Para adicionar nova tarefa

  @override
  void initState() {
    super.initState();
    if (widget.areaToEdit != null) {
      _nameController.text = widget.areaToEdit!.name;
      _isPriority = widget.areaToEdit!.isPriority;
      _checklist = List.from(widget.areaToEdit!.checklist);
    }
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _checklist.add(_taskController.text);
        _taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _checklist.removeAt(index);
    });
  }

  void _save() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Nome da área é obrigatório")));
      return;
    }

    final newArea = OhsAreaDefinition(
      id: widget.areaToEdit?.id ?? DateTime.now().toString(),
      name: _nameController.text,
      isPriority: _isPriority,
      checklist: _checklist,
    );

    Navigator.pop(context, newArea);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.areaToEdit == null ? "Criar Área" : "Editar Área"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text("SALVAR", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOME E PRIORIDADE
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Nome da Área",
                hintText: "Ex: Cozinha",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Área Prioritária"),
              subtitle: const Text("Aparecerá com destaque na lista"),
              value: _isPriority,
              activeColor: const Color(0xFFD32F2F),
              onChanged: (val) => setState(() => _isPriority = val),
            ),
            
            const Divider(height: 40),
            
            // CHECKLIST
            const Text("Checklist de Limpeza", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F))),
            const SizedBox(height: 10),
            
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: "Nova tarefa (ex: Varrer chão)",
                      isDense: true,
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                IconButton(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add_circle, color: Color(0xFFD32F2F), size: 30),
                )
              ],
            ),
            const SizedBox(height: 10),

            // LISTA DE TAREFAS
            if (_checklist.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text("Nenhuma tarefa no checklist.", style: TextStyle(color: Colors.grey)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _checklist.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text("${index + 1}", style: const TextStyle(color: Colors.black)),
                      ),
                      title: Text(_checklist[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => _removeTask(index),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}