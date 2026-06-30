import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';
import 'package:github_repo_list_flutter/viewmodel/repo_detail_view_model.dart';
import 'package:github_repo_list_flutter/viewmodel/favorite_view_model.dart';

class DetailScreen extends ConsumerWidget {
  final GithubRepo initialRepo;
  final String heroTag;

  const DetailScreen({super.key, required this.initialRepo, required this.heroTag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch detail provider for full repo data (including subscribers_count)
    final detailState = ref.watch(repoDetailProvider(initialRepo.fullName));
    
    // Watch favorites to determine star icon state
    final favoritesState = ref.watch(favoriteProvider);
    final isStarred = favoritesState.value?.any((e) => e.id == initialRepo.id) ?? false;

    // Use fetched data if available, otherwise fallback to initial data
    final displayRepo = detailState.value ?? initialRepo;

    return Scaffold(
      appBar: AppBar(
        title: Text(initialRepo.fullName),
        actions: [
          IconButton(
            icon: Icon(
              isStarred ? Icons.star : Icons.star_border,
              color: isStarred ? Colors.amber : Colors.grey,
            ),
            onPressed: () {
              ref.read(favoriteProvider.notifier).toggleFavorite(initialRepo);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Hero(
              tag: heroTag,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(initialRepo.owner.avatarUrl),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              initialRepo.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Detail Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Subscribers', 
                      detailState.isLoading 
                          ? null 
                          : '${displayRepo.subscribersCount ?? 0}',
                      Icons.visibility,
                    ),
                    _buildStatItem(
                      'Stars', 
                      detailState.isLoading 
                          ? null 
                          : '${displayRepo.stargazersCount ?? 0}',
                      Icons.star,
                    ),
                    _buildStatItem(
                      'Forks', 
                      detailState.isLoading 
                          ? null 
                          : '${displayRepo.forksCount ?? 0}',
                      Icons.fork_right,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            if (displayRepo.description != null && displayRepo.description!.isNotEmpty) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  displayRepo.description!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String? value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 8),
        SizedBox(
          height: 24,
          child: Center(
            child: value == null
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
