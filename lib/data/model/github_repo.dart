import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';

class GithubRepo {
  final int id;
  final String fullName;
  final Owner owner;
  final int? subscribersCount;
  final String? description;
  final int? stargazersCount;
  final String? language;
  final int? forksCount;
  final String? htmlUrl;

  const GithubRepo({
    required this.id,
    required this.fullName,
    required this.owner,
    this.subscribersCount,
    this.description,
    this.stargazersCount,
    this.language,
    this.forksCount,
    this.htmlUrl,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      owner: Owner.fromJson(json['owner'] as Map<String, dynamic>),
      subscribersCount: json['subscribers_count'] as int?,
      description: json['description'] as String?,
      stargazersCount: json['stargazers_count'] as int?,
      language: json['language'] as String?,
      forksCount: json['forks_count'] as int?,
      htmlUrl: json['html_url'] as String?,
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
