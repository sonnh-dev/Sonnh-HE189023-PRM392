import 'package:flutter/material.dart';

import '../model/movie.dart';
import '../model/movieData.dart';
import '../state/movieState.dart';
import 'movieDetail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieLibrary _library = MovieLibrary();

  bool _favoritesMovie = false;

  @override
  void dispose() {
    _library.dispose();
    super.dispose();
  }

  void _openMovie(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MovieDetailScreen(movie: movie, library: _library),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedMovies = _favoritesMovie
        ? movieData.where((movie) => _library.isFavorite(movie.id)).toList()
        : movieData;

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Library')),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _favoritesMovie = false;
                    });
                  },
                  child: const Text('All movies'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _favoritesMovie = true;
                    });
                  },
                  child: Text('Favorites (${_library.favoriteCount})'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (displayedMovies.isEmpty)
              const Center(child: Text('No favorite movies.'))
            else
              ...displayedMovies.map((movie) => _buildMovieCard(movie)),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _openMovie(movie),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 120,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${movie.year} - ${movie.runtime} - ${movie.rating}'),
                        const Icon(
                          Icons.star,
                          color: Colors.amberAccent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(movie.genres.join(' / ')),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
