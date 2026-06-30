import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:github_repo_list_flutter/data/repository/github_repository.dart';

class GithubRepo {
  final int id;
  final String fullName;
  final Owner owner;
  final int? subscribersCount;

  const GithubRepo({
    required this.id,
    required this.fullName,
    required this.owner,
    this.subscribersCount,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      subscribersCount: json['subscribers_count'] as int?,
    );
  }

  FavoriteRepo toFavorite() {
    return FavoriteRepo(id: id, fullName: fullName, avatarUrl: owner.avatarUrl);
  }
}

class Owner {
  final int id;
  final String login;
  final String avatarUrl;

  const Owner({required this.id, required this.login, required this.avatarUrl});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }
}

final githubRepositoryProvider = Provider<GithubRepository>((ref) {
  return GithubRepository();
});
