import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = "5b166a24c91f59178e8ce30f1f3735c0"; // مفتاح Shof TV الخاص بك
  final String baseUrl = "https://api.themoviedb.org/3";

  // جلب الأفلام والمسلسلات العربية والتركية المدبلجة
  Future<List<dynamic>> fetchShofContent(String type) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/discover/$type?api_key=$apiKey&with_original_language=ar|tr&sort_by=popularity.desc"));

    if (response.statusCode == 200) {
      return json.decode(response.body)['results'];
    } else {
      throw Exception('فشل جلب البيانات من السيرفر');
    }
  }
}
