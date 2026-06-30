import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/presentation/favorite/widgets/favorite_list_item.dart';
import 'package:github_repo_list_flutter/viewmodel/favorite_view_model.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: favoriteState.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorites yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final repo = favorites[index];
              return FavoriteListItem(
                repo: repo,
                onTap: () {
                  // TODO: Navigate to Detail Screen
                },
                onRemoveTap: () {
                  ref.read(favoriteProvider.notifier).removeFavorite(repo.id);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
