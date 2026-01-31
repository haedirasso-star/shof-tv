import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'player_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true, // يبقى شريط العنوان ظاهراً عند التمرير
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                movie.posterPath, 
                fit: BoxFit.cover,
                // معالجة حالة فشل تحميل الصورة لضمان عدم توقف التطبيق
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.movie, color: Colors.yellow, size: 50)),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title, 
                    style: const TextStyle(color: Colors.yellow, fontSize: 26, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 15),
                  const Text("القصة:", style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview, 
                    style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)
                  ),
                  const SizedBox(height: 30),
                  
                  // زر المشاهدة الاحترافي
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // الربط السحري: نستخدم سيرفر vidsrc الذي يدعم الترجمة العربية تلقائياً
                        // الرابط يتغير تلقائياً حسب ID الفيلم
                        String streamUrl = "https://vidsrc.to/embed/movie/${movie.id}";
                        
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(videoUrl: streamUrl, title: movie.title)
                          )
                        );
                      },
                      icon: const Icon(Icons.play_circle_fill, color: Colors.black, size: 30),
                      label: const Text(
                        "مشاهدة الآن", 
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ),
                  const SizedBox(height: 50), // مساحة إضافية في الأسفل
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
