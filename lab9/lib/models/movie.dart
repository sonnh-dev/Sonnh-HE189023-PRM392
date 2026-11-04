class Movie {
  final int id;
  final String title;
  final int year;
  final List<String> genres;
  final double rating;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genres = json['genres'];
    final rating = json['rating'];
    if (json['id'] is! int ||
        (json['id'] as int) < 1 ||
        json['title'] is! String ||
        (json['title'] as String).trim().isEmpty ||
        json['year'] is! int ||
        (json['year'] as int) < 1888 ||
        genres is! List ||
        genres.isEmpty ||
        genres.any((genre) => genre is! String || genre.trim().isEmpty) ||
        rating is! num ||
        !rating.isFinite ||
        rating < 0 ||
        rating > 10) {
      throw const FormatException('Invalid movie data.');
    }

    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      year: json['year'] as int,
      genres: List<String>.from(genres),
      rating: rating.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'year': year,
    'genres': genres,
    'rating': rating,
  };
}
