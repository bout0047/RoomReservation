class Reservation {
  final String startTime;
  final String endTime;
  final int roomId;

  Reservation({
    required this.startTime,
    required this.endTime,
    required this.roomId,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      startTime: json['startTime'],
      endTime: json['endTime'],
      roomId: json['roomId'],
    );
  }
}
