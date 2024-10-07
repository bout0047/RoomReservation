import 'package:flutter/material.dart';
import '../services/reservation_service.dart';

class ReservationPage extends StatelessWidget {
  final int roomId;
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();

  ReservationPage({required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserve Room')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: startTimeController,
              decoration: InputDecoration(labelText: 'Start Time (YYYY-MM-DD HH:MM:SS)'),
            ),
            TextFormField(
              controller: endTimeController,
              decoration: InputDecoration(labelText: 'End Time (YYYY-MM-DD HH:MM:SS)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var response = await ReservationService().createReservation(
                  roomId,
                  startTimeController.text,
                  endTimeController.text,
                );
                if (response) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reservation created successfully')),
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to create reservation')),
                  );
                }
              },
              child: Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }
}
