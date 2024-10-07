import 'package:flutter/material.dart';
import '../services/room_service.dart';
import 'reservation_page.dart';

class RoomListPage extends StatefulWidget {
  @override
  _RoomListPageState createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  List<dynamic> rooms = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  void fetchRooms() async {
    var response = await RoomService().getRooms();
    setState(() {
      rooms = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rooms')),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReservationPage(roomId: rooms[index]['id']),
                ),
              );
            },
            child: Card(
              child: ListTile(
                title: Text(rooms[index]['name']),
                subtitle: Text('Capacity: ${rooms[index]['capacity']}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
