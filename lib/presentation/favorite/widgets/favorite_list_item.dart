import 'package:flutter/material.dart';
import 'package:github_repo_list_flutter/data/model/favorite_repo.dart';

class FavoriteListItem extends StatelessWidget {
  final FavoriteRepo repo;
  final VoidCallback onTap;
  final VoidCallback onRemoveTap;
  final String heroTag;

  const FavoriteListItem({
    super.key,
    required this.repo,
    required this.onTap,
    required this.onRemoveTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: heroTag,
        child: CircleAvatar(
          backgroundImage: NetworkImage(repo.avatarUrl),
          backgroundColor: Colors.transparent,
        ),
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
