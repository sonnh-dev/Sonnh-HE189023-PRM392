import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/movie.dart';
import '../models/movie_library.dart';
import 'asset_service.dart';

const fileStorageSupported = true;

class StorageException implements Exception {
  final String message;

  const StorageException(this.message);

  @override
  String toString() => message;
}

class JsonStorageService {
  final String fileName;
  final bool seedFromAssets;
  final Future<Directory> Function() _directoryProvider;

  JsonStorageService({
    required this.fileName,
    this.seedFromAssets = false,
    Future<Directory> Function()? directoryProvider,
  }) : _directoryProvider =
           directoryProvider ?? getApplicationDocumentsDirectory;

  bool get isPersistent => true;

  Future<File> get _file async {
    final directory = await _directoryProvider();
    await directory.create(recursive: true);
    return File('${directory.path}${Platform.pathSeparator}$fileName');
  }

  Future<MovieLibrary> load() async {
    try {
      final file = await _file;
      if (!await file.exists()) {
        final movies = seedFromAssets ? await loadAssetMovies() : <Movie>[];
        final nextId = movies.fold(
          1,
          (next, movie) => movie.id >= next ? movie.id + 1 : next,
        );
        final library = MovieLibrary(movies: movies, nextId: nextId);
        await save(library);
        return library;
      }

      final data = jsonDecode(await file.readAsString());
      if (data is! Map<String, dynamic>) {
        throw const FormatException('Invalid library data.');
      }
      return MovieLibrary.fromJson(data);
    } on FormatException {
      // Keep an invalid file intact instead of silently replacing user data.
      throw const StorageException(
        'The saved JSON is invalid. Your file has been kept unchanged.',
      );
    } on FileSystemException {
      throw const StorageException(
        'Could not read the saved movies. Please try again.',
      );
    }
  }

  Future<void> save(MovieLibrary library) async {
    try {
      final file = await _file;
      final temporaryFile = File('${file.path}.tmp');
      // Complete the new JSON before replacing the existing file.
      await temporaryFile.writeAsString(
        jsonEncode(library.toJson()),
        flush: true,
      );
      await temporaryFile.rename(file.path);
    } on FileSystemException {
      throw const StorageException('Could not save movies. Please try again.');
    }
  }
}
