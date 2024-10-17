import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ReservationTimeline extends StatelessWidget {
  final List<dynamic> reservations;
  final Function(DateTime) onSlotSelect;
  final List<DateTime> selectedSlots;

  ReservationTimeline({
    required this.reservations,
    required this.onSlotSelect,
    required this.selectedSlots,
  });

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month, // Show the month view to display all reservations for each day
      dataSource: ReservationDataSource(getDataSource()),
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell && details.date != null) {
          onSlotSelect(details.date!);
        }
      },
      appointmentBuilder: (context, calendarAppointmentDetails) {
        final List<Appointment> appointments = calendarAppointmentDetails.appointments.cast<Appointment>().toList();
        final DateTime startTime = appointments[0].startTime;
        final bool isSelected = selectedSlots.contains(startTime);

        return Container(
          color: isSelected ? Colors.green.withOpacity(0.7) : Colors.blue,
          child: Center(
            child: Text(
              appointments[0].subject,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
      monthViewSettings: MonthViewSettings(
        showAgenda: true, // Show an agenda for each day with all reservations
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment, // Display appointments within the day cells
      ),
    );
  }

  // Generate appointments from the reservation data
  List<Appointment> getDataSource() {
    List<Appointment> appointments = <Appointment>[];

    // Print reservations to check data format
    print('Reservations Data: $reservations');

    for (var reservation in reservations) {
      // Ensure startTime and endTime are not null
      if (reservation['startTime'] != null && reservation['endTime'] != null) {
        try {
          // Parse startTime and endTime
          final DateTime startTime = DateTime.parse(reservation['startTime']);
          final DateTime endTime = DateTime.parse(reservation['endTime']);
          
          // Check if room name exists, if not, use a default value
          final String roomName = (reservation['room'] != null && reservation['room']['roomName'] != null)
              ? reservation['room']['roomName']
              : 'Room';  // Fallback to 'Room' if roomName is missing

          // Add the appointment to the list
          appointments.add(
            Appointment(
              startTime: startTime,
              endTime: endTime,
              subject: 'Reservation for $roomName',
              color: Colors.blue,
            ),
          );
        } catch (e) {
          // Handle any parsing errors
          print('Error parsing reservation times: $e');
        }
      } else {
        // Log missing or invalid data
        print('Missing or invalid startTime or endTime in reservation: $reservation');
      }
    }

    return appointments;
  }
}

// Calendar data source for Syncfusion calendar
class ReservationDataSource extends CalendarDataSource {
  ReservationDataSource(List<Appointment> source) {
    appointments = source;
  }
}
