import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo_app/screens/auth/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String? _selectedCasa; 
  final List<String> _casas = ['Casa 1', 'Casa 2', 'Casa 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. ALTERAÇÃO: Removemos o backgroundColor vermelho daqui
      // backgroundColor: const Color(0xFFDE0C15), 
      
      body: Container( // 2. ALTERAÇÃO: Adicionamos este Container para a imagem de fundo
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), // Troque pelo nome da sua imagem
            fit: BoxFit.cover, // Faz a imagem cobrir toda a tela sem distorcer
          ),
        ),
        child: Center( 
          child: SingleChildScrollView( 
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
                            // CÓDIGO DE NAVEGAÇÃO AQUI:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
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

                const SizedBox(height: 30),
                
                // BOTÃO CRIAR CONTA
                SizedBox(
                  width: double.infinity, 
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final String name = _nameController.text;
                      final String email = _emailController.text;
                      final String password = _passwordController.text;
                      final String? casa = _selectedCasa;

                      if (name.isEmpty || email.isEmpty || password.isEmpty || casa == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Por favor, preencha todas as informações!"),
                            backgroundColor: Colors.black, 
                          ),
                        );
                      } else {
                        final Map<String, dynamic> userData = {
                          "nome": name,
                          "email": email,
                          "senha": password,
                          "casa": casa,
                        };
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
      ),
    );
  }
}