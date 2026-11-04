import 'movie.dart';

class MovieLibrary {
  final List<Movie> movies;
  final int nextId;

  const MovieLibrary({required this.movies, required this.nextId});

  factory MovieLibrary.fromJson(Map<String, dynamic> json) {
    final items = json['movies'];
    final nextId = json['nextId'];
    if (items is! List || nextId is! int || nextId < 1) {
      throw const FormatException('Invalid library data.');
    }
    final movies = items.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Invalid movie data.');
      }
      return Movie.fromJson(item);
    }).toList();
    final ids = movies.map((movie) => movie.id).toSet();
    if (ids.length != movies.length || ids.any((id) => id >= nextId)) {
      throw const FormatException('Invalid movie IDs.');
    }
    return MovieLibrary(movies: movies, nextId: nextId);
  }

  Map<String, dynamic> toJson() => {
    'nextId': nextId,
    'movies': movies.map((movie) => movie.toJson()).toList(),
  };
}
