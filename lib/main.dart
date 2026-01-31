import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  // تفعيل واجهة Shof TV
  runApp(const ShofTVApp());
}

class ShofTVApp extends StatelessWidget {
  const ShofTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shof TV',
      debugShowCheckedModeBanner: false,
      // السمة السوداء والذهبية الاحترافية لـ Shof TV
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // تم إزالة const من هنا لأن HomeScreen تحتوي على بيانات متغيرة
      home: HomeScreen(), 
    );
  }
}
