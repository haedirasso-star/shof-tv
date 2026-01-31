import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // رأس الصفحة مع صورة الخلفية الكبيرة
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: movie.backdropPath,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.grey[900]),
              ),
            ),
          ),
          // محتوى التفاصيل
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(color: Colors.yellow, fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        SizedBox(width: 5),
                        Text("8.5 / 10", style: TextStyle(color: Colors.white, fontSize: 16)), // تقييم افتراضي
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "القصة:",
                      style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      movie.overview,
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    // زر المشاهدة (يمكن ربطه لاحقاً بسيرفرات المشاهدة)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("سيرفرات المشاهدة ستتوفر قريباً!")),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("مشاهدة الآن", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
