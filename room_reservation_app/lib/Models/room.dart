class Room {
  final int roomId;
  final String name;
  final int capacity;
  final String location;
  final String amenities;

  Room({
    required this.roomId,
    required this.name,
    required this.capacity,
    required this.location,
    required this.amenities,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      name: json['name'],
      capacity: json['capacity'],
      location: json['location'],
      amenities: json['amenities'],
    );
  }
}
