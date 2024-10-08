import 'package:flutter/material.dart';
import 'package:room_reservation_app/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  Future<void> login(String email, String password) async {
    try {
      _token = await _authService.login(email, password);
      await _secureStorage.write(key: 'token', value: _token);
      notifyListeners();
    } catch (error) {
      throw Exception('Login failed: $error');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _token = await _authService.register(name, email, password);
      await _secureStorage.write(key: 'token', value: _token);
      notifyListeners();
    } catch (error) {
      throw Exception('Registration failed: $error');
    }
  }

  Future<void> logout() async {
    _token = null;
    await _secureStorage.delete(key: 'token');
    notifyListeners();
  }
}
