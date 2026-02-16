import 'package:flutter/material.dart';
import 'package:flutter_todo_app/screens/subscreens/links-da-casa.dart';

class InfoDocsScreen extends StatelessWidget {
  const InfoDocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F), // Fundo Vermelho
      appBar: AppBar(
        title: const Text("Informações e Documentos", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

            // 1. ESTATUTO
            _buildDocButton(
              context, 
              "ESTATUTO", 
              Icons.gavel, 
              () => _openLink(context, "Abrindo PDF do Estatuto...")
            ),
            const SizedBox(height: 20),

            // 2. REGIMENTO
            _buildDocButton(
              context, 
              "REGIMENTO", 
              Icons.menu_book, 
              () => _openLink(context, "Abrindo PDF do Regimento...")
            ),
            const SizedBox(height: 20),

            // 3. PORTAL DA TRANSPARÊNCIA
            _buildDocButton(
              context, 
              "PORTAL DA TRANSPARÊNCIA", 
              Icons.manage_search, 
              () => _openLink(context, "Redirecionando para o Portal...")
            ),
            const SizedBox(height: 20),

            // 4. LINKS DA CASA (Navegação para Subtela)
            _buildDocButton(
              context, 
              "LINKS DA CASA", 
              Icons.link, 
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HouseLinksScreen()),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para simular abertura de link externo
  void _openLink(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildDocButton(BuildContext context, String text, IconData icon, VoidCallback onTap) {
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
        onPressed: onTap,
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