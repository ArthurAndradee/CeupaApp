import 'package:flutter/material.dart';

class WashingMachineScreen extends StatelessWidget {
  const WashingMachineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados Mockados da Tabela
    final List<Map<String, dynamic>> schedule = [
      {"dia": "Segunda", "t1": "Fulano", "t2": "Livre", "t3": "Ciclana", "t4": "Livre"},
      {"dia": "Terça",   "t1": "Livre",  "t2": "Livre", "t3": "Livre",   "t4": "Beltrano"},
      {"dia": "Quarta",  "t1": "Fulano", "t2": "Fulano", "t3": "Livre",  "t4": "Livre"},
      {"dia": "Quinta",  "t1": "Livre",  "t2": "Livre", "t3": "Livre",   "t4": "Livre"},
      {"dia": "Sexta",   "t1": "Livre",  "t2": "Ciclana", "t3": "Livre", "t4": "Livre"},
      {"dia": "Sábado",  "t1": "Livre",  "t2": "Livre", "t3": "Livre",   "t4": "Livre"},
      {"dia": "Domingo", "t1": "Livre",  "t2": "Livre", "t3": "Livre",   "t4": "Livre"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Máquina de Lavar", style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color(0xFFD32F2F), 
        iconTheme: const IconThemeData(color: Colors.white), 
        elevation: 0
      ),
      body: Column(
        children: [
          SizedBox(height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
          const SizedBox(height: 20),
          
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: SingleChildScrollView( // Scroll Vertical
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView( // Scroll Horizontal (Tabela Larga)
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                    columns: const [
                      DataColumn(label: Text("Dia", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)))),
                      DataColumn(label: Text("07h-11h", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("11h-15h", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("15h-19h", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("19h-22h", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: schedule.map((day) {
                      return DataRow(cells: [
                        DataCell(Text(day["dia"], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)))),
                        _buildStatusCell(day["t1"]),
                        _buildStatusCell(day["t2"]),
                        _buildStatusCell(day["t3"]),
                        _buildStatusCell(day["t4"]),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataCell _buildStatusCell(String status) {
    bool isFree = status == "Livre";
    return DataCell(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isFree ? Colors.green[50] : Colors.red[50],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            color: isFree ? Colors.green[800] : Colors.red[800],
            fontWeight: isFree ? FontWeight.normal : FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}