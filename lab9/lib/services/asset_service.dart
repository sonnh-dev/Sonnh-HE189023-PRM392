import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/movie.dart';

Future<List<Movie>> loadAssetMovies() async {
  // Lab 9.1: read the registered JSON asset and convert it into model objects.
  final source = await rootBundle.loadString('assets/data/movies.json');
  final data = jsonDecode(source);
  if (data is! List) {
    throw const FormatException('Expected a list of movies.');
  }
  return data.map((item) {
    if (item is! Map<String, dynamic>) {
      throw const FormatException('Invalid movie data.');
    }
    return Movie.fromJson(item);
  }).toList();
}
