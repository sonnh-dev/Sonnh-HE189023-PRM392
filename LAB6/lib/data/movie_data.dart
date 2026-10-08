class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });

  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;
}

const allMovies = <Movie>[
  Movie(
    title: 'Zootopia 2',
    year: 2025,
    genres: ['Adventure', 'Animation', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/zootopia-2/300/450',
    rating: 7.3,
  ),

  Movie(
    title: 'KPop Demon Hunters',
    year: 2025,
    genres: ['Animation', 'Action', 'Adventure', 'Comedy'],
    posterUrl: 'https://picsum.photos/seed/kpop-demon-hunters/300/450',
    rating: 7.4,
  ),

  Movie(
    title: 'Elio',
    year: 2025,
    genres: ['Animation', 'Action', 'Adventure', 'Comedy', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/elio-2025/300/450',
    rating: 6.6,
  ),

  Movie(
    title: 'Superman',
    year: 2025,
    genres: ['Action', 'Adventure', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/seed/superman-2025/300/450',
    rating: 7.0,
  ),

  Movie(
    title: 'F1: The Movie',
    year: 2025,
    genres: ['Action', 'Drama', 'Sport'],
    posterUrl: 'https://picsum.photos/seed/f1-the-movie/300/450',
    rating: 7.6,
  ),

  Movie(
    title: 'Weapons',
    year: 2025,
    genres: ['Drama', 'Horror', 'Mystery'],
    posterUrl: 'https://picsum.photos/seed/weapons-2025/300/450',
    rating: 7.4,
  ),
];
