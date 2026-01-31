// جزء من كود البناء (Build Method) داخل GridView
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3, // 3 قنوات في الصف
    childAspectRatio: 0.8,
  ),
  itemCount: channels.length,
  itemBuilder: (context, index) {
    var channel = channels[index];
    return GestureDetector(
      onTap: () {
        // بناء رابط البث المباشر فوراً
        String streamUrl = "${config['host']}/live/${config['user']}/${config['pass']}/${channel['stream_id']}.m3u8";
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => PlayerScreen(videoUrl: streamUrl, title: channel['name'])
        ));
      },
      child: Column(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Image.network(
                channel['stream_icon'],
                errorBuilder: (context, error, stackTrace) => Icon(Icons.tv, size: 50, color: Colors.yellow),
              ),
            ),
          ),
          Text(channel['name'], style: TextStyle(color: Colors.white, fontSize: 10), maxLines: 1),
        ],
      ),
    );
  },
)
