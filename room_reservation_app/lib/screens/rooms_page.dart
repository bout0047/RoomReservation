import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reservation_page.dart';  // Make sure this exists

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Available Rooms')),
      body: FutureBuilder<List<Room>>(
        future: _fetchRooms(authProvider.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No rooms available'));
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rooms[index].name,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Capacity: ${rooms[index].capacity}'),
                        Text('Location: ${rooms[index].location}'),
                        Text('Amenities: ${rooms[index].amenities}'),
                        SizedBox(height: 10),
                        // Reserve Room button added here
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Customize button color
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationPage(roomId: rooms[index].id),
                              ),
                            );
                          },
                          child: Text('Reserve Room'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Room>> _fetchRooms(String? token) async {
    final response = await http.get(
      Uri.parse('http://localhost:5278/api/rooms'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }
}

class Room {
  final int id;
  final String name;
  final int capacity;
  final String location;
  final String amenities;

  Room({
    required this.id,
    required this.name,
    required this.capacity,
    required this.location,
    required this.amenities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['roomId'],
      name: json['name'],
      capacity: json['capacity'],
      location: json['location'],
      amenities: json['amenities'],
    );
  }
}
