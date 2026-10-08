class Trailer {
  const Trailer({
    required this.title,
    required this.duration,
    required this.description,
  });

  final String title;
  final String duration;
  final String description;
}

class Movie {
  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    required this.year,
    required this.runtime,
  });

  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  final int year;
  final String runtime;
}
