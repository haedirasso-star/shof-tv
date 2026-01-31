import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // أضفنا الكي والمحرّك الحديث

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. شريط الإعلانات (Slider)
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[900],
              child: const Center(child: Icon(Icons.movie_filter, color: Colors.yellow, size: 50)), 
            ),

            // 2. أزرار التنقل
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton("البث المباشر", Icons.live_tv),
                  _buildNavButton("السينما", Icons.movie),
                  _buildNavButton("المسلسلات", Icons.tv),
                ],
              ),
            ),

            // 3. قائمة الأفلام والمسلسلات
            _buildMovieSection("الأفلام المضافة حديثاً", "movie"),
            _buildMovieSection("أحدث المسلسلات", "tv"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(radius: 25, backgroundColor: Colors.yellow, child: Icon(icon, color: Colors.black)),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildMovieSection(String sectionTitle, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(sectionTitle, style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 220, // زدنا الارتفاع قليلاً لراحة التصميم
          child: FutureBuilder<List<dynamic>>(
            future: _apiService.fetchShofContent(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.yellow));
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("لا توجد بيانات حالياً", style: TextStyle(color: Colors.white)));
              }
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  // التصحيح: استخدام MovieModel بدلاً من Movie
                  final movie = MovieModel.fromJson(snapshot.data![index]);
                  
                  return Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath,
                            height: 160,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[900]),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
