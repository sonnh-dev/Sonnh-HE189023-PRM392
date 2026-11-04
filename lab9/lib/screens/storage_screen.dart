import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../models/movie_library.dart';
import '../services/json_storage_service.dart';
import '../widgets/movie_card.dart';
import '../widgets/movie_form_dialog.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({
    super.key,
    required this.storage,
    required this.autoSave,
  });

  final JsonStorageService storage;
  final bool autoSave;

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  MovieLibrary _library = const MovieLibrary(movies: [], nextId: 1);
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;
  String? _errorMessage;
  String _status = '';

  bool get _busy => _isLoading || _isSaving;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _friendlyError(Object error) => error is StorageException
      ? error.message
      : 'Could not access the movie data. Please try again.';

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final library = await widget.storage.load();
      if (!mounted) return;
      setState(() {
        _library = library;
        _hasUnsavedChanges = false;
        _status = widget.storage.isPersistent
            ? 'Loaded ${library.movies.length} ${library.movies.length == 1 ? 'movie' : 'movies'} from device storage'
            : 'In-memory demo - changes last for this session only';
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _reload() async {
    if (_busy) return;
    if (_hasUnsavedChanges) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard unsaved changes?'),
          content: const Text(
            'Reloading will replace your changes with the saved JSON.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Reload'),
            ),
          ],
        ),
      );
      if (!mounted || discard != true) return;
    }
    await _load();
  }

  Future<void> _save() async {
    if (_busy || !_hasUnsavedChanges) return;
    setState(() => _isSaving = true);
    try {
      await widget.storage.save(_library);
      if (!mounted) return;
      setState(() {
        _hasUnsavedChanges = false;
        _status =
            'Saved ${_library.movies.length} movies to ${widget.storage.fileName}';
      });
      _showMessage('Movies saved successfully.');
    } catch (error) {
      if (mounted) _showMessage(_friendlyError(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _applyChange(MovieLibrary updated, String message) async {
    if (!widget.autoSave) {
      setState(() {
        _library = updated;
        _hasUnsavedChanges = true;
        _status = 'Unsaved changes - tap Save to keep your movies';
      });
      return;
    }

    setState(() => _isSaving = true);
    try {
      // Update the list only after the JSON write succeeds.
      await widget.storage.save(updated);
      if (!mounted) return;
      setState(() {
        _library = updated;
        _status = widget.storage.isPersistent
            ? 'Auto-saved to ${widget.storage.fileName}'
            : 'Updated in memory - this session only';
      });
      _showMessage(message);
    } catch (error) {
      if (mounted) _showMessage(_friendlyError(error));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _openForm([Movie? movie]) async {
    if (_busy) return;
    final updated = await showDialog<Movie>(
      context: context,
      builder: (_) =>
          MovieFormDialog(id: movie?.id ?? _library.nextId, movie: movie),
    );
    if (!mounted || updated == null) return;
    final movies = movie == null
        ? [..._library.movies, updated]
        : _library.movies
              .map((item) => item.id == updated.id ? updated : item)
              .toList();
    await _applyChange(
      MovieLibrary(
        movies: movies,
        nextId: movie == null ? _library.nextId + 1 : _library.nextId,
      ),
      movie == null ? 'Movie added and saved.' : 'Movie updated and saved.',
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    if (_busy) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete movie?'),
        content: Text('Remove "${movie.title}" from your local library?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    await _applyChange(
      MovieLibrary(
        movies: _library.movies.where((item) => item.id != movie.id).toList(),
        nextId: _library.nextId,
      ),
      'Movie deleted and saved.',
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _busy || _errorMessage != null ? null : () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add movie'),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _load, child: const Text('Try again')),
            ],
          ),
        ),
      );
    }

    final keyword = _searchController.text.trim().toLowerCase();
    final movies = _library.movies
        .where(
          (movie) =>
              movie.title.toLowerCase().contains(keyword) ||
              movie.genres.any(
                (genre) => genre.toLowerCase().contains(keyword),
              ),
        )
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.autoSave ? 'Movie database' : 'My saved movies',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.autoSave
                    ? 'Add, edit or delete - changes save automatically.'
                    : 'Add movies, tap Save, then reopen the app.',
              ),
              const SizedBox(height: 12),
              if (widget.autoSave) ...[
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title or genre',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: keyword.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () =>
                                setState(() => _searchController.clear()),
                            icon: const Icon(Icons.clear),
                          ),
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
              ],
              Text(
                _status,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    widget.autoSave
                        ? '${movies.length} of ${_library.movies.length} movies'
                        : '${_library.movies.length} movies',
                  ),
                  if (!widget.autoSave)
                    ElevatedButton.icon(
                      onPressed: _busy || !_hasUnsavedChanges ? null : _save,
                      icon: const Icon(Icons.save_outlined),
                      label: Text(_isSaving ? 'Saving...' : 'Save'),
                    ),
                  TextButton.icon(
                    onPressed: _busy ? null : _reload,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reload'),
                  ),
                ],
              ),
              if (_isSaving) const LinearProgressIndicator(),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _reload,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              itemCount: movies.isEmpty ? 1 : movies.length,
              itemBuilder: (context, index) {
                if (movies.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      keyword.isEmpty
                          ? 'No movies yet. Tap Add movie to start.'
                          : 'No movies match your search.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                final movie = movies[index];
                return MovieCard(
                  movie: movie,
                  onEdit: widget.autoSave && !_busy
                      ? () => _openForm(movie)
                      : null,
                  onDelete: widget.autoSave && !_busy
                      ? () => _deleteMovie(movie)
                      : null,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
