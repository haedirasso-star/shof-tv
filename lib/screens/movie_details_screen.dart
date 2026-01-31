import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import 'player_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie; // تأكد أنها MovieModel وليست dynamic

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(movie.posterPath, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: const TextStyle(color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(movie.overview, style: const TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                    onPressed: () {
                      // هنا نرسل الرابط للمشغل الذكي
                      Navigator.push(context, MaterialPageRoute(builder: (context) => 
                        PlayerScreen(videoUrl: "رابط_السيرفر_هنا", title: movie.title)));
                    },
                    child: const Text("مشاهدة الآن", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
