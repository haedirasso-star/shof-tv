import 'package:flutter/material.dart';
import 'player_screen.dart'; // تأكد أن هذا هو اسم ملف المشغل عندك

class MovieDetailsScreen extends StatelessWidget {
  final dynamic movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final String title = movie['title'] ?? movie['name'] ?? 'بدون عنوان';
    final String backdropPath = movie['backdrop_path'] ?? '';
    final String posterPath = movie['poster_path'] ?? '';
    final String overview = movie['overview'] ?? 'لا يوجد وصف متاح لهذا العمل.';
    final String rating = movie['vote_average']?.toString() ?? '0.0';

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: backdropPath.isNotEmpty
                  ? Image.network(
                      "https://image.tmdb.org/t/p/original$backdropPath",
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey[900]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 5),
                      Text(rating, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "القصة:",
                    style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    overview,
                    style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                      onPressed: () {
                        // الانتقال لمشغل الـ Embed الذي أنشأناه
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              videoUrl: "https://vidsrc.me/embed/${movie['title'] != null ? 'movie' : 'tv'}?tmdb=${movie['id']}",
                              title: title,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow, color: Colors.black),
                      label: const Text("مشاهدة الآن", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
