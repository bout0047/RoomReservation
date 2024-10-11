import 'package:flutter/material.dart';
import 'package:room_reservation_app/theme.dart'; // CustomTheme imported
import '../services/reservation_service.dart';
import 'widgets/reservation_timeline.dart';
 // Corrected import path

class ReservationPage extends StatefulWidget {
  final int roomId;

  ReservationPage({required this.roomId});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  TextEditingController dateController = TextEditingController();
  DateTime? selectedDate;
  List<dynamic> reservations = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = "\${picked.toLocal()}".split(' ')[0];
      });
      _fetchReservationsForDate();
    }
  }

  Future<void> _fetchReservationsForDate() async {
    if (selectedDate != null) {
      try {
        reservations = await ReservationService().getReservationsByDate(selectedDate!);
        setState(() {}); // Update UI
      } catch (e) {
        if (e.toString().contains('401')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Session expired. Please log in again.')),
          );
          // Redirect to login page
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch reservations')),
          );
        }
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
              TextField(
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  labelText: 'Select Date',
                  labelStyle: TextStyle(color: CustomTheme.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomTheme.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: CustomTheme.loginGradientEnd),
                  ),
                ),
                style: TextStyle(color: CustomTheme.white),
              ),
              SizedBox(height: 20),
              Expanded(
                child: reservations.isNotEmpty
                    ? ReservationTimeline(reservations: reservations) // Correctly use the ReservationTimeline widget
                    : Center(
                        child: Text(
                          'No reservations available for the selected date',
                          style: TextStyle(color: CustomTheme.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}