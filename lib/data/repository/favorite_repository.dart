import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:github_repo_list_flutter/data/provider/shared_preferences_provider.dart';

class FavoritesRepository {
  final SharedPreferences prefs;
  static const String _key = 'favorite_repos';

  FavoritesRepository(this.prefs);

  List<FavoriteRepo> getFavorites() {
    final jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => FavoriteRepo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // On parsing error, delete existing data and return an empty list
      prefs.remove(_key);
      return [];
    }
  }

  Future<void> addFavorite(FavoriteRepo repo) async {
    final favorites = getFavorites();

    // Do not add if it already exists
    if (favorites.any((e) => e.id == repo.id)) return;

    favorites.add(repo);
    await _saveFavorites(favorites);
  }

  Future<void> removeFavorite(int id) async {
    final favorites = getFavorites();
    favorites.removeWhere((e) => e.id == id);
    await _saveFavorites(favorites);
  }

  bool isFavorite(int id) {
    final favorites = getFavorites();
    return favorites.any((e) => e.id == id);
  }

  Future<void> _saveFavorites(List<FavoriteRepo> favorites) async {
    final jsonList = favorites.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }
}

final favoriteRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesRepository(prefs);
});
