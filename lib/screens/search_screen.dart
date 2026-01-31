import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/movie_model.dart';
import 'movie_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _searchResults = [];

  void _onSearchChanged(String query) async {
    if (query.length > 2) {
      final results = await _apiService.searchMovies(query);
      setState(() {
        _searchResults = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "ابحث عن فيلم أو مسلسل...",
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text("ابدأ البحث الآن...", style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final movie = MovieModel.fromJson(_searchResults[index]);
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath,
                      width: 50,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.movie),
                    ),
                  ),
                  title: Text(movie.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(movie.overview, maxLines: 1, style: const TextStyle(color: Colors.grey)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie)),
                    );
                  },
                );
              },
            ),
    );
  }
}
