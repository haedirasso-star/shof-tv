Future<List<dynamic>> fetchLiveChannels() async {
  // استبدل هذا الرابط برابط ملف الـ Raw الخاص بك في GitHub
  const String githubUrl = "https://raw.githubusercontent.com/USER_NAME/REPO_NAME/main/channels.json";
  
  try {
    final response = await http.get(Uri.parse(githubUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return [];
  } catch (e) {
    return [];
  }
}
