import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0";
  final String _baseUrl = "https://api.themoviedb.org/3";
  
  // رابط التحكم عن بعد - تأكد من رفع ملف config.json على هذا الرابط في GitHub
  final String _configUrl = "https://raw.githubusercontent.com/haedirasso-star/shof-tv/main/config.json";

  // متغير لتخزين الإعدادات مؤقتاً لتقليل الطلبات على GitHub
  Map<String, dynamic>? _cachedConfig;

  // 1. جلب إعدادات السيرفر (Xtream) مع نظام التخزين المؤقت
  Future<Map<String, dynamic>> fetchRemoteConfig() async {
    if (_cachedConfig != null) return _cachedConfig!;

    try {
      final response = await http.get(Uri.parse(_configUrl)).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        _cachedConfig = json.decode(utf8.decode(response.bodyBytes));
        return _cachedConfig!;
      }
    } catch (e) {
      debugPrint("Config Error: $e");
    }
    
    // بيانات الطوارئ (تأكد من تحديثها دائماً)
    return {
      "host": "http://stariptv.org:8080",
      "user": "basma2022",
      "pass": "123456"
    };
  }

  // 2. جلب القنوات المباشرة مع معالجة البيانات الضخمة
  Future<List<dynamic>> fetchLiveChannels() async {
    try {
      final config = await fetchRemoteConfig();
      final String url = "${config['host']}/player_api.php?username=${config['user']}&password=${config['pass']}&action=get_live_streams";
      
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint("Xtream Live TV Error: $e");
    }
    return [];
  }

  // 3. جلب الأفلام والمسلسلات الرائجة (TMDB)
  Future<List<dynamic>> getTrendingMovies() async {
    return _fetchFromTMDB("$_baseUrl/trending/all/day?api_key=$_apiKey&language=ar");
  }

  // 4. دالة البحث الشامل (البحث في الأفلام والمسلسلات والقنوات مستقبلاً)
  Future<List<dynamic>> searchMovies(String query) async {
    if (query.isEmpty) return [];
    final String encodedQuery = Uri.encodeComponent(query);
    return _fetchFromTMDB("$_baseUrl/search/multi?api_key=$_apiKey&language=ar&query=$encodedQuery");
  }

  // 5. جلب تصنيفات القنوات (لتنظيم الواجهة)
  Future<List<dynamic>> fetchLiveCategories() async {
    try {
      final config = await fetchRemoteConfig();
      final String url = "${config['host']}/player_api.php?username=${config['user']}&password=${config['pass']}&action=get_live_categories";
      
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint("Categories Error: $e");
    }
    return [];
  }

  // 6. جلب محتوى مخصص حسب النوع (أفلام حديثة، مسلسلات)
  Future<List<dynamic>> fetchShofContent(String type) async {
    // type: 'movie' or 'tv'
    return _fetchFromTMDB("$_baseUrl/$type/popular?api_key=$_apiKey&language=ar");
  }

  // دالة مساعدة خاصة (Private) لتوحيد طلبات TMDB وتقليل تكرار الكود
  Future<List<dynamic>> _fetchFromTMDB(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['results'] ?? [];
      }
    } catch (e) {
      debugPrint("TMDB Fetch Error: $e");
    }
    return [];
  }
}
