import 'package:flutter/material.dart';
import 'package:room_reservation_app/screens/reservation_page.dart';
class ReservationPage extends StatelessWidget {
  final int roomId;
  final String startTime;
  final DateTime date;

  const ReservationPage({
    Key? key,
    required this.roomId,
    required this.startTime,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room: $roomId',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Date: ${date.day}-${date.month}-${date.year}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Time: $startTime',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement reservation logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reservation Confirmed for Room $roomId'),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text('Confirm Reservation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}