import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
      body: Center(child: Text("Bienvenido a la aplicación de Taxi")),
    );
  }
}
