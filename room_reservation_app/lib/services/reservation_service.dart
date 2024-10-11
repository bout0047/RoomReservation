import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:room_reservation_app/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReservationService {
  final String apiUrl = 'http://localhost:5278/api/Reservations';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<bool> createReservation(int roomId, String startTime, String endTime) async {
    final String? token = await _getToken();
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Added token header
      },
      body: jsonEncode(<String, dynamic>{
        'RoomId': roomId,
        'StartTime': startTime,
        'EndTime': endTime,
      }),
    );

    return response.statusCode == 200;
  }

  Future<List<dynamic>> getReservationsByDate(DateTime date) async {
    final String? token = await _getToken();
    final response = await http.get(
      Uri.parse('$apiUrl/byDate?date=${date.toIso8601String()}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // Added token header
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}
