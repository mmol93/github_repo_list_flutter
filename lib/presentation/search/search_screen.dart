import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/presentation/search/widgets/repo_list_item.dart';
import 'package:github_repo_list_flutter/viewmodel/search_view_model.dart';
import 'package:github_repo_list_flutter/viewmodel/favorite_view_model.dart';
import 'package:github_repo_list_flutter/presentation/detail/detail_screen.dart';
import 'package:github_repo_list_flutter/utils.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Automatically load the next page when the user scrolls within 200 pixels of the bottom
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(searchProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final favoritesState = ref.watch(favoriteProvider);
    final favoriteRepoIds = favoritesState.value?.map((e) => e.id).toSet() ?? {};

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search repositories...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  ref.read(searchProvider.notifier).search('');
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              ref.read(searchProvider.notifier).search(value);
            },
          ),
        ),
        Expanded(
          child: _buildBody(searchState, favoriteRepoIds),
        ),
      ],
    );
  }

  Widget _buildBody(SearchState state, Set<int> favoriteRepoIds) {
    if (state.query.isEmpty) {
      return const Center(
        child: Text(
          'Search some repositories!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    if (state.isLoading && state.repos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null && state.repos.isEmpty) {
      return Center(child: Text('Error: ${state.errorMessage}'));
    }

    if (state.repos.isEmpty) {
      return const Center(child: Text('Empty', style: TextStyle(fontSize: 20)));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: state.repos.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.repos.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final repo = state.repos[index];
        final isStarred = favoriteRepoIds.contains(repo.id);

        return RepoListItem(
          repo: repo,
          isStarred: isStarred,
          heroTag: 'search_avatar_${repo.id}',
          onTap: () {
            slideHorizontalNavigateStateful(
              context,
              DetailScreen(
                initialRepo: repo,
                heroTag: 'search_avatar_${repo.id}',
              ),
            );
          },
          onStarTap: () {
            ref.read(favoriteProvider.notifier).toggleFavorite(repo);
          },
        );
      },
    );
  }
}
