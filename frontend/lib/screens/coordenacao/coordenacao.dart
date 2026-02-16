import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/coordenacao/maquina-de-lavar.dart';
import 'package:flutter_todo_app/screens/coordenacao/escala-oh.dart';
import 'package:flutter_todo_app/screens/coordenacao/atividades-extras.dart';
import 'package:flutter_todo_app/screens/coordenacao/links-controle.dart';

class CoordinationScreen extends StatelessWidget {
  const CoordinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Coordenação", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
            const SizedBox(height: 40),

            _buildCoordinationButton(
              context, 
              "GESTÃO MÁQUINA DE LAVAR", 
              Icons.local_laundry_service, 
              const WashingMachineControlScreen()
            ),
            const SizedBox(height: 15),

            _buildCoordinationButton(
              context, 
              "GESTÃO DE OH'S", 
              Icons.cleaning_services, 
              const OhsControlScreen()
            ),
            const SizedBox(height: 15),

            _buildCoordinationButton(
              context, 
              "GESTÃO ATIVIDADES EXTRAS", 
              Icons.event_note, 
              const ActivitiesControlScreen()
            ),
            const SizedBox(height: 15),

            _buildCoordinationButton(
              context, 
              "GESTÃO LINKS E INFOS", 
              Icons.link, 
              const LinksControlScreen()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinationButton(BuildContext context, String text, IconData icon, Widget destination) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFD32F2F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 24, color: const Color(0xFFD32F2F)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}