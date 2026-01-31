import 'package:flutter/foundation.dart'; // ضروري لعمل debugPrint
import 'dart:convert'; // ضروري لعمل json.decode
import 'package:http/http.dart' as http; // ضروري لعمل الطلبات من الإنترنت

class ApiService {
  final String _apiKey = "5b166a24c91f59178e8ce30f1f3735c0";
  final String _baseUrl = "https://api.themoviedb.org/3";

  // دالة جلب القنوات من GitHub
  Future<List<dynamic>> fetchLiveChannels() async {
    const String githubUrl = "https://raw.githubusercontent.com/haedirasso/shof-tv/main/channels.json";
    
    try {
      final response = await http.get(Uri.parse(githubUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else {
        debugPrint("خطأ في جلب القنوات: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      debugPrint("حدث خطأ أثناء الاتصال بـ GitHub: $e");
      return [];
    }
  }

  // أضف هنا باقي الدوال الخاصة بالأفلام (getTrendingMovies و fetchShofContent)
  // للتأكد من أنها تستخدم نفس الـ imports الموجودة بالأعلى
}
