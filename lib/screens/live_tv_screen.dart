import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_player_screen.dart';

class LiveTvScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("البث المباشر - Shof TV", style: TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchLiveChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("لا توجد قنوات متاحة حالياً", style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var channel = snapshot.data![index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill, color: Colors.yellow, size: 40),
                  title: Text(channel['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text("بث مباشر بجودة عالية", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 15),
                  onTap: () {
                    // الانتقال لمشغل الفيديو الذي أنشأناه
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          url: channel['url'],
                          name: channel['name'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
