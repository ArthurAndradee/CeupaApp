import 'package:flutter/material.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  // Lista inicial de viagens
  final List<String> _trips = [
    "10/02/2026 - 15/02/2026",
    "20/12/2025 - 05/01/2026",
  ];

  // Função para deletar
  void _deleteTrip(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Viagem?"),
        content: const Text("Essa ação não pode ser desfeita."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              setState(() {
                _trips.removeAt(index);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Função para criar (abrir calendário)
  Future<void> _addTrip() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFD32F2F),
            colorScheme: const ColorScheme.light(primary: Color(0xFFD32F2F)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Formata a data simples (DD/MM/AAAA)
      String start = "${picked.start.day.toString().padLeft(2,'0')}/${picked.start.month.toString().padLeft(2,'0')}/${picked.start.year}";
      String end = "${picked.end.day.toString().padLeft(2,'0')}/${picked.end.month.toString().padLeft(2,'0')}/${picked.end.year}";
      
      setState(() {
        _trips.insert(0, "$start - $end"); // Adiciona no topo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(title: const Text("Minhas Viagens", style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFFD32F2F), iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Column(
        children: [
          SizedBox(height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
          const SizedBox(height: 20),
          
          // LISTA
          Expanded(
            child: _trips.isEmpty 
              ? const Center(child: Text("Nenhuma viagem registrada.", style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _trips.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.calendar_month, color: Color(0xFFD32F2F)),
                        title: Text(_trips[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => _deleteTrip(index),
                        ),
                      ),
                    );
                  },
                ),
          ),
          
          // BOTÃO ADICIONAR
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity, 
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, 
                  foregroundColor: const Color(0xFFD32F2F),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _addTrip, 
                icon: const Icon(Icons.add),
                label: const Text("REGISTRAR NOVA VIAGEM", style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ),
          )
        ],
      ),
    );
  }
}