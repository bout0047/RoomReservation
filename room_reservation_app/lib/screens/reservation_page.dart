import 'package:flutter/material.dart';
import 'package:room_reservation_app/theme.dart'; // CustomTheme imported
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: CustomTheme.white),
        title: Text('Reserve Room', style: TextStyle(color: CustomTheme.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomTheme.loginGradientStart, CustomTheme.loginGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reserve a Room',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.white,
                ),
              ),
              SizedBox(height: 20),
              _buildDateTimeField('Start Time', startTimeController),
              SizedBox(height: 20),
              _buildDateTimeField('End Time', endTimeController),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomTheme.loginGradientStart, // Corrected parameter
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
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
                  child: Text(
                    'Reserve',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDateTime(context, controller),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: CustomTheme.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomTheme.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomTheme.loginGradientEnd),
        ),
      ),
      style: TextStyle(color: CustomTheme.white),
    );
  }
}
