import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para copiar para a área de transferência

class HouseLinksScreen extends StatelessWidget {
  const HouseLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GRUPO 1: INFORMAÇÕES (Tocam para COPIAR)
    final List<Map<String, dynamic>> infoList = [
      {
        "titulo": "Pix Rateio",
        "dado": "ceupacasa1@gmail.com",
        "icon": Icons.attach_money,
      },
      {
        "titulo": "Email da Casa",
        "dado": "ceupacasa1@gmail.com",
        "icon": Icons.email,
      },
      {
        "titulo": "CNPJ",
        "dado": "92.979.293.0001-19",
        "icon": Icons.badge,
      },
      {
        "titulo": "CEP",
        "dado": "90050170",
        "icon": Icons.location_on,
      },
      {
        "titulo": "Wi-Fi Ceupa1-Principal",
        "dado": "Casa11053",
        "icon": Icons.wifi,
      },
      {
        "titulo": "Wi-Fi Ceupa2",
        "dado": "Marcia1053@",
        "icon": Icons.wifi,
      },
      {
        "titulo": "Wi-Fi Ceupa3",
        "dado": "Marcia11053",
        "icon": Icons.wifi,
      },
    ];

    // GRUPO 2: LINKS (Tocam para ABRIR)
    final List<Map<String, dynamic>> linkList = [
      {
        "titulo": "Portal da Transparência",
        "url": "https://drive.google.com/drive/folders/1E-xHNshEgRP7eY8TGB6Dp9-r3iCpCtl0",
        "icon": Icons.folder_open,
      },
      {
        "titulo": "Planilha do Caixa",
        "url": "https://docs.google.com/spreadsheets/d/18rSti7R6oRxMYxvLZk-POS6c80bTqa64/edit?gid=995606756#gid=995606756",
        "icon": Icons.table_chart,
      },
      {
        "titulo": "Link das Atas",
        "url": "https://drive.google.com/drive/folders/1HosZGh4C3bJVo_iJbHPn6DktQqvy22pa",
        "icon": Icons.description,
      },
      {
        "titulo": "Controle de Faltas OH's",
        "url": "https://docs.google.com/spreadsheets/d/1B1KgUQ0j2394AL-IewOB4p4z0W1etG9YyGiSqMZlZec/edit?usp=sharing",
        "icon": Icons.assignment_late,
      },
      {
        "titulo": "Faltas OH's Geladeira",
        "url": "https://docs.google.com/spreadsheets/d/1KvHVke_OtwVqRMR2u9vD14Gc_e0H8nzzGkrwfAue_7I/edit?usp=sharing",
        "icon": Icons.kitchen,
      },
      {
        "titulo": "Presença em Assembleia",
        "url": "https://docs.google.com/spreadsheets/d/1tQFaJeH5zSrO8VFD4ENB7uiGfCoRpSROpfsDAIAqvko/edit?gid=0#gid=0",
        "icon": Icons.groups,
      },
      {
        "titulo": "Manual da Casa",
        "url": "https://docs.google.com/document/d/1Zu3lFTtIlEbAUYRs-LleBD9WGr_6Mi9o/edit?usp=drivesdk",
        "icon": Icons.menu_book,
      },
      {
        "titulo": "Solicitação Vistoria Quarto",
        "url": "https://docs.google.com/forms/d/e/1FAIpQLSdtQ_OR0IynhYWMyFCXifGOdPvn1_zaNouuDL_9fO2J9pglXg/viewform",
        "icon": Icons.checklist,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Links Útedddis", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFD32F2F),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: 80, child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
            const SizedBox(height: 30),
            
            // --- GRUPO 1: DADOS E SENHAS ---
            _buildSectionHeader("Dados da Casa", "Toque para copiar"),
            const SizedBox(height: 10),
            ...infoList.map((item) => _buildInfoButton(context, item)).toList(),

            const SizedBox(height: 30),

            // --- GRUPO 2: DOCUMENTOS ---
            _buildSectionHeader("Documentos e Links", "Toque para abrir"),
            const SizedBox(height: 10),
            ...linkList.map((item) => _buildLinkButton(context, item)).toList(),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget de Cabeçalho de Seção
  Widget _buildSectionHeader(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10, left: 5),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white54, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // Botão para INFORMAÇÕES (Copiar)
  Widget _buildInfoButton(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFD32F2F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: item['dado']));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${item['titulo']} copiado!"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 1),
            )
          );
        },
        child: Row(
          children: [
            Icon(item['icon'], size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['titulo'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(item['dado'], style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.copy, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Botão para LINKS (Abrir)
  Widget _buildLinkButton(BuildContext context, Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFFD32F2F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 15),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Abrindo: ${item['titulo']}..."), duration: const Duration(seconds: 2))
          );
          // Lógica real de abrir link: launchUrl(Uri.parse(item['url']));
        },
        child: Row(
          children: [
            Icon(item['icon'], size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                item['titulo'],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.open_in_new, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}