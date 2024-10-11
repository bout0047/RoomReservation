import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';
import 'package:room_reservation_app/screens/login_page.dart';
import 'package:room_reservation_app/screens/register_page.dart';
import 'package:room_reservation_app/screens/profile_page.dart';
import 'package:room_reservation_app/screens/home_page.dart';
import 'package:room_reservation_app/theme.dart'; // Import CustomTheme

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
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary swatch already set to blue
        scaffoldBackgroundColor: CustomTheme.white, // Set background color globally
      ),
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
