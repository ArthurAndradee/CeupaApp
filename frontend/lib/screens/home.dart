// Arquivo: lib/screens/home.dart
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/morador/ohs.dart';
import 'package:flutter_todo_app/screens/coordenacao/coordenacao.dart';
import 'package:flutter_todo_app/screens/morador/mural-da-casa.dart'; // Nome do arquivo do mural (se você salvou como mural-da-casa.dart, ajuste aqui)
import 'package:flutter_todo_app/screens/morador/informacoes-e-documentos.dart'; // <--- IMPORTANTE: Importe a nova tela aqui// Nova tela (crie ou remova import se ainda não existir)

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // SIMULAÇÃO DA FLAG DE COORDENAÇÃO (Vinda do Backend)
  final bool isCoordinator = true; // Mude para false para testar a visão de membro comum

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD32F2F), 
        elevation: 0, 
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // LOGO
            SizedBox(
              height: 150,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            // Textos invertidos para BRANCO
            const Text(
              "Casa 1",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Bem vindo(a) Fulano da Silva!",
              style: TextStyle(
                  fontSize: 18, color: Colors.white
                  ),
            ),
            const SizedBox(height: 40),

            // --- MENU PRINCIPAL ---

            // 1. OH'S
            _buildMenuButton(context, "OH'S", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OhsScreen()),
              );
            }),
            
            const SizedBox(height: 15),
            
            // 2. MURAL DA CASA
            _buildMenuButton(context, "MURAL DA CASA", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HouseWallScreen()),
              );
            }),
            
            const SizedBox(height: 15),
            
            // 3. INFORMAÇÕES E DOCUMENTOS
            _buildMenuButton(context, "INFORMAÇÕES E DOCUMENTOS", () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InfoDocsScreen()),
              );
            }),

            // 4. BOTÃO DE COORDENAÇÃO (CONDICIONAL)
            if (isCoordinator) ...[
              const SizedBox(height: 15),
              _buildMenuButton(context, "COORDENAÇÃO", () {
                // Navega para tela de coordenação
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CoordinationScreen()),
                );
              }),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFD32F2F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onTap, 
        child: Text(text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}