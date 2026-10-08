import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/movie.dart';
import '../state/movieState.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
    required this.library,
  });

  final Movie movie;
  final MovieLibrary library;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),

      body: ListView(
        children: [
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  left: 20,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: movie.genres.map((genre) {
                    return Chip(label: Text(genre));
                  }).toList(),
                ),

                const SizedBox(height: 12),
                Text('     ${movie.overview}'),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListenableBuilder(
                      listenable: library,
                      builder: (context, child) {
                        return InkWell(
                          onTap: () {
                            library.toggleFavorite(movie.id);
                          },
                          child: Column(
                            children: [
                              library.isFavorite(movie.id)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border),
                              const Text('Favorite'),
                            ],
                          ),
                        );
                      },
                    ),
                    Column(
                      children: [const Icon(Icons.star), const Text('Rate')],
                    ),
                    Column(
                      children: [const Icon(Icons.share), const Text('Share')],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Trailers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...movie.trailers.map(
                  (trailer) => ListTile(
                    leading: const Icon(Icons.play_circle),
                    title: Text(trailer.title),
                    subtitle: Text(trailer.duration),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
