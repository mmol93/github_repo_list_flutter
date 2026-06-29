import 'dart:convert';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';
import 'package:http/http.dart' as http;

class GithubRepository {
  static const String _baseUrl = 'https://api.github.com';

  Future<List<GithubRepo>> searchRepositories({
    required String query,
    int page = 1,
    int perPage = 30,
  }) async {
    if (query.trim().isEmpty) return [];

    final uri = Uri.parse(
      '$_baseUrl/search/repositories'
      '?q=${Uri.encodeComponent(query)}'
      '&page=$page&per_page=$perPage&sort=stars',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>;

      return items
          .map((json) => GithubRepo.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to search repositories. (Status code: \${response.statusCode})',
      );
    }
  }

  Future<GithubRepo> getRepositoryDetail(String fullName) async {
    final uri = Uri.parse('$_baseUrl/repos/$fullName');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return GithubRepo.fromJson(data);
    } else {
      throw Exception(
        'Failed to fetch repository details. (Status code: \${response.statusCode})',
      );
    }
  }
}
