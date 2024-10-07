import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {
  final String apiUrl = 'http://localhost:5278/api/Reservations';

  Future<bool> createReservation(int roomId, String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'RoomId': roomId,
        'StartTime': startTime,
        'EndTime': endTime,
      }),
    );

    return response.statusCode == 200;
  }
}
