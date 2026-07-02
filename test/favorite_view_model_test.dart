import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';
import 'package:github_repo_list_flutter/viewmodel/favorite_view_model.dart';
import 'package:github_repo_list_flutter/data/provider/shared_preferences_provider.dart';

void main() {
  group('FavoriteViewModel State Management Test', () {
    late ProviderContainer container;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      // set up fake prefs
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be an empty list', () async {
      final state = await container.read(favoriteProvider.future);
      expect(state, isEmpty);
    });

    test('toggleFavorite should ADD the repo if it does not exist in state', () async {
      final repo = FavoriteRepo(id: 123, fullName: 'flutter/flutter', avatarUrl: 'url');

      // touch toggle
      await container.read(favoriteProvider.notifier).toggleFavorite(repo);

      final state = await container.read(favoriteProvider.future);
      expect(state.length, 1);
      expect(state.first.id, 123);
      expect(state.first.fullName, 'flutter/flutter');
    });

    test('toggleFavorite should REMOVE the repo if it already exists in state', () async {
      final repo = FavoriteRepo(id: 456, fullName: 'dart-lang/sdk', avatarUrl: 'url');

      // save repo
      await container.read(favoriteProvider.notifier).toggleFavorite(repo);
      var state = await container.read(favoriteProvider.future);
      expect(state.length, 1);

      // toggle same repo
      await container.read(favoriteProvider.notifier).toggleFavorite(repo);
      state = await container.read(favoriteProvider.future);

      expect(state, isEmpty);
    });

    test('removeFavorite should explicitly remove a repo by ID', () async {
      final repo1 = FavoriteRepo(id: 10, fullName: 'repo1', avatarUrl: 'url');
      final repo2 = FavoriteRepo(id: 20, fullName: 'repo2', avatarUrl: 'url');

      // save repo
      await container.read(favoriteProvider.notifier).toggleFavorite(repo1);
      await container.read(favoriteProvider.notifier).toggleFavorite(repo2);

      // remove certain repo
      await container.read(favoriteProvider.notifier).removeFavorite(10);
      final state = await container.read(favoriteProvider.future);

      expect(state.length, 1);
      expect(state.first.id, 20); 
    });
  });
}
