import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0";
  final String _baseUrl = "https://api.themoviedb.org/3";
  
  // روابط التحكم عن بعد
  final String _configUrl = "https://raw.githubusercontent.com/haedirasso-star/shof-tv/main/config.json";

  // 1. جلب إعدادات السيرفر (Xtream) عن بعد
  Future<Map<String, dynamic>> fetchRemoteConfig() async {
    try {
      final response = await http.get(Uri.parse(_configUrl));
      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      debugPrint("Config Error: $e");
    }
    // إرجاع بيانات افتراضية في حال فشل الاتصال بـ GitHub
    return {
      "host": "http://stariptv.org:8080",
      "user": "basma2022",
      "pass": "123456"
    };
  }

  // 2. جلب القنوات المباشرة من Xtream Codes (مطور)
  Future<List<dynamic>> fetchLiveChannels() async {
    try {
      final config = await fetchRemoteConfig();
      final String url = "${config['host']}/player_api.php?username=${config['user']}&password=${config['pass']}&action=get_live_streams";
      
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
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

  // 4. دالة البحث الشامل
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
      debugPrint("Search Error: $e");
    }
    return [];
  }

  // 5. جلب تصنيفات القنوات (جديد لاحترافية التنظيم)
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
}
