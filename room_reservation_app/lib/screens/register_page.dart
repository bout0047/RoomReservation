import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:room_reservation_app/providers/auth_provider.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(context, listen: false).register(
                  nameController.text,
                  emailController.text,
                  passwordController.text,
                );
                // Navigate to home or wherever you want after registration
                Navigator.pushNamed(context, '/');
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
