import 'package:flutter/material.dart';

class ActivitiesControlScreen extends StatefulWidget {
  const ActivitiesControlScreen({super.key});

  @override
  State<ActivitiesControlScreen> createState() => _ActivitiesControlScreenState();
}

class _ActivitiesControlScreenState extends State<ActivitiesControlScreen> {
  final List<String> _activities = ["Festa da Pizza - 20/02", "Reunião Geral - 01/03"];
  final _textController = TextEditingController();

  void _addActivity() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nova Atividade"),
        content: TextField(controller: _textController, decoration: const InputDecoration(hintText: "Nome e Data")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(onPressed: () {
            setState(() {
              _activities.add(_textController.text);
              _textController.clear();
            });
            Navigator.pop(ctx);
          }, child: const Text("Salvar")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(title: const Text("Atividades Extras", style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFFD32F2F), iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _activities.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.event, color: Colors.orange),
              title: Text(_activities[index]),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => _activities.removeAt(index)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFFD32F2F)),
      ),
    );
  }
}