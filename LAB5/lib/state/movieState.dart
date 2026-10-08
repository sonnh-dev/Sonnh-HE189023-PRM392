import 'package:flutter/foundation.dart';

class MovieLibrary extends ChangeNotifier {
  final Set<String> _favorites = {};

  bool isFavorite(String id) => _favorites.contains(id);
  int get favoriteCount => _favorites.length;

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }
}
