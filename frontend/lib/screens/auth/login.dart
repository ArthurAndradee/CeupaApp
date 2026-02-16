import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_todo_app/screens/auth/signup.dart';
import 'package:flutter_todo_app/screens/auth/password-recovery.dart';
import 'package:flutter_todo_app/screens/home.dart'; // <--- IMPORTANTE: Importe a Home aqui

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

                const Text(
                  "Entrar",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white, 
                  ),
                ),
                const SizedBox(height: 10),
                
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    children: [
                      const TextSpan(text: "Insira suas informações abaixo"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // INPUTS...
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "EMAIL",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "SENHA",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

                const SizedBox(height: 10),
                
                // Esqueceu senha...
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordRecoveryScreen(),
                                ),
                              );                              
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // BOTÃO ENTRAR
                SizedBox(
                  width: double.infinity, 
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final String email = _emailController.text;
                      final String password = _passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Por favor, preencha email e senha!"),
                            backgroundColor: Colors.black, 
                          ),
                        );
                      } else {
                        // 3. Simula o login e NAVEGA
                        print("SUCESSO! Navegando para Home...");
                        
                        // Use pushReplacement para que o botão "voltar" do Android
                        // saia do app em vez de voltar para a tela de login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
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
                      "ENTRAR", 
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