import 'package:beauty_center/complete_profile.dart';
import 'package:beauty_center/edit_profile.dart';
import 'package:beauty_center/home.dart';
import 'package:beauty_center/navigation_menu.dart';
import 'package:beauty_center/profile.dart';
import 'package:beauty_center/sign_in.dart';
import 'package:beauty_center/sign_up.dart';
import 'package:beauty_center/splash.dart';
import 'package:beauty_center/verification_screen.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SignInPage(),
    );
  }
}
