import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'home_screen.dart';
import '../services/api_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _startAppLogic();
  }

  // منطق تشغيل التطبيق
  Future<void> _startAppLogic() async {
    // 1. انتظر قليلاً لإظهار اللوجو (ثانيتين)
    await Future.delayed(const Duration(seconds: 2));

    // 2. فحص الإنترنت
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _showErrorDialog("لا يوجد اتصال بالإنترنت. يرجى تفعيل الشبكة والمحاولة مرة أخرى.");
      return;
    }

    // 3. جلب بيانات السيرفر من GitHub للتأكد أن التطبيق يعمل
    try {
      final config = await _apiService.fetchRemoteConfig();
      if (config.isNotEmpty) {
        // إذا كل شيء تمام، انتقل للرئيسية
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      _showErrorDialog("فشل الاتصال بخوادم Shof TV. حاول لاحقاً.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("خطأ في التشغيل", style: TextStyle(color: Colors.yellow)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => _startAppLogic(), // إعادة المحاولة
            child: const Text("إعادة المحاولة", style: TextStyle(color: Colors.yellow)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار التطبيق مع حركة أنيميشن بسيطة
            TweenAnimationBuilder(
              duration: const Duration(seconds: 1),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: value,
                    child: Image.asset("assets/images/logo.png", width: 180),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.yellow),
            const SizedBox(height: 20),
            const Text(
              "SHOF TV",
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const Text(
              "عالم القنوات والسينما في يدك",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
