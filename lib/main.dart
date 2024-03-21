import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bottombar.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized
  await GetStorage.init(); // Initialize GetStorage
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final storage = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue, // Set primary color to blue
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black, // Set global cursor color to black
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Joxify',
      home: storage.read("userid") == null ? MyLogin() : MyBottombar(),
    );
  }
}
