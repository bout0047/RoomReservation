import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';

class RoomService {
  final String apiUrl = 'http://localhost:5278/api/Rooms'; // Replace with actual API URL

  Future<List<Room>> getRooms() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Room.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load rooms');
      }
    } catch (e) {
      print('Error fetching rooms: $e');
      throw e;
    }
  }
}
