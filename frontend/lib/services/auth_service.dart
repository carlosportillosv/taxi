import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = "http://localhost:5000"; // Cambiar a tu IP si pruebas en móvil

  Future<Map<String, dynamic>> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      }),
    );

    if (response.statusCode == 201) {
      return {"success": true, "message": "Usuario registrado correctamente"};
    } else {
      return {"success": false, "message": "Error al registrar"};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      await prefs.setString("user_role", data["user"]["role"]);

      notifyListeners(); // ✅ Notificamos a los listeners cuando el usuario inicia sesión
      return {"success": true, "message": "Inicio de sesión exitoso"};
    } else {
      return {"success": false, "message": "Credenciales incorrectas"};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("user_role");

    notifyListeners(); // ✅ Notificamos a los listeners cuando el usuario cierra sesión
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }
}
