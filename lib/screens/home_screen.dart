import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'live_tv_screen.dart';
import 'movie_details_screen.dart'; // استيراد ملف التفاصيل الجديد

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("SHOF TV", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.yellow),
            onPressed: () {
              // محرك البحث
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. السلايدر المتحرك (الربط تم هنا أيضاً)
            FutureBuilder<List<dynamic>>(
              future: _apiService.getTrendingMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 230, color: Colors.grey[900], child: const Center(child: CircularProgressIndicator(color: Colors.yellow)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(height: 230, color: Colors.grey[900], child: const Icon(Icons.movie, color: Colors.yellow, size: 50));
                }

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 230.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    autoPlayInterval: const Duration(seconds: 4),
                  ),
                  items: snapshot.data!.take(6).map((movieData) {
                    final movie = MovieModel.fromJson(movieData);
                    return GestureDetector(
                      onTap: () {
                        // الربط بشاشة التفاصيل عند الضغط على السلايدر
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: movie.backdropPath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (context, url) => Container(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                              ),
                            ),
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),

            // 2. أزرار التنقل السريع
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton("البث المباشر", Icons.live_tv, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LiveTvScreen()));
                  }),
                  _buildNavButton("السينما", Icons.movie, () {}),
                  _buildNavButton("المسلسلات", Icons.tv, () {}),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. قوائم المحتوى (الربط تم هنا أيضاً)
            _buildMovieSection("الأفلام المضافة حديثاً", "movie"),
            _buildMovieSection("أحدث المسلسلات", "tv"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.yellow,
              child: Icon(icon, color: Colors.black, size: 30),
            ),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieSection(String sectionTitle, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionTitle, style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
              const Text("عرض الكل", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<dynamic>>(
            future: _apiService.fetchShofContent(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.yellow));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("لا توجد بيانات حالياً", style: TextStyle(color: Colors.white)));
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = MovieModel.fromJson(snapshot.data![index]);
                  return GestureDetector(
                    onTap: () {
                      // الربط بشاشة التفاصيل عند الضغط على أي ملصق فيلم
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
                      );
                    },
                    child: Container(
                      width: 135,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath,
                              height: 170,
                              width: 135,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[900]),
                              errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
