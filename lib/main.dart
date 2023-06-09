import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:visitor_power_buddy/views/forgot_password.dart';
import 'package:visitor_power_buddy/views/guest_pre_registration.dart';
import 'package:visitor_power_buddy/views/home_page.dart';
import 'package:visitor_power_buddy/views/login_page.dart';
import 'package:visitor_power_buddy/views/splash_screen.dart';
import 'package:visitor_power_buddy/views/visitor_log.dart';
import 'package:visitor_power_buddy/resources/styles/colours.dart';

import 'firebase_options.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = new MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
