import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:room_reservation_app/utils/api_constants.dart';

class AuthService {
  Future<String> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['token'] != null) {
        return body['token'];  // Token is returned from the backend
      } else {
        throw Exception('Failed to register: token not returned');
      }
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['token'] != null) {
        return body['token'];  // Token is returned from the backend
      } else {
        throw Exception('Failed to login: token not returned');
      }
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}
