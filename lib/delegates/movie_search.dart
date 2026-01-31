import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/player_screen.dart';

class MovieSearchDelegate extends SearchDelegate {
  final ApiService _apiService = ApiService();

  // تغيير لغة شريط البحث
  @override
  String get searchFieldLabel => "ابحث عن أفلام أو قنوات...";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.yellow),
        onPressed: () => query = "",
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text("ابدأ بكتابة اسم الفيلم أو القناة", style: TextStyle(color: Colors.white54)),
      );
    }
    return _buildSearchResults();
  }

  // الدالة الأساسية لجلب وعرض النتائج
  Widget _buildSearchResults() {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.yellow));
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد نتائج مطابقة", style: TextStyle(color: Colors.white)));
        }

        final results = snapshot.data!;
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];
            final String title = item['title'] ?? item['name'] ?? "بدون عنوان";
            final String posterPath = item['poster_path'] ?? "";
            final String overview = item['overview'] ?? "لا يوجد وصف متاح";

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: posterPath.isNotEmpty
                    ? Image.network(
                        "https://image.tmdb.org/t/p/w92$posterPath",
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(width: 60, color: Colors.grey, child: const Icon(Icons.movie)),
                      )
                    : Container(width: 60, color: Colors.grey, child: const Icon(Icons.movie)),
              ),
              title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(overview, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              onTap: () {
                // الانتقال للمشغل عند الضغط
                // ملاحظة: روابط TMDB تحتاج لمشغل Vidsrc الذي برمجناه سابقاً
                String videoUrl = "https://vidsrc.to/embed/movie/${item['id']}";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerScreen(videoUrl: videoUrl, title: title)),
                );
              },
            );
          },
        );
      },
    );
  }

  // تخصيص شكل واجهة البحث (Dark Mode)
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0A0A)),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white38),
        border: InputBorder.none,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
