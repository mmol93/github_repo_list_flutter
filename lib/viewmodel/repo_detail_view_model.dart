import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';
import 'package:github_repo_list_flutter/data/repository/github_repository.dart';

final repoDetailProvider = FutureProvider.autoDispose.family<GithubRepo, String>((ref, fullName) async {
  final repository = ref.watch(githubRepositoryProvider);
  return repository.getRepositoryDetail(fullName);
});
