import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.meeting_room),
            title: Text('Room 1'),
            subtitle: Text('Capacity: 10 people'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to the reservation page or room details
            },
          ),
          ListTile(
            leading: Icon(Icons.meeting_room),
            title: Text('Room 2'),
            subtitle: Text('Capacity: 5 people'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Navigate to the reservation page or room details
            },
          ),
        ],
      ),
    );
  }
}
