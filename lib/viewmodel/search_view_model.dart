import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';

class SearchState {
  final List<GithubRepo> repos;
  final bool isLoading;
  final bool hasMore;
  final String query;
  final int page;
  final String? errorMessage;

  const SearchState({
    this.repos = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.query = '',
    this.page = 1,
    this.errorMessage,
  });

  SearchState copyWith({
    List<GithubRepo>? repos,
    bool? isLoading,
    bool? hasMore,
    String? query,
    int? page,
    String? errorMessage,
  }) {
    return SearchState(
      repos: repos ?? this.repos,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      query: query ?? this.query,
      page: page ?? this.page,
      errorMessage: errorMessage,
    );
  }
}

class SearchViewModel extends Notifier<SearchState> {
  @override
  SearchState build() {
    return const SearchState();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState(); // reset to home
      return;
    }

    state = SearchState(query: query, isLoading: true);

    try {
      final repository = ref.read(githubRepositoryProvider);
      final result = await repository.searchRepositories(query: query, page: 1);

      state = state.copyWith(
        repos: result,
        isLoading: false,
        hasMore: result.isNotEmpty,
        page: 1,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore || state.query.isEmpty) return;

    state = state.copyWith(isLoading: true);

    try {
      final nextPage = state.page + 1;
      final repository = ref.read(githubRepositoryProvider);
      final result = await repository.searchRepositories(query: state.query, page: nextPage);

      state = state.copyWith(
        repos: [...state.repos, ...result],
        isLoading: false,
        hasMore: result.isNotEmpty,
        page: nextPage,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final searchProvider = NotifierProvider.autoDispose<SearchViewModel, SearchState>(() {
  return SearchViewModel();
});
