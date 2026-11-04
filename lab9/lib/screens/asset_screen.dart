import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/asset_service.dart';
import '../services/json_storage_service.dart';
import '../widgets/movie_card.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Movie>> _moviesFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _moviesFuture = loadAssetMovies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Movie>>(
      future: _moviesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load the movie JSON.'),
                TextButton(
                  onPressed: () =>
                      setState(() => _moviesFuture = loadAssetMovies()),
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }
        final movies = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: movies.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Movies from JSON',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fileStorageSupported
                          ? 'Source: assets/data/movies.json'
                          : 'Source: embedded JSON (DartPad demo)',
                    ),
                    const SizedBox(height: 4),
                    Text('${movies.length} movies - same dataset as Lab 6'),
                  ],
                ),
              );
            }
            return MovieCard(movie: movies[index - 1]);
          },
        );
      },
    );
  }
}
