import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';
import 'package:github_repo_list_flutter/data/repository/favorite_repository.dart';

class FavoriteViewModel extends AsyncNotifier<List<FavoriteRepo>> {
  @override
  FutureOr<List<FavoriteRepo>> build() {
    final repository = ref.read(favoriteRepositoryProvider);
    return repository.getFavorites();
  }

  Future<void> toggleFavorite(GithubRepo repo) async {
    final repository = ref.read(favoriteRepositoryProvider);
    final isFav = repository.isFavorite(repo.id);

    if (isFav) {
      await repository.removeFavorite(repo.id);
    } else {
      await repository.addFavorite(repo.toFavorite());
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
