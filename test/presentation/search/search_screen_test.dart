import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/presentation/search/search_screen.dart';
import 'package:github_repo_list_flutter/viewmodel/search_view_model.dart';

class MockSearchViewModel extends SearchViewModel {
  final SearchState _mockState;

  MockSearchViewModel(this._mockState);

  @override
  SearchState build() {
    return _mockState;
  }
}

void main() {
  group('SearchScreen Widget Test', () {
    testWidgets('Displays "Search some repositories!" when query is empty', (WidgetTester tester) async {
      // set dummy SearchScreen
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SearchScreen(),
            ),
          ),
        ),
      );

      // check init screen status
      expect(find.text('Search some repositories!'), findsOneWidget);
      // no loading indicator
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Displays loading indicator when waiting for network', (WidgetTester tester) async {
      // create a state object that forces a loading state.
      const mockState = SearchState(
        query: 'flutter',
        isLoading: true,
        repos: [],
      );

      // override mock state
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchProvider.overrideWith(() => MockSearchViewModel(mockState)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SearchScreen(),
            ),
          ),
        ),
      );

      // check loading SearchScreen
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Search some repositories!'), findsNothing);
    });

    testWidgets('Displays "Empty" when there are no search results', (WidgetTester tester) async {
      // when search result is empty
      const mockState = SearchState(
        query: ' ',
        isLoading: false,
        repos: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchProvider.overrideWith(() => MockSearchViewModel(mockState)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SearchScreen(),
            ),
          ),
        ),
      );

      // check SearchScreen has
      expect(find.text('Empty'), findsOneWidget);
    });
  });
}
