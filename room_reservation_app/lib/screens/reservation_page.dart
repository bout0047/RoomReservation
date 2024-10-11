import 'package:flutter/material.dart';
import '../services/reservation_service.dart';

class ReservationPage extends StatefulWidget {
  final int roomId;

  ReservationPage({required this.roomId});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  Future<void> _selectDateTime(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        final DateTime dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        controller.text = dateTime.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reserve Room')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: startTimeController,
              decoration: InputDecoration(
                labelText: 'Start Time',
              ),
              onTap: () => _selectDateTime(context, startTimeController),
            ),
            TextField(
              controller: endTimeController,
              decoration: InputDecoration(
                labelText: 'End Time',
              ),
              onTap: () => _selectDateTime(context, endTimeController),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var response = await ReservationService().createReservation(
                  widget.roomId,
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
