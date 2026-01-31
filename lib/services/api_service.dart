import 'package:flutter/foundation.dart'; // ضروري لعمل debugPrint
import 'dart:convert'; // ضروري لعمل json.decode
import 'package:http/http.dart' as http; // ضروري لعمل الطلبات من الإنترنت

class ApiService {
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0";
  final String _baseUrl = "https://api.themoviedb.org/3";

  // 1. دالة جلب الأفلام المتصدرة (Trending) للسلايدر العلوي
  Future<List<dynamic>> getTrendingMovies() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/trending/all/day?api_key=$_apiKey&language=ar"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      }
    } catch (e) {
      debugPrint("خطأ في جلب الأفلام المتصدرة: $e");
    }
    return [];
  }

  // 2. دالة جلب محتوى قسم معين (أفلام أو مسلسلات) للأقسام السفلية
  Future<List<dynamic>> fetchShofContent(String type) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/$type/popular?api_key=$_apiKey&language=ar"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      }
    } catch (e) {
      debugPrint("خطأ في جلب محتوى $type: $e");
    }
    return [];
  }

  // 3. دالة البحث عن الأفلام والمسلسلات
  Future<List<dynamic>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/search/multi?api_key=$_apiKey&language=ar&query=$query"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      }
    } catch (e) {
      debugPrint("خطأ في عملية البحث: $e");
    }
    return [];
  }

  // 4. دالة جلب القنوات من GitHub (التي أرسلتها أنت)
  Future<List<dynamic>> fetchLiveChannels() async {
    const String githubUrl = "https://raw.githubusercontent.com/haedirasso/shof-tv/main/channels.json";
    try {
      final response = await http.get(Uri.parse(githubUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        debugPrint("خطأ في جلب القنوات من GitHub: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("حدث خطأ أثناء الاتصال بـ GitHub: $e");
      return [];
    }
  }
}
