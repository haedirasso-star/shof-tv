Future<List<dynamic>> fetchLiveChannels() async {
  // تم تحديث الرابط ليشير إلى حسابك ومستودع تطبيقك مباشرة
  const String githubUrl = "https://raw.githubusercontent.com/haedirasso/shof-tv/main/channels.json";
  
  try {
    // إرسال الطلب لجلب ملف القنوات
    final response = await http.get(Uri.parse(githubUrl)).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      // تحويل النص القادم من GitHub إلى قائمة (List) يمكن للتطبيق فهمها
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      // في حال كان هناك خطأ في السيرفر (مثل 404 أو 500)
      debugPrint("خطأ في جلب القنوات: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    // في حال انقطاع الإنترنت أو أي خطأ تقني آخر
    debugPrint("حدث خطأ أثناء الاتصال بـ GitHub: $e");
    return [];
  }
}
