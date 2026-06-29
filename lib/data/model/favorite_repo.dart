class FavoriteRepo {
  final int id;
  final String fullName;
  final String avatarUrl;

  const FavoriteRepo({
    required this.id,
    required this.fullName,
    required this.avatarUrl,
  });

  factory FavoriteRepo.fromJson(Map<String, dynamic> json) {
    return FavoriteRepo(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'avatar_url': avatarUrl,
  };
}