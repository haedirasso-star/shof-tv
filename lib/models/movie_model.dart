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
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'عنوان غير معروف',
      posterPath: 'https://image.tmdb.org/t/p/w500${json['poster_path']}',
      backdropPath: 'https://image.tmdb.org/t/p/w780${json['backdrop_path']}',
      overview: json['overview'] ?? '',
    );
  }
}
