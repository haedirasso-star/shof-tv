import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // تفعيل واجهة Shof TV الأولى
  runApp(const ShofTVApp());
}

class ShofTVApp extends StatelessWidget {
  const ShofTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shof TV',
      debugShowCheckedModeBanner: false,
      // السمة السوداء والذهبية التي طلبتها
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellowAccent,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
