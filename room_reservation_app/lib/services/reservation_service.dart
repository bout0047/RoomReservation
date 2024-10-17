import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/reservation.dart';

class ReservationService {
  final String apiUrl = 'http://localhost:5278/api/Reservations'; // Replace with actual API URL

  Future<List<Reservation>> getReservationsByRoomAndDate(int roomId, DateTime date) async {
    final response = await http.get(Uri.parse('$apiUrl/byRoomAndDate?roomId=$roomId&date=$date'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Reservation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}
