import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_player_screen.dart'; // سننشئ هذا الملف لاحقاً للمشغل

class LiveTvScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("البث المباشر")),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchLiveChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("لا توجد قنوات حالياً", style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var channel = snapshot.data![index];
              return ListTile(
                leading: const Icon(Icons.live_tv, color: Colors.yellow),
                title: Text(channel['name'], style: const TextStyle(color: Colors.white)),
                onTap: () {
                  // هنا نفتح مشغل الفيديو ونمرر رابط القناة
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(url: channel['url'], name: channel['name']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
