import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';
import 'package:github_repo_list_flutter/data/repository/favorite_repository.dart';

class FavoriteViewModel extends AsyncNotifier<List<FavoriteRepo>> {
  @override
  FutureOr<List<FavoriteRepo>> build() {
    final repository = ref.read(favoriteRepositoryProvider);
    return repository.getFavorites();
  }

  Future<void> toggleFavorite(FavoriteRepo repo) async {
    final repository = ref.read(favoriteRepositoryProvider);
    final isAlreadyFavoriteRepo = repository.isFavorite(repo.id);

    if (isAlreadyFavoriteRepo) {
      await repository.removeFavorite(repo.id);
    } else {
      await repository.addFavorite(repo);
    }

    // Refresh state
    state = const AsyncLoading();
    state = AsyncValue.data(repository.getFavorites());
  }

  Future<void> removeFavorite(int id) async {
    final repository = ref.read(favoriteRepositoryProvider);
    await repository.removeFavorite(id);

    // Refresh state
    state = const AsyncLoading();
    state = AsyncValue.data(repository.getFavorites());
  }
}

final favoriteProvider =
    AsyncNotifierProvider.autoDispose<FavoriteViewModel, List<FavoriteRepo>>(
      () {
        return FavoriteViewModel();
      },
    );
