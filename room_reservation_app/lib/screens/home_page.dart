import 'package:flutter/material.dart';
import 'package:room_reservation_app/models/room.dart';
import 'package:room_reservation_app/services/room_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Room>? rooms;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      rooms = await RoomService().getRooms();
      print("Rooms fetched: ${rooms?.length}");  // Debug log
    } catch (e) {
      print("Error fetching rooms: $e");  // Print error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservations'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : rooms == null || rooms!.isEmpty
              ? Center(child: Text('No rooms available'))
              : ListView.builder(
                  itemCount: rooms!.length,
                  itemBuilder: (context, index) {
                    var room = rooms![index];
                    return ListTile(
                      title: Text(room.name),
                      subtitle: Text('Capacity: ${room.capacity}, Location: ${room.location}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReservationPage(
                              roomId: room.roomId,
                              selectedDate: DateTime.now(),  // Placeholder date
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

class ReservationPage extends StatelessWidget {
  final int roomId;
  final DateTime selectedDate;

  ReservationPage({required this.roomId, required this.selectedDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservation Page')),
      body: Center(
        child: Text('Reserve room $roomId for $selectedDate'),
      ),
    );
  }
}
