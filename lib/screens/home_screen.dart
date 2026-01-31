import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'live_tv_screen.dart'; // استيراد صفحة البث المباشر

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

            // 2. أزرار التنقل (محدثة بالروابط)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavButton("البث المباشر", Icons.live_tv, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LiveTvScreen()));
                  }),
                  _buildNavButton("السينما", Icons.movie, () {
                    // يمكنك إضافة صفحة أفلام مخصصة هنا لاحقاً
                  }),
                  _buildNavButton("المسلسلات", Icons.tv, () {
                    // يمكنك إضافة صفحة مسلسلات مخصصة هنا لاحقاً
                  }),
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

  // تطوير الزر ليقبل الوظيفة (Function) عند الضغط
  Widget _buildNavButton(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          children: [
            CircleAvatar(radius: 25, backgroundColor: Colors.yellow, child: Icon(icon, color: Colors.black)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12)),
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
          padding: const EdgeInsets.all(10.0),
          child: Text(sectionTitle, style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 220,
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
