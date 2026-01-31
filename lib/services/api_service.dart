import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0";
  final String _baseUrl = "https://api.themoviedb.org/3";

  // 1. جلب القنوات من مستودع Shof TV (GitHub Raw)
  Future<List<dynamic>> fetchLiveChannels() async {
    const String githubUrl = "https://raw.githubusercontent.com/haedirasso-star/shof-tv/main/channels.json";
    try {
      final response = await http.get(Uri.parse(githubUrl)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint("Live TV Error: $e");
    }
    return [];
  }

  // 2. جلب الأفلام والمسلسلات الرائجة (السلايدر)
  Future<List<dynamic>> getTrendingMovies() async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/trending/all/day?api_key=$_apiKey&language=ar"));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes))['results'];
      }
    } catch (e) {
      debugPrint("Movies Error: $e");
    }
    return [];
  }

  // 3. جلب محتوى الأقسام (أفلام أو مسلسلات شعبية)
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

  // 4. دالة البحث الشامل (البحث عن أي فيلم أو مسلسل)
  Future<List<dynamic>> searchMovies(String query) async {
    if (query.isEmpty) return [];
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
}
