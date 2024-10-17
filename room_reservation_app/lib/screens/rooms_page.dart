import 'package:flutter/material.dart';
import 'reservation_page.dart'; // Importing reservation page

class RoomsPage extends StatefulWidget {
  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Room Reservations',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Picker
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected Date: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.blueAccent),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          // Room Cards and Time Slots
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Assuming 5 rooms
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              itemBuilder: (context, roomIndex) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.meeting_room, color: Colors.blueAccent),
                            SizedBox(width: 10),
                            Text(
                              'Room ${roomIndex + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Capacity: ${(roomIndex + 1) * 10}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Location: Floor ${roomIndex + 1}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Divider(),
                        // Time Slots
                        Container(
                          height: 80,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10, // 10 time slots (8AM - 6PM)
                            itemBuilder: (context, timeIndex) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservationPage(
                                        roomId: roomIndex + 1,
                                        startTime: '${8 + timeIndex}:00',
                                        date: selectedDate,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${8 + timeIndex}:00',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
