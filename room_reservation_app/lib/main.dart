import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';
import 'package:room_reservation_app/screens/login_page.dart';
import 'package:room_reservation_app/screens/register_page.dart';
import 'package:room_reservation_app/screens/profile_page.dart';
import 'package:room_reservation_app/screens/home_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Reservation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/profile': (context) => ProfilePage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
