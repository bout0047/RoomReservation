import 'package:flutter/material.dart';
import 'package:room_reservation_app/services/room_service.dart';

class RoomProvider with ChangeNotifier {
  List<dynamic> _rooms = [];
  bool _isLoading = false;

  List<dynamic> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> fetchRooms() async {
    _isLoading = true;
    notifyListeners();
    try {
      _rooms = await RoomService().getRooms();
    } catch (e) {
      print("Error fetching rooms: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
