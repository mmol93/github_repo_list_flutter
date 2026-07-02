import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';
import 'package:github_repo_list_flutter/data/repository/github_repository.dart';
import 'package:github_repo_list_flutter/viewmodel/search_view_model.dart';

// set up mock repository
class MockGithubRepository implements GithubRepository {
  @override
  Future<List<GithubRepo>> searchRepositories({
    required String query,
    int page = 1,
    int perPage = 30,
  }) async {
    // error situation
    if (query == 'error') {
      throw Exception('Mock network error');
    }

    // no result situation
    if (query == 'empty') {
      return [];
    }

    // page 2 is the last page
    if (page >= 3) return [];
    
    return List.generate(
      30,
      (index) => GithubRepo(
        id: index + (page * 100),
        fullName: '$query-repo-${index + (page * 100)}',
        owner: Owner(id: index, login: 'user', avatarUrl: 'url'),
      ),
    );
  }

  @override
  Future<GithubRepo> getRepositoryDetail(String fullName) {
    // just dummy implementation
    throw UnimplementedError();
  }
}

void main() {
  group('SearchViewModel State Management Test', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          githubRepositoryProvider.overrideWithValue(MockGithubRepository()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state should be empty and not loading', () {
      final state = container.read(searchProvider);
      
      expect(state.query, isEmpty);
      expect(state.repos, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.page, 1);
    });

    test('search() with empty query should reset to initial state', () async {
      // set earch with "flutter"
      await container.read(searchProvider.notifier).search('flutter');
      var state = container.read(searchProvider);
      expect(state.repos.length, 30);

      // set search to empty
      await container.read(searchProvider.notifier).search('');
      state = container.read(searchProvider);

      expect(state.query, isEmpty);
      expect(state.repos, isEmpty);
    });

    test('search() should fetch data and update state correctly', () async {
      // set search with "flutter"
      await container.read(searchProvider.notifier).search('flutter');
      final state = container.read(searchProvider);

      expect(state.query, 'flutter');
      expect(state.isLoading, isFalse);
      expect(state.repos.length, 30);
      expect(state.hasMore, isTrue);
      expect(state.page, 1);
      expect(state.errorMessage, isNull);
    });

    test('search() with error should set errorMessage', () async {
      // make error
      await container.read(searchProvider.notifier).search('error');
      final state = container.read(searchProvider);

      expect(state.repos, isEmpty);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, contains('Mock network error'));
    });

    test('loadMore() should append data and increment page', () async {
      await container.read(searchProvider.notifier).search('flutter');
      var state = container.read(searchProvider);
      expect(state.repos.length, 30);
      expect(state.page, 1);

      // load nex page
      await container.read(searchProvider.notifier).loadMore();
      state = container.read(searchProvider);

      expect(state.repos.length, 60);
      expect(state.page, 2);
      expect(state.hasMore, isTrue);
    });

    test('loadMore() should set hasMore to false when no more data', () async {
      // load page to 2
      await container.read(searchProvider.notifier).search('flutter');
      await container.read(searchProvider.notifier).loadMore();
      
      // load last page
      await container.read(searchProvider.notifier).loadMore();
      final state = container.read(searchProvider);

      // check last page and hasMore
      expect(state.repos.length, 60); 
      expect(state.page, 3);
      expect(state.hasMore, isFalse); // 무한 스크롤 종료!
    });
  });
}
