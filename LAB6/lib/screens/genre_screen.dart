import 'package:flutter/material.dart';

import '../data/genre_data.dart';
import '../data/movie_data.dart';

enum MovieSort {
  aToZ('A-Z'),
  zToA('Z-A'),
  year('Year'),
  rating('Rating');

  const MovieSort(this.label);

  final String label;
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _selectedGenres = [];
  MovieSort _selectedSort = MovieSort.aToZ;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = MovieSort.aToZ;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Search by name
    final keyword = _searchQuery.trim().toLowerCase();
    final displayedMovies = allMovies.where((movie) {
      final matchKeyword = movie.title.toLowerCase().contains(keyword);
      final matchGenre =
          _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));
      return matchKeyword && matchGenre;
    }).toList();

    // Sort by criteria
    displayedMovies.sort((a, b) {
      switch (_selectedSort) {
        case MovieSort.aToZ:
          return a.title.compareTo(b.title);
        case MovieSort.zToA:
          return b.title.compareTo(a.title);
        case MovieSort.year:
          return b.year.compareTo(a.year);
        case MovieSort.rating:
          return b.rating.compareTo(a.rating);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Lab 6 – Building a Responsive Movie Genre Browsing Screen')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 800;
            double textScale = MediaQuery.textScalerOf(context).scale(1);
            if (textScale < 1) {
              textScale = 1;
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Find a Movie',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Search button.
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search movies',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Genre selected
                Text('Genres (${_selectedGenres.length} selected)'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: genreData.map((genre) {
                    return FilterChip(
                      label: Text(genre),
                      selected: _selectedGenres.contains(genre),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedGenres.add(genre);
                          } else {
                            _selectedGenres.remove(genre);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // sort and clear filter
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${displayedMovies.length} movies found'),
                    const Text('Sort by:'),
                    DropdownButton<MovieSort>(
                      value: _selectedSort,
                      items: MovieSort.values.map((sort) {
                        return DropdownMenuItem(
                          value: sort,
                          child: Text(sort.label),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSort = value;
                          });
                        }
                      },
                    ),
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear filters'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                if (displayedMovies.isEmpty)
                  const Center(child: Text('No movies found.'))
                else if (isWide)
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    mainAxisExtent: 220 * textScale,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: displayedMovies.map((movie) {
                      return _buildMovieCard(movie);
                    }).toList(),
                  )
                else
                  ...displayedMovies.map((movie) => _buildMovieCard(movie)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Year: ${movie.year}'),
                  const SizedBox(height: 8),
                  Text(
                    movie.genres.join(' / '),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text('Rating: ${movie.rating}/10'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
