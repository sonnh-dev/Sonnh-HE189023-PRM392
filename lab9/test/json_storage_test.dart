import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/models/movie.dart';
import 'package:lab9/models/movie_library.dart';
import 'package:lab9/services/asset_service.dart';
import 'package:lab9/services/json_storage_service.dart';

const sampleMovie = Movie(
  id: 1,
  title: 'Superman',
  year: 2025,
  genres: ['Action', 'Adventure', 'Sci-Fi'],
  rating: 7.0,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory directory;
  late JsonStorageService storage;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('lab9_test_');
    storage = JsonStorageService(
      fileName: 'movies.json',
      directoryProvider: () async => directory,
    );
  });
  tearDown(() async => directory.delete(recursive: true));

  test('Movie JSON round trip preserves fields and numeric ratings', () {
    final movie = Movie.fromJson(
      jsonDecode(jsonEncode(sampleMovie.toJson())) as Map<String, dynamic>,
    );
    expect(movie.toJson(), sampleMovie.toJson());
    expect(Movie.fromJson({...sampleMovie.toJson(), 'rating': 7}).rating, 7.0);
    expect(
      () => Movie.fromJson({
        ...sampleMovie.toJson(),
        'genres': [1],
      }),
      throwsFormatException,
    );
    expect(
      () => Movie.fromJson({...sampleMovie.toJson(), 'rating': 11}),
      throwsFormatException,
    );
  });

  test('Library rejects duplicate IDs and unsafe nextId', () {
    expect(
      () => MovieLibrary.fromJson({
        'nextId': 2,
        'movies': [sampleMovie.toJson(), sampleMovie.toJson()],
      }),
      throwsFormatException,
    );
    expect(
      () => MovieLibrary.fromJson({
        'nextId': 1,
        'movies': [sampleMovie.toJson()],
      }),
      throwsFormatException,
    );
  });

  test('Loads the six registered movies from the Lab 6 dataset', () async {
    final movies = await loadAssetMovies();
    expect(movies.map((movie) => movie.title), [
      'Zootopia 2',
      'KPop Demon Hunters',
      'Elio',
      'Superman',
      'F1: The Movie',
      'Weapons',
    ]);
    expect(movies.first.genres, ['Adventure', 'Animation', 'Comedy']);
  });

  test('First load creates a real empty JSON file', () async {
    final library = await storage.load();
    expect(library.movies, isEmpty);
    final saved = jsonDecode(
      await File('${directory.path}/movies.json').readAsString(),
    );
    expect(saved, {'nextId': 1, 'movies': []});
  });

  test('Database seeds from assets only when the file is missing', () async {
    final database = JsonStorageService(
      fileName: 'db.json',
      seedFromAssets: true,
      directoryProvider: () async => directory,
    );
    expect((await database.load()).movies.length, 6);
    await database.save(const MovieLibrary(movies: [], nextId: 7));
    expect((await database.load()).movies, isEmpty);
    expect((await database.load()).nextId, 7);
  });

  test('A new service instance loads the previously saved JSON', () async {
    await storage.save(const MovieLibrary(movies: [sampleMovie], nextId: 2));
    final reopened = JsonStorageService(
      fileName: 'movies.json',
      directoryProvider: () async => directory,
    );
    final library = await reopened.load();
    expect(library.movies.single.title, 'Superman');
    expect(library.nextId, 2);
    expect(await File('${directory.path}/movies.json.tmp').exists(), isFalse);
  });

  test(
    'Edit and delete overwrite JSON and preserve the next unused ID',
    () async {
      await storage.save(const MovieLibrary(movies: [sampleMovie], nextId: 2));
      final edited = Movie.fromJson({
        ...sampleMovie.toJson(),
        'title': 'Superman edited',
      });
      await storage.save(MovieLibrary(movies: [edited], nextId: 2));
      expect((await storage.load()).movies.single.title, 'Superman edited');
      await storage.save(const MovieLibrary(movies: [], nextId: 2));
      final deleted = await storage.load();
      expect(deleted.movies, isEmpty);
      expect(deleted.nextId, 2);
    },
  );

  test('Separate JSON files do not affect each other', () async {
    final other = JsonStorageService(
      fileName: 'other.json',
      directoryProvider: () async => directory,
    );
    await storage.save(const MovieLibrary(movies: [sampleMovie], nextId: 2));
    await other.save(const MovieLibrary(movies: [], nextId: 1));
    expect((await storage.load()).movies.length, 1);
    expect((await other.load()).movies, isEmpty);
  });

  for (final invalid in ['not JSON', '[]', '{"nextId":1,"movies":[{}]}']) {
    test('Corrupt file is reported and preserved: $invalid', () async {
      final file = File('${directory.path}/movies.json');
      await file.writeAsString(invalid);
      await expectLater(storage.load(), throwsA(isA<StorageException>()));
      expect(await file.readAsString(), invalid);
    });
  }
}
