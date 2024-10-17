import 'package:flutter/material.dart';
import '../services/room_service.dart';
import '../services/reservation_service.dart';
import '../models/room.dart';
import '../models/reservation.dart';
import 'package:intl/intl.dart'; // To format time slots

class ReservationTable extends StatefulWidget {
  final DateTime selectedDate;

  const ReservationTable({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _ReservationTableState createState() => _ReservationTableState();
}

class _ReservationTableState extends State<ReservationTable> {
  List<Room> rooms = [];
  List<String> timeSlots = ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00"];
  Map<int, List<bool>> availability = {}; // Maps roomId to time slot availability
  bool isLoading = true; // Track loading state
  String? errorMessage; // To display errors if any

  @override
  void initState() {
    super.initState();
    _fetchRoomsAndAvailability();
  }

  // Fetch rooms and availability from backend
  Future<void> _fetchRoomsAndAvailability() async {
    try {
      // Fetch room data
      List<Room> fetchedRooms = await RoomService().getRooms();
      print("Rooms fetched: ${fetchedRooms.length}");
      if (fetchedRooms.isEmpty) {
        setState(() {
          errorMessage = "No rooms available.";
          isLoading = false;
        });
        return;
      }

      setState(() {
        rooms = fetchedRooms;
      });

      // Fetch reservations for each room
      for (var room in rooms) {
        List<Reservation> fetchedReservations = await ReservationService()
            .getReservationsByRoomAndDate(room.roomId, widget.selectedDate);
        print("Reservations fetched for room ${room.roomId}: ${fetchedReservations.length}");

        // Initialize room availability
        setState(() {
          availability[room.roomId] = List.generate(timeSlots.length, (index) => true);
        });

        // Update availability based on reservations
        for (var reservation in fetchedReservations) {
          DateTime start = DateTime.parse(reservation.startTime);
          int timeIndex = timeSlots.indexOf(DateFormat('HH:mm').format(start));
          if (timeIndex != -1) {
            setState(() {
              availability[room.roomId]![timeIndex] = false;
            });
          }
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching rooms or reservations: $e");
      setState(() {
        errorMessage = "Failed to load data.";
        isLoading = false;
      });
    }
  }

  // Toggle time slot availability (for UI feedback)
  void _toggleSlot(int roomId, int timeIndex) {
    setState(() {
      availability[roomId]![timeIndex] = !availability[roomId]![timeIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Building UI, rooms length: ${rooms.length}"); // Debugging log

    return Scaffold(
      appBar: AppBar(
        title: Text('Room Reservations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator()) // Loading spinner
            : errorMessage != null
                ? Center(child: Text(errorMessage!)) // Error message
                : rooms.isEmpty
                    ? Center(child: Text("No rooms available")) // No rooms fetched
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9, // Set dynamic width for table
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: {
                                  0: FixedColumnWidth(150), // Set column width for room names
                                },
                                children: [
                                  // Header row showing the time slots
                                  TableRow(
                                    children: [
                                      TableCell(
                                          child: Center(
                                              child: Text(
                                        "Rooms",
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ))),
                                      ...timeSlots.map((time) {
                                        return TableCell(
                                          child: Center(
                                              child: Text(
                                            time,
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          )),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                  // Table rows for each room and their availability
                                  ...rooms.map((room) {
                                    int roomId = room.roomId;
                                    return TableRow(
                                      children: [
                                        // Room name cell
                                        TableCell(
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(room.name)),
                                        ),
                                        // Time slots for the room
                                        ...List.generate(timeSlots.length, (index) {
                                          bool isAvailable = availability[roomId]![index];
                                          return TableCell(
                                            child: GestureDetector(
                                              onTap: () => _toggleSlot(roomId, index),
                                              child: Container(
                                                color: isAvailable ? Colors.green : Colors.red,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    isAvailable ? 'Available' : 'Reserved',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
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
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
