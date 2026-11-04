import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab9/models/movie_library.dart';
import 'package:lab9/screens/asset_screen.dart';
import 'package:lab9/screens/storage_screen.dart';
import 'package:lab9/services/asset_service.dart';
import 'package:lab9/services/json_storage_service.dart';

// File persistence is tested separately with real temporary files.
// This store keeps widget tests independent of the operating system event loop.
class WidgetStorage extends JsonStorageService {
  MovieLibrary data;
  bool failWrites = false;

  WidgetStorage(this.data) : super(fileName: 'test.json');

  @override
  Future<MovieLibrary> load() async => data;

  @override
  Future<void> save(MovieLibrary library) async {
    if (failWrites) {
      throw const StorageException('Could not save movies. Please try again.');
    }
    data = MovieLibrary(
      movies: List.of(library.movies),
      nextId: library.nextId,
    );
  }
}

Future<void> fillMovie(WidgetTester tester, String title) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), title);
  await tester.enterText(fields.at(1), '2025');
  await tester.enterText(fields.at(2), 'Action, Adventure, Sci-Fi');
  await tester.enterText(fields.at(3), '7.0');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late WidgetStorage storage;
  setUp(() async {
    storage = WidgetStorage(
      MovieLibrary(movies: await loadAssetMovies(), nextId: 7),
    );
  });

  testWidgets('Assets display movie titles and other JSON fields', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AssetScreen())),
      );
      await loadAssetMovies();
    });
    await tester.pumpAndSettle();
    expect(find.text('Zootopia 2'), findsOneWidget);
    expect(find.text('2025 - Rating: 7.3/10'), findsOneWidget);
  });

  testWidgets('Manual Save commits data and a reopened screen loads it', (
    tester,
  ) async {
    final manual = WidgetStorage(const MovieLibrary(movies: [], nextId: 1));
    await tester.pumpWidget(
      MaterialApp(home: StorageScreen(storage: manual, autoSave: false)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add movie'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a movie title.'), findsOneWidget);
    await fillMovie(tester, 'Superman');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('Superman'), findsOneWidget);
    expect(manual.data.movies, isEmpty);
    await tester.tap(find.text('Reload'));
    await tester.pumpAndSettle();
    expect(find.text('Discard unsaved changes?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Superman'), findsOneWidget);
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(manual.data.movies.single.title, 'Superman');
    await tester.pumpWidget(
      MaterialApp(
        home: StorageScreen(key: UniqueKey(), storage: manual, autoSave: false),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Superman'), findsOneWidget);
    expect(find.text('Loaded 1 movie from device storage'), findsOneWidget);
  });

  testWidgets('CRUD searches, edits and confirms deletion before auto-save', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: StorageScreen(storage: storage, autoSave: true)),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'SUPERMAN');
    await tester.pumpAndSettle();
    expect(find.text('1 of 6 movies'), findsOneWidget);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Superman edited');
    await tester.tap(find.widgetWithText(FilledButton, 'Update'));
    await tester.pumpAndSettle();
    expect(
      storage.data.movies.firstWhere((movie) => movie.id == 4).title,
      'Superman edited',
    );
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(storage.data.movies.length, 6);
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(storage.data.movies.length, 5);
    expect(find.text('No movies match your search.'), findsOneWidget);
    expect(storage.data.nextId, 7);
  });

  testWidgets('Failed auto-save keeps the existing list intact', (
    tester,
  ) async {
    storage.failWrites = true;
    await tester.pumpWidget(
      MaterialApp(home: StorageScreen(storage: storage, autoSave: true)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add movie'));
    await tester.pumpAndSettle();
    await fillMovie(tester, 'New movie');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not save movies. Please try again.'),
      findsOneWidget,
    );
    expect(storage.data.movies.length, 6);
    expect(storage.data.nextId, 7);
    expect(find.text('New movie'), findsNothing);
  });

  testWidgets('Switching tabs keeps manual unsaved changes', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Save/Load'),
                  Tab(text: 'Other'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                StorageScreen(storage: storage, autoSave: false),
                const Text('Other tab'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add movie'));
    await tester.pumpAndSettle();
    await fillMovie(tester, 'Another movie');
    await tester.tap(find.widgetWithText(FilledButton, 'Add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Other'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save/Load'));
    await tester.pumpAndSettle();
    expect(
      find.text('Unsaved changes - tap Save to keep your movies'),
      findsOneWidget,
    );
  });
}
