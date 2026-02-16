import 'package:flutter/material.dart';
// Certifique-se que os nomes dos arquivos aqui correspondem aos que você criou
import 'package:flutter_todo_app/screens/morador/ohs-upload.dart';
import 'package:flutter_todo_app/screens/morador/ohs-evaluation.dart';

class OhsScreen extends StatefulWidget {
  const OhsScreen({super.key});

  @override
  State<OhsScreen> createState() => _OhsScreenState();
}

class _OhsScreenState extends State<OhsScreen> {
  // MOCK DE DADOS
  final List<Map<String, dynamic>> _weeklySchedule = [
    {
      "day": "Segunda-Feira",
      "tasks": [
        {"area": "Cozinha", "status": "ocupado", "owner": "Fulano da Silva"},
        {"area": "Banheiros", "status": "pendente", "owner": "Ciclana"},
      ]
    },
    {
      "day": "Terça-Feira",
      "tasks": [
        {"area": "Sala de Estar", "status": "livre"},
        {"area": "Pátio", "status": "concluida", "owner": "Beltrano", "evaluator": "Fulano"},
      ]
    },
    {"day": "Quarta-Feira", "tasks": []},
    {"day": "Quinta-Feira", "tasks": []},
    {"day": "Sexta-Feira", "tasks": []},
    {"day": "Sábado", "tasks": []},
    {"day": "Domingo", "tasks": []},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F), // Fundo Vermelho
      appBar: AppBar(
        title: const Text("Tabela de OH'S", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),

          // LISTA DE DIAS DA SEMANA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _weeklySchedule.length,
              itemBuilder: (context, index) {
                final dayData = _weeklySchedule[index];
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
                        ? [
                            const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text("Sem atividades para este dia.", style: TextStyle(color: Colors.grey)),
                            )
                          ]
                        : tasks.map<Widget>((task) {
                            // IMPORTANTE: Passamos o context aqui
                            return _buildTaskRow(task, context);
                          }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET AUXILIAR (Agora recebe context para navegação)
  Widget _buildTaskRow(Map<String, dynamic> task, BuildContext context) {
    String statusText = "";
    Color statusColor = Colors.grey;

    // Lógica visual
    switch (task['status']) {
      case 'ocupado':
        statusText = "Ocupado\nPor: ${task['owner']}";
        statusColor = Colors.red;
        break;
      case 'pendente':
        statusText = "Avaliação Pendente\nFeito por: ${task['owner']}";
        statusColor = Colors.orange;
        break;
      case 'concluida':
        statusText = "Concluída\nFeito por: ${task['owner']}\nAvaliado por: ${task['evaluator']}";
        statusColor = Colors.green;
        break;
      case 'livre':
        statusText = "Livre (Clique para pegar)";
        statusColor = Colors.blue;
        break;
    }

    // InkWell adiciona a capacidade de clique
    return InkWell(
      onTap: () {
        // Lógica de Navegação
        if (task['status'] == 'livre') {
          // Vai para tela de Upload (Limpar)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OhsUploadScreen(areaName: task['area']),
            ),
          );
        } else if (task['status'] == 'pendente' || task['status'] == 'concluida') {
          // Vai para tela de Avaliação
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OhsEvaluationScreen(
                areaName: task['area'],
                cleanerName: task['owner'] ?? "Desconhecido",
                status: task['status'],
              ),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ESQUERDA: NOME DA ÁREA
            Expanded(
              flex: 1,
              child: Text(
                task['area'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // DIREITA: STATUS E RESPONSÁVEIS
            Expanded(
              flex: 1,
              child: Text(
                statusText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}