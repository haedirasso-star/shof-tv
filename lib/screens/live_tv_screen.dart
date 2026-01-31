import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'player_screen.dart'; 

class LiveTvScreen extends StatelessWidget {
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
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: FutureBuilder<List<dynamic>>(
        // جلب القنوات من الخدمة
        future: _apiService.fetchLiveChannels(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.yellow));
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.tv_off, color: Colors.grey, size: 50),
                  SizedBox(height: 10),
                  Text("لا توجد قنوات متاحة حالياً", 
                    style: TextStyle(color: Colors.white70)),
                ],
              ),
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
                    if (channel['url'] != null && channel['url'].toString().isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            videoUrl: channel['url'], 
                            title: channel['name'],
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("رابط القناة غير متوفر حالياً"))
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
