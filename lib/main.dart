import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/services/userservice.dart';

void main() {
  UserService userService = UserService(); // Create an instance of UserService
  runApp(MyApp(userService: userService));
}

class MyApp extends StatelessWidget {
  final UserService userService;

  MyApp({Key? key, required this.userService}) : super(key: key); // Removed const

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth',
      theme: ThemeData(
          // Theme data remains the same...
      ),
      home: WelcomeScreen(userService: userService),
      //home:UserListView(), // Removed const
    );
  }
}
