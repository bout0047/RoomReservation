import 'package:flutter_test/flutter_test.dart';
import 'package:room_reservation_app/services/user_service.dart';

void main() {
  test('Test login functionality', () async {
    UserService userService = UserService();
    var result = await userService.login('test@example.com', 'password123');
    expect(result, isNotNull);
  });
}
