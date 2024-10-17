import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../services/reservation_service.dart';

class RoomBookingPage extends StatefulWidget {
  @override
  _RoomBookingPageState createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage> {
  DateTime? selectedDate;
  List<dynamic> rooms = [];
  Map<String, List<bool>> availability = {}; // Availability of rooms by time slots
  List<String> times = ["8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM"];
  List<Map<String, dynamic>> selectedSlots = [];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    _fetchRoomsAndAvailability();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
      _fetchRoomsAndAvailability();
    }
  }

  Future<void> _fetchRoomsAndAvailability() async {
    if (selectedDate != null) {
      try {
        // Fetch the rooms and availability for the selected date
        rooms = await RoomService().getRooms();
        print("Fetched Rooms: $rooms");

        // Initialize availability
        availability.clear();
        for (var room in rooms) {
          availability[room['name']] = List.generate(times.length, (index) => true); // All slots available initially
        }

        setState(() {});
      } catch (e) {
        print("Error fetching rooms or availability: $e");
      }
    }
  }

  void _toggleSlot(String roomName, int timeIndex) {
    setState(() {
      bool isSelected = availability[roomName]![timeIndex];
      availability[roomName]![timeIndex] = !isSelected;

      if (!isSelected) {
        // Add to selected slots
        selectedSlots.add({
          'roomName': roomName,
          'startTime': times[timeIndex],
        });
      } else {
        // Remove from selected slots
        selectedSlots.removeWhere((slot) => slot['roomName'] == roomName && slot['startTime'] == times[timeIndex]);
      }
    });
  }

  Future<void> _submitReservation() async {
    if (selectedSlots.isNotEmpty) {
      try {
        for (var slot in selectedSlots) {
          String roomName = slot['roomName'];
          String startTime = slot['startTime'];

          await ReservationService().createReservationForRoomAndTime(roomName, selectedDate!, startTime);
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reservation created successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create reservation: ${e.toString()}')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one time slot')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Select Date:"),
                TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(selectedDate != null ? "${selectedDate!.toLocal()}".split(' ')[0] : "Select Date"),
                ),
              ],
            ),
            SizedBox(height: 16),
            rooms.isNotEmpty
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Table(
                            border: TableBorder.all(),
                            columnWidths: {
                              0: FixedColumnWidth(120),
                            },
                            children: [
                              TableRow(
                                children: [
                                  TableCell(child: Center(child: Text("Rooms"))),
                                  ...times.map((time) => TableCell(child: Center(child: Text(time)))).toList(),
                                ],
                              ),
                              ...rooms.map((room) {
                                return TableRow(
                                  children: [
                                    TableCell(child: Padding(padding: const EdgeInsets.all(8.0), child: Text(room['name']))),
                                    ...List.generate(times.length, (index) {
                                      bool isAvailable = availability[room['name']]![index];
                                      return TableCell(
                                        child: GestureDetector(
                                          onTap: () => _toggleSlot(room['name'], index),
                                          child: Container(
                                            color: isAvailable ? Colors.green : Colors.red,
                                            height: 40,
                                            child: Center(
                                              child: Text(isAvailable ? 'Available' : 'Selected'),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReservation,
              child: Text('Reserve'),
            ),
          ],
        ),
      ),
    );
  }
}
