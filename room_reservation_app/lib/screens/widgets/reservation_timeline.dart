import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class ReservationTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimetableView(
      laneEventsList: [
        LaneEvents(
          lane: Lane(name: 'Room 101'),
          events: [
            TableEvent(
              title: 'Booked',
              start: TableEventTime(hour: 8, minute: 0),
              end: TableEventTime(hour: 10, minute: 0),
            ),
            TableEvent(
              title: 'Available',
              start: TableEventTime(hour: 10, minute: 15),
              end: TableEventTime(hour: 12, minute: 0),
            ),
          ],
        ),
        LaneEvents(
          lane: Lane(name: 'Room 202'),
          events: [
            TableEvent(
              title: 'Available',
              start: TableEventTime(hour: 8, minute: 0),
              end: TableEventTime(hour: 10, minute: 0),
            ),
          ],
        ),
      ],
    );
  }
}
