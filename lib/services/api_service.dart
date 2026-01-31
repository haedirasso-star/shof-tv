import 'package:flutter/foundation.dart'; 
import 'dart:convert'; 
import 'package:http/http.dart' as http; 

class ApiService {
  // استخدام المفتاح الخاص بك المخزن مسبقاً
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0"; 
  final String _baseUrl = "https://api.themoviedb.org/3";

  // 1. جلب الأفلام المتصدرة للسلايدر
  Future<List<dynamic>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/trending/all/day?api_key=$_apiKey&language=ar"),
      );
      if (response.statusCode == 200) {
        // تأكد من فك تشفير العربي هنا أيضاً
        return json.decode(utf8.decode(response.bodyBytes))['results'];
      }
    } catch (e) {
      debugPrint("خطأ في جلب الأفلام المتصدرة: $e");
    }
    return [];
  }

  // 2. جلب محتوى الأقسام (أفلام أو مسلسلات)
  Future<List<dynamic>> fetchShofContent(String type) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$type/popular?api_key=$_apiKey&language=ar"),
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes))['results'];
      }
    } catch (e) {
      debugPrint("خطأ في جلب محتوى $type: $e");
    }
    return [];
  }

  // 3. دالة البحث
  Future<List<dynamic>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/search/multi?api_key=$_apiKey&language=ar&query=$query"),
      );
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes))['results'];
      }
    } catch (e) {
      debugPrint("خطأ في عملية البحث: $e");
    }
    return [];
  }

  // 4. دالة جلب القنوات من GitHub (الحل الأكيد لمشكلة الاختفاء)
  Future<List<dynamic>> fetchLiveChannels() async {
    const String githubUrl = "https://raw.githubusercontent.com/haedirasso/shof-tv/main/channels.json";
    try {
      final response = await http.get(Uri.parse(githubUrl)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        // التعديل السحري: استخدام utf8.decode لقراءة الأسماء العربية للقنوات
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        debugPrint("تم جلب القنوات بنجاح: ${data.length} قناة");
        return data;
      } else {
        debugPrint("فشل الجلب: رمز الخطأ ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("عطل في الاتصال بـ GitHub: $e");
      return [];
    }
  }
}
