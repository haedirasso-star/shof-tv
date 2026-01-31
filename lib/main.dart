import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة الروابط
import 'screens/home_screen.dart';

void main() {
  runApp(const ShofTVApp());
}

class ShofTVApp extends StatelessWidget {
  const ShofTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shof TV',
      debugShowCheckedModeBanner: false,
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
      // البداية من شاشة الاشتراك الإجباري
      home: const MandatorySubscriptionScreen(),
    );
  }
}

// شاشة الاشتراك الإجباري
class MandatorySubscriptionScreen extends StatelessWidget {
  const MandatorySubscriptionScreen({super.key});

  // دالة لفتح رابط التلجرام الخاص بك
  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/O_2828'); // رابط حسابك المسجل
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.telegram, size: 100, color: Colors.yellow),
            const SizedBox(height: 30),
            const Text(
              "تطبيق TOL - Shof TV",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.yellow),
            ),
            const SizedBox(height: 15),
            const Text(
              "لمتابعة استخدام التطبيق، يجب عليك الاشتراك في قناة التلجرام الرسمية لتلقي التحديثات وروابط البث الجديدة.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () async {
                await _launchTelegram();
                // بعد الضغط، ننتقل للشاشة الرئيسية
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: const Text(
                "اشترك الآن وافتح التطبيق",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
