import 'package:flutter/material.dart';
import 'package:flutter_todo_app/dashboard.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';
import 'package:flutter_todo_app/screens/login-screen.dart'; // Check your package name

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token'),));
}

class MyApp extends StatelessWidget {

  final token;
  const MyApp({
    @required this.token,
    Key? key,
}): super(key: key);

  @override
    Widget build(BuildContext context) {
        return MaterialApp(
          title: 'CeupaApp',
          theme: ThemeData(
            // The red color from your design headers [cite: 1, 17]
            primaryColor: const Color(0xFFD32F2F), 
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
            // Style for the buttons [cite: 16, 24]
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F), // Button Red
                foregroundColor: Colors.white, // Text White
              ),
            ),
          ),
          home: const LoginScreen(), // We will create this next
        );
      }
}


