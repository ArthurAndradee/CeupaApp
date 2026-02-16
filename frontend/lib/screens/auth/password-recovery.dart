import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo_app/screens/auth/signup.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  // Para redefinição de senha, precisamos apenas de Email
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"), 
            fit: BoxFit.cover, 
          ),
        ),
        child: Center( 
          child: SingleChildScrollView( 
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                // LOGO
                SizedBox(
                  height: 100, 
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),

                // Título
                const Text(
                  "Redefinir senha",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
                const SizedBox(height: 10),
                
                // Texto: Link para criar conta (inverso do login)
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      const TextSpan(text: "Verifique seu email para redefinir sua senha. "),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

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
                const SizedBox(height: 30),
                
                // BOTÃO ENTRAR (REFATORADO)
                SizedBox(
                  width: double.infinity, 
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // 1. Coleta apenas Email e Senha
                      final String email = _emailController.text;
                      final String password = _passwordController.text;

                      // 2. Validação simplificada
                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Por favor, preencha email e senha!"),
                            backgroundColor: Colors.black, 
                          ),
                        );
                      } else {
                        // 3. Simula o login
                        final Map<String, dynamic> loginData = {
                          "email": email,
                          "senha": password,
                        };
                        print("SUCESSO! Tentando fazer login com:");
                        print(loginData);
                        
                        // AQUI: Lógica de conectar ao Backend
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
                      "REDEFINIR SENHA", 
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