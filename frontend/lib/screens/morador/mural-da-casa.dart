import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/subscreens/viagens.dart';
import 'package:flutter_todo_app/screens/subscreens/maquina-de-lavar.dart';
import 'package:flutter_todo_app/screens/subscreens/atividades-extras.dart';

// --- TELA PRINCIPAL DO MURAL ---
class HouseWallScreen extends StatelessWidget {
  const HouseWallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F), // Fundo Vermelho
      appBar: AppBar(
        title: const Text("Mural da Casa", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // LOGO
            SizedBox(
              height: 100,
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
            const SizedBox(height: 40),

            // Botões de Navegação
            _buildMenuItem(context, "MINHAS VIAGENS", Icons.flight_takeoff, const MyTripsScreen()),
            const SizedBox(height: 20),
            _buildMenuItem(context, "HORÁRIOS MÁQUINA DE LAVAR", Icons.local_laundry_service, const WashingMachineScreen()),
            const SizedBox(height: 20),
            _buildMenuItem(context, "ATIVIDADES EXTRAS", Icons.assignment_add, const ExtraActivitiesScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String text, IconData icon, Widget destination) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // Fundo Branco
          foregroundColor: const Color(0xFFD32F2F), // Texto Vermelho
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, size: 28),
                  const SizedBox(width: 15),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}