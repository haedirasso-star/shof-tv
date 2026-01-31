import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'video_player_screen.dart'; // تأكد أن هذا الملف موجود في مجلد screens

class LiveTvScreen extends StatelessWidget {
  // تعريف الـ ApiService مرة واحدة
  final ApiService _apiService = ApiService();

  LiveTvScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("البث المباشر - Shof TV", 
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow), // تلوين زر الرجوع
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchLiveChannels(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("لا توجد قنوات متاحة حالياً", 
                style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final channel = snapshot.data![index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.live_tv, color: Colors.yellow, size: 30),
                  ),
                  title: Text(
                    channel['name'] ?? "قناة غير معروفة", 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                  ),
                  subtitle: const Text("اضغط لبدء البث المباشر", 
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: const Icon(Icons.play_circle_outline, color: Colors.yellow),
                  onTap: () {
                    // التأكد من أن القيم موجودة قبل الانتقال
                    if (channel['url'] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            url: channel['url'],
                            name: channel['name'],
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("رابط القناة غير متوفر"))
                      );
                    }
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
