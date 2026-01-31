class XtreamService {
  // جلب التصنيفات (Live Categories)
  static String getCategories(config) => 
    "${config['host']}/player_api.php?username=${config['user']}&password=${config['pass']}&action=get_live_categories";

  // جلب القنوات داخل تصنيف معين (Live Streams)
  static String getChannels(config, catId) => 
    "${config['host']}/player_api.php?username=${config['user']}&password=${config['pass']}&action=get_live_streams&category_id=$catId";

  // بناء رابط البث المباشر (Playable URL) كما وجدته في بحثك
  static String buildStreamUrl(config, streamId) {
    // التنسيق الأكثر استقراراً للمشغلات في فلاتر هو m3u8 أو ts
    return "${config['host']}/live/${config['user']}/${config['pass']}/$streamId.m3u8";
  }
}
