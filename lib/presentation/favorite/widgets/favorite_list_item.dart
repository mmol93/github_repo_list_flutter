import 'package:flutter/material.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';

class FavoriteListItem extends StatelessWidget {
  final FavoriteRepo repo;
  final VoidCallback onTap;
  final VoidCallback onRemoveTap;

  const FavoriteListItem({
    super.key,
    required this.repo,
    required this.onTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(repo.avatarUrl),
        backgroundColor: Colors.transparent,
      ),
      title: Text(repo.fullName),
      trailing: IconButton(
        icon: const Icon(Icons.star, color: Colors.amber),
        onPressed: onRemoveTap,
      ),
      onTap: onTap,
    );
  }
}
