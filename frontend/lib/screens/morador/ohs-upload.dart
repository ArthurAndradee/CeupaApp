import 'dart:io'; // Necessário para lidar com arquivos
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Pacote de galeria

class OhsUploadScreen extends StatefulWidget {
  final String areaName;

  const OhsUploadScreen({super.key, required this.areaName});

  @override
  State<OhsUploadScreen> createState() => _OhsUploadScreenState();
}

class _OhsUploadScreenState extends State<OhsUploadScreen> {
  // Agora armazenamos Arquivos (File), não apenas Strings
  final List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();

  // Função para abrir a galeria
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        _photos.add(File(image.path));
      });
    }
  }

  // Função para abrir imagem em tela cheia
  void _openFullScreen(File imageFile) {
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
            child: InteractiveViewer( // Permite zoom com pinça
              child: Image.file(imageFile),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD32F2F),
      appBar: AppBar(
        title: Text("Limpar: ${widget.areaName}", style: const TextStyle(color: Colors.white, fontSize: 18)),
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
                  const Text(
                    "Evidências da Limpeza",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD32F2F)),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tire fotos da área limpa para comprovar sua tarefa.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _photos.length + 1,
                    itemBuilder: (context, index) {
                      // Botão de Adicionar
                      if (index == _photos.length) {
                        return GestureDetector(
                          onTap: _pickImage, // Chama a função da galeria
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: const Icon(Icons.add_a_photo, color: Colors.grey, size: 30),
                          ),
                        );
                      }
                      
                      // Exibição da Foto
                      return GestureDetector(
                        onTap: () => _openFullScreen(_photos[index]), // Clica para ampliar
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(_photos[index]), // Mostra o arquivo real
                              fit: BoxFit.cover,
                            )
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _photos.isEmpty 
                        ? null 
                        : () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Limpeza registrada! Aguardando avaliação."))
                          );
                        },
                      child: const Text("ENVIAR PARA AVALIAÇÃO"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}