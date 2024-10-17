class Room {
  final int roomId;
  final String name;
  final int capacity;
  final String location;

  Room({
    required this.roomId,
    required this.name,
    required this.capacity,
    required this.location,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      name: json['name'],
      capacity: json['capacity'],
      location: json['location'],
    );
  }
}
