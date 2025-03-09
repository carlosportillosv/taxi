import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _login(BuildContext context) async {
    setState(() => isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.login(emailController.text, passwordController.text);

    setState(() => isLoading = false);
    if (result["success"]) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Iniciar Sesión")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Correo Electrónico")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Contraseña")),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: () => _login(context), child: Text("Ingresar")),
          ],
        ),
      ),
    );
  }
}
