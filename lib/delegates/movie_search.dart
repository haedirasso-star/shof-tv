import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/player_screen.dart';

class MovieSearchDelegate extends SearchDelegate {
  final ApiService _apiService = ApiService();

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

  Widget _buildSearchResults() {
    return Container(
      color: Colors.black, // لضمان خلفية سوداء تحت قائمة النتائج
      child: FutureBuilder<List<dynamic>>(
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
                          errorBuilder: (c, e, s) => Container(width: 60, color: Colors.grey[900], child: const Icon(Icons.movie, color: Colors.white24)),
                        )
                      : Container(width: 60, color: Colors.grey[900], child: const Icon(Icons.movie, color: Colors.white24)),
                ),
                title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(overview, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                onTap: () {
                  // استخدام vidsrc للمشاهدة
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
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      // تم استبدال backgroundColor بـ colorScheme لنجاح الـ Build
      colorScheme: theme.colorScheme.copyWith(
        surface: const Color(0xFF0A0A0A), // خلفية شريط البحث
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black, // خلفية صفحة البحث
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0A0A0A),
        elevation: 0,
      ),
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
