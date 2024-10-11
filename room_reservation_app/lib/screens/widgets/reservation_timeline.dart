import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationTimeline extends StatelessWidget {
  final List<dynamic> reservations;

  ReservationTimeline({required this.reservations});

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.week,
      dataSource: ReservationDataSource(getDataSource()),
    );
  }

  List<Appointment> getDataSource() {
    List<Appointment> appointments = <Appointment>[];

    for (var reservation in reservations) {
      final DateTime startTime = DateTime.parse(reservation['startTime']);
      final DateTime endTime = DateTime.parse(reservation['endTime']);
      final String roomName = reservation['roomName'];

      appointments.add(
        Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: 'Reservation for $roomName',
          color: Colors.blue,
        ),
      );
    }

    return appointments;
  }
}

class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource(List<Appointment> source) {
    appointments = source;
  }
}
