import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Variável para armazenar a casa selecionada (Dropdown)
  String? _selectedCasa; 

  // Lista de opções para o Dropdown
  final List<String> _casas = ['Casa 1', 'Casa 2', 'Casa 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDE0C15 ), // Fundo Vermelho
      body: Center( // Centraliza tudo verticalmente
        child: SingleChildScrollView( // Permite rolar a tela em celulares pequenos
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // 1. LOGO NO TOPO
              // Certifique-se de ter configurado o pubspec.yaml
              SizedBox(
                height: 100, // Altura definida para não quebrar se a img for grande
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Texto "Criar conta" (Branco)
              const Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto Branco
                ),
              ),
              const SizedBox(height: 10),
              
              // Texto "Já registrado" (Branco)
              const Text(
                "Já registrado? Entre aqui",
                style: TextStyle(color: Colors.white), // Texto Branco
              ), 
              const SizedBox(height: 30),

              // INPUT: NOME
              const Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: Text(
                  "NOME COMPLETO",
                  style: TextStyle(
                    color: Colors.white, // Color White
                    fontWeight: FontWeight.bold, // Optional: Makes it bold like the design
                  ),
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.red), // Typed text is red
                decoration: const InputDecoration(
                  // labelText removed from here
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjusts internal height
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input

              // INPUT: NOME
              const Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: Text(
                  "EMAIL",
                  style: TextStyle(
                    color: Colors.white, // Color White
                    fontWeight: FontWeight.bold, // Optional: Makes it bold like the design
                  ),
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.red), // Typed text is red
                decoration: const InputDecoration(
                  // labelText removed from here
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjusts internal height
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input

              // INPUT: NOME
              const Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: Text(
                  "SENHA",
                  style: TextStyle(
                    color: Colors.white, // Color White
                    fontWeight: FontWeight.bold, // Optional: Makes it bold like the design
                  ),
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input
              TextField(
                controller: _passwordController,
                obscureText: true, 
                style: const TextStyle(color: Colors.red), // Typed text is red
                decoration: const InputDecoration(
                  // labelText removed from here
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15), // Adjusts internal height
                ),
              ),
              const SizedBox(height: 5), // Spacing between text and input
              
              // 2. INPUT CASA (CAIXA DE SELEÇÃO / DROPDOWN)
              const Align(
                alignment: Alignment.centerLeft, // Aligns text to the left
                child: Text(
                  "CASA",
                  style: TextStyle(
                    color: Colors.white, // Color White
                    fontWeight: FontWeight.bold, // Optional: Makes it bold like the design
                  ),
                ),
              ),              
              DropdownButtonFormField<String>(
                value: _selectedCasa,
                style: const TextStyle(color: Colors.red, fontSize: 16), // Texto selecionado vermelho
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                items: _casas.map((String casa) {
                  return DropdownMenuItem<String>(
                    value: casa,
                    child: Text(
                      casa,
                      style: const TextStyle(color: Colors.red), // Opções vermelhas
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCasa = newValue;
                  });
                },
              ),

              const SizedBox(height: 10),
              
              // Botão Esqueceu Senha (Texto Branco)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Esqueceu sua senha? Clique aqui",
                    style: TextStyle(color: Colors.white), // Texto Branco
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // 3. BOTÃO CRIAR CONTA
              SizedBox(
                width: double.infinity, 
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Imprime os dados, incluindo a casa selecionada
                    print("Nome: ${_nameController.text}");
                    print("Casa: $_selectedCasa");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Fundo do botão branco
                    foregroundColor: Colors.red, // Texto do botão vermelho
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "CRIAR CONTA", 
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}