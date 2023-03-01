import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/views/forgot_password.dart';
import 'package:visitor_power_buddy/views/guest_pre_registration.dart';
import 'package:visitor_power_buddy/views/home_page.dart';
import 'package:visitor_power_buddy/views/login_page.dart';
import 'package:visitor_power_buddy/views/visitor_log.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: appBackgroundColour,
      ),
      home: const LoginPage(),
    );
  }
}
