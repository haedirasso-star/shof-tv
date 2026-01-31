import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import '../delegates/movie_search.dart'; // البحث المطور
import 'package:cached_network_image/cached_network_image.dart';
import 'live_tv_screen.dart';
import 'movie_details_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  // دالة الدعم الفني المطورة (تفتح تليجرام O_2828)
  Future<void> _launchSupport() async {
    final Uri telegramUrl = Uri.parse("https://t.me/O_2828");
    if (await canLaunchUrl(telegramUrl)) {
      await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
    }
  }

  // استخدام البحث الاحترافي الجديد
  void _openAdvancedSearch() {
    showSearch(
      context: context,
      delegate: MovieSearchDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("SHOF TV", 
          style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.telegram, color: Colors.yellow, size: 28),
            onPressed: _launchSupport,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.yellow, size: 28),
            onPressed: _openAdvancedSearch, // تم ربط البحث المطور
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // 1. السلايدر المتحرك بتصميم احترافي
            FutureBuilder<List<dynamic>>(
              future: _apiService.getTrendingMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(height: 250, child: const Center(child: CircularProgressIndicator(color: Colors.yellow)));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(height: 200, child: Icon(Icons.movie_filter, color: Colors.yellow, size: 50));
                }

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 250.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.85,
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: snapshot.data!.take(8).map((movieData) {
                    final movie = MovieModel.fromJson(movieData);
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie))),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.yellow.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CachedNetworkImage(
                                imageUrl: movie.backdropPath,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(color: Colors.black26),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    movie.title,
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 25),

            // 2. أزرار التنقل السريع بتصميم Modern
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton("القنوات", Icons.live_tv_rounded, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveTvScreen()));
                  }),
                  _buildNavButton("السينما", Icons.local_movies_rounded, _openAdvancedSearch),
                  _buildNavButton("المسلسلات", Icons.tv_rounded, _openAdvancedSearch),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 3. أقسام المحتوى المتجددة
            _buildMovieSection("الأكثر مشاهدة 🔥", "movie"),
            const SizedBox(height: 10),
            _buildMovieSection("أحدث المسلسلات 📺", "tv"),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, IconData icon, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.yellow.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: Colors.yellow, size: 32),
          ),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildMovieSection(String sectionTitle, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionTitle, style: const TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold)),
              const Icon(Icons.arrow_forward_ios, color: Colors.yellow, size: 16),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: FutureBuilder<List<dynamic>>(
            future: _apiService.fetchShofContent(type),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.yellow));
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = MovieModel.fromJson(snapshot.data![index]);
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie))),
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath,
                              height: 180,
                              width: 130,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: Colors.grey[900]),
                            ),
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
