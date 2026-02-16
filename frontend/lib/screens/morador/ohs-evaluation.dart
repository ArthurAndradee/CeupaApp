import 'package:flutter/material.dart';

class OhsEvaluationScreen extends StatefulWidget {
  final String areaName;
  final String cleanerName;
  final String status;

  const OhsEvaluationScreen({
    super.key, 
    required this.areaName, 
    required this.cleanerName,
    required this.status,
  });

  @override
  State<OhsEvaluationScreen> createState() => _OhsEvaluationScreenState();
}

class _OhsEvaluationScreenState extends State<OhsEvaluationScreen> {
  late bool _isEvaluated;
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _isEvaluated = widget.status == 'concluida';
    _currentStatus = widget.status;
  }

  void _submitEvaluation(bool approved) {
    setState(() {
      _isEvaluated = true;
      _currentStatus = approved ? 'concluida' : 'reprovada';
    });
  }

  // Função para abrir imagem (Asset) em tela cheia
  // Se fosse imagem da internet, usaria NetworkImage
  void _openFullScreen(String assetPath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.asset(assetPath),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isApproved = _currentStatus == 'concluida';

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Avaliação", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 80,
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.areaName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isEvaluated 
                              ? (isApproved ? Colors.green[100] : Colors.red[100]) 
                              : Colors.orange[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _isEvaluated 
                              ? (isApproved ? "APROVADO" : "REPROVADO") 
                              : "PENDENTE",
                          style: TextStyle(
                            color: _isEvaluated 
                                ? (isApproved ? Colors.green[800] : Colors.red[800]) 
                                : Colors.orange[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("Feito por: ${widget.cleanerName}", style: const TextStyle(color: Colors.grey)),
                  
                  const Divider(height: 30),

                  const Text("Fotos anexadas:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  // GALERIA DE FOTOS (Visualização)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3, 
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          // Ao clicar, abre a imagem em tela cheia
                          onTap: () => _openFullScreen('assets/logo.png'), 
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage('assets/logo.png'), // Placeholder
                                fit: BoxFit.cover,
                              )
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (!_isEvaluated) ...[
                    const Text("Como você avalia essa limpeza?", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              foregroundColor: Colors.red,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: () => _submitEvaluation(false),
                            icon: const Icon(Icons.thumb_down),
                            label: const Text("REPROVAR"),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: () => _submitEvaluation(true),
                            icon: const Icon(Icons.thumb_up),
                            label: const Text("APROVAR"),
                          ),
                        ),
                      ],
                    )
                  ] else ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300)
                      ),
                      child: Column(
                        children: [
                          Icon(
                            isApproved ? Icons.check_circle : Icons.cancel,
                            color: isApproved ? Colors.green : Colors.red,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            isApproved 
                                ? "Limpeza aprovada com sucesso!" 
                                : "Limpeza reprovida. O responsável foi notificado.",
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}