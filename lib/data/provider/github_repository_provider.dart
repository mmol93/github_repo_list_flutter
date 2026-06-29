import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/repository/github_repository.dart';

final githubRepositoryProvider = Provider<GithubRepository>((ref) {
  return GithubRepository();
});
