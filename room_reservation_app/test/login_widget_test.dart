import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:room_reservation_app/screens/login_page.dart';

void main() {
  testWidgets('Login button should display', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
  });
}
