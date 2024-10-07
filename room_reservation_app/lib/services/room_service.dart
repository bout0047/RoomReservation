import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomService {
  final String apiUrl = 'http://localhost:5278/api/Rooms';

  Future<List<dynamic>> getRooms() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}
