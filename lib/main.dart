import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ShofTVApp());
}

class ShofTVApp extends StatelessWidget {
  const ShofTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shof TV - TOL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.yellow[700],
        scaffoldBackgroundColor: const Color(0xFF000000),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      home: const MandatorySubscriptionScreen(),
    );
  }
}

class MandatorySubscriptionScreen extends StatelessWidget {
  const MandatorySubscriptionScreen({super.key});

  // فتح رابط التليجرام الخاص بك O_2828
  Future<void> _launchTelegram() async {
    final Uri url = Uri.parse('https://t.me/O_2828');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // تدرج لوني يعطي لمسة فخامة خلف الأيقونة
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Colors.yellow.withOpacity(0.1), Colors.black],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة التليجرام بتأثير الظل المتوهج
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.2),
                    blurRadius: 50,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(Icons.telegram_rounded, size: 120, color: Colors.yellow),
            ),
            const SizedBox(height: 40),
            const Text(
              "TOL • SHOF TV",
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.black, 
                color: Colors.yellow,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.yellow.withOpacity(0.2)),
              ),
              child: const Text(
                "للحصول على أفضل تجربة مشاهدة وضمان استمرارية السيرفرات، يرجى الانضمام لقناتنا الرسمية. الضغط على الزر أدناه يمنحك حق الدخول للتطبيق.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white70, height: 1.5),
              ),
            ),
            const SizedBox(height: 50),
            // زر الاشتراك بتصميم كبسولة متوهج
            GestureDetector(
              onTap: () async {
                await _launchTelegram();
                // تأخير بسيط لضمان انتقال المستخدم للتليجرام أولاً
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                });
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    "اشترك وافتح المشغل",
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "إصدار v1.0.0 - المطور حيدر",
              style: TextStyle(color: Colors.white24, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
