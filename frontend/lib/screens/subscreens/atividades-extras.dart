import 'package:flutter/material.dart';

class ExtraActivitiesScreen extends StatefulWidget {
  const ExtraActivitiesScreen({super.key});

  @override
  State<ExtraActivitiesScreen> createState() => _ExtraActivitiesScreenState();
}

class _ExtraActivitiesScreenState extends State<ExtraActivitiesScreen> {
  // Simula chamada ao backend
  Future<List<Map<String, String>>> _fetchActivities() async {
    await Future.delayed(const Duration(seconds: 1)); // Delay simulado
    return [
      {"titulo": "Festa da Pizza", "data": "20/02/2026", "desc": "Reunião de todos os moradores."},
      {"titulo": "Manutenção da Piscina", "data": "25/02/2026", "desc": "Técnico virá às 14h."},
      {"titulo": "Assembleia Geral", "data": "01/03/2026", "desc": "Pauta: Novas regras de silêncio."},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(title: const Text("Atividades Extras", style: TextStyle(color: Colors.white)), backgroundColor: const Color(0xFFD32F2F), iconTheme: const IconThemeData(color: Colors.white), elevation: 0),
      body: Column(
        children: [
          SizedBox(height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
          const SizedBox(height: 20),
          
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: _fetchActivities(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white));
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Erro ao carregar.", style: TextStyle(color: Colors.white)));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Nenhuma atividade extra.", style: TextStyle(color: Colors.white)));
                }

                final activities = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final item = activities[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.event, color: Color(0xFFD32F2F)),
                        ),
                        title: Text(item['titulo']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['data']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(item['desc']!),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}