import 'movie.dart';

const movieData = <Movie>[
  Movie(
    id: '1',
    title: 'Cosmic Princess Kaguya!',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BNjY1OTAwNmUtYjY3Ny00MTFjLTk5MDctZmNiNTYwZTAyOWE1XkEyXkFqcGc@._V1_QL75_UX380_CR0,0,380,562_.jpg',
    overview:
        '17-year-old Iroha leads a busy life juggling school and part-time work.'
        'Enter Kaguya, a mysterious girl from the moon who crash-lands into her life.',
    genres: ['Animation', 'Music', 'Fantasy'],
    rating: 7.1,
    year: 2026,
    runtime: '2h 23m',
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '1:15',
        description:
            '17-year-old Iroha leads a busy life juggling school and part-time work. '
            'Enter Kaguya, a mysterious girl from the moon who crash-lands into her life!.',
      ),
    ],
  ),
  Movie(
    id: '2',
    title: 'Avengers: Endgame',
    posterUrl: 'https://m.media-amazon.com/images/I/81ExhpBEbHL._AC_UF1000,1000_QL80_.jpg',
    overview:
        'After the devastating events of Avengers: Infinity War, the remaining Avengers '
        'must find a way to reverse the damage caused by Thanos and restore the universe.',
    genres: ['Action', 'Adventure', 'Drama'],
    rating: 8.4,
    year: 2019,
    runtime: '3h 1m',
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:26',
        description: 'The Avengers return for one final battle against Thanos.',
      ),
    ],
  ),

  Movie(
    id: '3',
    title: 'Titanic',
    posterUrl: 'https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_FMjpg_UY3000_.jpg',
    overview:
        'A young woman from an upper-class family falls in love with a poor artist '
        'aboard the luxurious but ill-fated RMS Titanic.',
    genres: ['Drama', 'Romance'],
    rating: 7.9,
    year: 1997,
    runtime: '3h 14m',
    trailers: [
      Trailer(
        title: 'Official Trailer',
        duration: '2:18',
        description: 'Jack and Rose fall in love aboard the Titanic as the ship begins its tragic journey.',
      ),
    ],
  ),
];
