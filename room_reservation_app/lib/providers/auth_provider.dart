import 'package:flutter/material.dart';
import 'package:room_reservation_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String _token = '';
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> register(String name, String email, String password) async {
    try {
      _token = await _authService.register(name, email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      // Handle registration error (e.g., show a message to the user)
      print("Registration error: $error");
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _token = await _authService.login(email, password);
      _isAuthenticated = true;
      notifyListeners();
    } catch (error) {
      // Handle login error
      print("Login error: $error");
    }
  }

  String get token => _token;
}
