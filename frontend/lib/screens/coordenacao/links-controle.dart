import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo_app/models/links_model.dart'; 

class LinksControlScreen extends StatefulWidget {
  const LinksControlScreen({super.key});

  @override
  State<LinksControlScreen> createState() => _HouseLinksScreenState();
}

class _HouseLinksScreenState extends State<LinksControlScreen> {
  
  IconData _getIconForTitle(String title, String type) {
    if (type == 'wifi') return Icons.wifi; // Ícone fixo para tipo wifi
    
    String t = title.toLowerCase();
    if (t.contains("email")) return Icons.email;
    if (t.contains("pix") || t.contains("rateio") || t.contains("caixa")) return Icons.attach_money;
    if (t.contains("cnpj") || t.contains("identidade")) return Icons.badge;
    if (t.contains("cep") || t.contains("endereço")) return Icons.location_on;
    if (t.contains("pasta") || t.contains("drive") || t.contains("portal")) return Icons.folder_open;
    if (t.contains("ata") || t.contains("documento")) return Icons.description;
    if (t.contains("planilha") || t.contains("excel")) return Icons.table_chart;
    if (t.contains("falta") || t.contains("oh")) return Icons.assignment_late;
    if (t.contains("geladeira") || t.contains("cozinha")) return Icons.kitchen;
    if (t.contains("assembleia") || t.contains("reunião")) return Icons.groups;
    if (t.contains("manual")) return Icons.menu_book;
    if (t.contains("vistoria") || t.contains("solicitação")) return Icons.checklist;

    return type == 'link' ? Icons.link : Icons.info;
  }

  // --- LÓGICA DE EDIÇÃO E CRIAÇÃO ---

  void _showEditorDialog({Map<String, dynamic>? item}) {
    final isEditing = item != null;
    
    // Se for Wi-Fi, o 'titulo' vira o SSID e 'dado' vira a Senha
    final titleController = TextEditingController(text: isEditing ? item['titulo'] : '');
    final dataController = TextEditingController(text: isEditing ? item['dado'] : '');
    
    // Variável de estado local para controlar a mudança de tipo dentro do Dialog
    String selectedType = isEditing ? (item['tipo'] ?? 'info') : 'info'; 

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Labels dinâmicas baseadas no tipo
            String labelTitle = "Título";
            String hintTitle = "Ex: Pix Rateio";
            String labelData = "Conteúdo";
            String hintData = "Chave Pix ou Link";

            if (selectedType == 'wifi') {
              labelTitle = "Nome da Rede (SSID)";
              hintTitle = "Ex: Casa 1 - Térreo";
              labelData = "Senha do Wi-Fi";
              hintData = "Digite a senha";
            }

            return AlertDialog(
              title: Text(isEditing ? "Editar Item" : "Novo Item"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: const InputDecoration(labelText: "Tipo de Dado", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: "info", child: Text("Informação (Copiar)")),
                        DropdownMenuItem(value: "link", child: Text("Link (Abrir)")),
                        DropdownMenuItem(value: "wifi", child: Text("Wi-Fi (Rede + Senha)")),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedType = val);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: labelTitle, hintText: hintTitle, border: const OutlineInputBorder()),
                    ),
                    const SizedBox(height: 15),
                    
                    TextField(
                      controller: dataController,
                      decoration: InputDecoration(labelText: labelData, hintText: hintData, border: const OutlineInputBorder()),
                      maxLines: selectedType == 'wifi' ? 1 : 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx), 
                  child: const Text("Cancelar")
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD32F2F), foregroundColor: Colors.white),
                  onPressed: () {
                    if (titleController.text.isNotEmpty && dataController.text.isNotEmpty) {
                      setState(() {
                        if (isEditing) {
                          item['titulo'] = titleController.text;
                          item['dado'] = dataController.text;
                          item['tipo'] = selectedType;
                        } else {
                          globalHouseLinks.add({
                            "titulo": titleController.text,
                            "dado": dataController.text,
                            "tipo": selectedType
                          });
                        }
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _deleteItem(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir Item?"),
        content: Text("Deseja remover '${item['titulo']}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancelar")),
          TextButton(
            onPressed: () {
              setState(() {
                globalHouseLinks.remove(item);
              });
              Navigator.pop(ctx);
            },
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Separa as listas por tipo
    final wifiList = globalHouseLinks.where((item) => item['tipo'] == 'wifi').toList();
    final infoList = globalHouseLinks.where((item) => item['tipo'] == 'info').toList();
    final linkList = globalHouseLinks.where((item) => item['tipo'] == 'link').toList();

    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: const Text("Gestão de Links", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

            // --- GRUPO 1: WI-FI (NOVO) ---
            if (wifiList.isNotEmpty) ...[
              _buildSectionHeader("Redes Wi-Fi", "Rede e Senha"),
              const SizedBox(height: 10),
              ...wifiList.map((item) => _buildEditableItem(context, item)).toList(),
              const SizedBox(height: 30),
            ],
            
            // --- GRUPO 2: DADOS GERAIS ---
            if (infoList.isNotEmpty) ...[
              _buildSectionHeader("Dados da Casa", "Toque para editar"),
              const SizedBox(height: 10),
              ...infoList.map((item) => _buildEditableItem(context, item)).toList(),
              const SizedBox(height: 30),
            ],

            // --- GRUPO 3: DOCUMENTOS ---
            if (linkList.isNotEmpty) ...[
              _buildSectionHeader("Documentos e Links", "Toque para editar"),
              const SizedBox(height: 10),
              ...linkList.map((item) => _buildEditableItem(context, item)).toList(),
            ],

            if (globalHouseLinks.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text("Nenhum item cadastrado.", style: TextStyle(color: Colors.white)),
              ),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEditorDialog(), 
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Color(0xFFD32F2F)),
      ),
    );
  }

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

  Widget _buildEditableItem(BuildContext context, Map<String, dynamic> item) {
    IconData icon = _getIconForTitle(item['titulo'], item['tipo']);
    
    // Formatação especial para exibir Wi-Fi
    String titleText = item['titulo'];
    String subtitleText = item['dado'];
    
    if (item['tipo'] == 'wifi') {
      titleText = "Rede: ${item['titulo']}";
      subtitleText = "Senha: ${item['dado']}";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red[50],
          child: Icon(icon, color: const Color(0xFFD32F2F)),
        ),
        title: Text(
          titleText, 
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1, 
          overflow: TextOverflow.ellipsis
        ),
        subtitle: Text(
          subtitleText, 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12)
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditorDialog(item: item),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteItem(item),
            ),
          ],
        ),
      ),
    );
  }
}