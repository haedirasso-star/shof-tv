class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String backdropPath;
  final String overview;

  MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.overview,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? "بدون عنوان",
      posterPath: json['poster_path'] != null 
          ? "https://image.tmdb.org/t/p/w500${json['poster_path']}" 
          : "https://via.placeholder.com/500x750?text=No+Image",
      backdropPath: json['backdrop_path'] != null 
          ? "https://image.tmdb.org/t/p/w780${json['backdrop_path']}" 
          : "",
      overview: json['overview'] ?? "لا يوجد وصف متوفر.",
    );
  }
}
