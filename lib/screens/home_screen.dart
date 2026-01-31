import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("SHOF TV", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. شريط الإعلانات والأفلام الحصرية (Slider)
            Container(
              height: 200,
              width: double.infinity,
              child: Placeholder(), // سنضع هنا لاحقاً كود السلايدر المتحرك
            ),

            // 2. أزرار التنقل (بث مباشر، سينما، مسلسلات)
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

            // 3. قائمة الأفلام العربية والتركية
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
        SizedBox(height: 5),
        Text(title, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildMovieSection(String sectionTitle, String type) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(sectionTitle, style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 200,
          child: FutureBuilder<List<dynamic>>(
            future: _apiService.fetchShofContent(type),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
              if (!snapshot.hasData) return Center(child: Text("لا توجد بيانات", style: TextStyle(color: Colors.white)));
              
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var movie = Movie.fromJson(snapshot.data![index]);
                  return Container(
                    width: 130,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath,
                            height: 160,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(color: Colors.grey[900]),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                        Text(movie.title, maxLines: 1, style: TextStyle(color: Colors.white, fontSize: 10), textAlign: TextAlign.center),
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
