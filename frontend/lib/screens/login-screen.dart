import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

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
      backgroundColor: const Color(0xFFDE0C15), // Fundo Vermelho
      body: Center( // Centraliza tudo verticalmente
        child: SingleChildScrollView( // Permite rolar a tela em celulares pequenos
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              // 1. LOGO NO TOPO
              SizedBox(
                height: 100, 
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),

              // Texto "Criar conta"
              const Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
              const SizedBox(height: 10),
              
              // Texto "Já registrado? Entre aqui"
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: [
                    const TextSpan(text: "Já registrado? Entre "),
                    TextSpan(
                      text: "aqui",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          // TODO: Navegar para tela de Login
                          print("Clicou em 'Entre aqui'");
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // INPUT: NOME
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "NOME COMPLETO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 15),

              // INPUT: EMAIL
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "EMAIL",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5), 
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 15), 

              // INPUT: SENHA
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "SENHA",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _passwordController,
                obscureText: true, 
                style: const TextStyle(color: Colors.red),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
              ),
              const SizedBox(height: 15),
              
              // INPUT: CASA
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "CASA",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5),                       
              DropdownButtonFormField<String>(
                value: _selectedCasa,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                ),
                items: _casas.map((String casa) {
                  return DropdownMenuItem<String>(
                    value: casa,
                    child: Text(
                      casa,
                      style: const TextStyle(color: Colors.red),
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
              
              // Esqueceu sua senha
              Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white), 
                    children: [
                      const TextSpan(text: "Esqueceu sua senha? Clique "),
                      TextSpan(
                        text: "aqui", 
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline, 
                          decorationColor: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Clicou em 'Recuperar Senha'");
                          },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // 3. BOTÃO CRIAR CONTA (LÓGICA ATUALIZADA)
              SizedBox(
                width: double.infinity, 
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Coleta os valores atuais dos campos
                    final String name = _nameController.text;
                    final String email = _emailController.text;
                    final String password = _passwordController.text;
                    final String? casa = _selectedCasa;

                    // 2. Verifica se algum campo está vazio
                    if (name.isEmpty || email.isEmpty || password.isEmpty || casa == null) {
                      // Se faltar algo, mostra aviso na tela
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Por favor, preencha todas as informações!"),
                          backgroundColor: Colors.black, // Contraste com o fundo vermelho
                        ),
                      );
                    } else {
                      // 3. Se tudo estiver preenchido, reúne os dados
                      final Map<String, dynamic> userData = {
                        "nome": name,
                        "email": email,
                        "senha": password,
                        "casa": casa,
                      };

                      // AÇÃO FUTURA AQUI
                      // Por enquanto, apenas imprimimos no console para confirmar que funcionou
                      print("SUCESSO! Dados reunidos para criar conta:");
                      print(userData);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, 
                    foregroundColor: Colors.red, 
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