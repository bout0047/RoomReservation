import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String apiUrl = 'http://localhost:5278/api/Users';

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return response.statusCode == 200; // Assuming 200 is success code
  }

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }
}
