// ملف جديد لإدارة جودة البث
class StreamHandler {
  static String getBestStream(String host, String user, String pass, String streamId, {String type = 'm3u8'}) {
    // هذا التنسيق هو الأفضل لتقليل التقطيع (Buffer) في الإنترنت الضعيف بالعراق
    return "$host/live/$user/$pass/$streamId.$type";
  }

  static String getVodLink(String host, String user, String pass, String vodId, {String ext = 'mp4'}) {
    return "$host/movie/$user/$pass/$vodId.$ext";
  }
}
