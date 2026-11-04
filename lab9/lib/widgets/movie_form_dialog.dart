import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieFormDialog extends StatefulWidget {
  const MovieFormDialog({super.key, required this.id, this.movie});

  final int id;
  final Movie? movie;

  @override
  State<MovieFormDialog> createState() => _MovieFormDialogState();
}

class _MovieFormDialogState extends State<MovieFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _year;
  late final TextEditingController _genres;
  late final TextEditingController _rating;

  @override
  void initState() {
    super.initState();
    final movie = widget.movie;
    _title = TextEditingController(text: movie?.title ?? '');
    _year = TextEditingController(text: movie?.year.toString() ?? '');
    _genres = TextEditingController(text: movie?.genres.join(', ') ?? '');
    _rating = TextEditingController(text: movie?.rating.toString() ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _year.dispose();
    _genres.dispose();
    _rating.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Movie(
        id: widget.id,
        title: _title.text.trim(),
        year: int.parse(_year.text.trim()),
        genres: _genres.text
            .split(',')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(),
        rating: double.parse(_rating.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.movie == null ? 'Add movie' : 'Edit movie'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _title,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a movie title.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _year,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final year = int.tryParse(value?.trim() ?? '');
                    return year == null ||
                            year < 1888 ||
                            year > DateTime.now().year + 5
                        ? 'Enter a valid release year.'
                        : null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _genres,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Genres',
                    hintText: 'Action, Adventure',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null ||
                          !value
                              .split(',')
                              .any((genre) => genre.trim().isNotEmpty)
                      ? 'Enter at least one genre.'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rating,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Rating (0-10)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    final rating = double.tryParse(value?.trim() ?? '');
                    return rating == null ||
                            !rating.isFinite ||
                            rating < 0 ||
                            rating > 10
                        ? 'Enter a rating from 0 to 10.'
                        : null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.movie == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
