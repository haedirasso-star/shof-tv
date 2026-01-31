import 'package:http/http.dart' as http;

class IptvService {
  // جلب روابط القنوات المباشرة
  Future<List<Map<String, String>>> fetchArabicChannels() async {
    const String url = "https://raw.githubusercontent.com/iptv-org/iptv/master/groups/arabic.m3u";
    final response = await http.get(Uri.parse(url));
    
    List<Map<String, String>> channels = [];
    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('#EXTINF')) {
          // استخراج الاسم والرابط
          String name = lines[i].split(',').last;
          String link = lines[i + 1];
          channels.add({"name": name, "url": link});
        }
      }
    }
    return channels;
  }
}
