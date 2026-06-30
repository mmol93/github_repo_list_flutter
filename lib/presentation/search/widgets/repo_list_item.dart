import 'package:flutter/material.dart';
import 'package:github_repo_list_flutter/data/model/github_repo.dart';

class RepoListItem extends StatelessWidget {
  final GithubRepo repo;
  final VoidCallback onTap;
  final VoidCallback onStarTap;
  final bool isStarred;
  final String heroTag;

  const RepoListItem({
    super.key,
    required this.repo,
    required this.onTap,
    required this.onStarTap,
    required this.heroTag,
    this.isStarred = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: heroTag,
        child: CircleAvatar(
          backgroundImage: NetworkImage(repo.owner.avatarUrl),
          backgroundColor: Colors.transparent,
        ),
      ),
      title: Text(repo.fullName),
      trailing: IconButton(
        icon: Icon(
          isStarred ? Icons.star : Icons.star_border,
          color: isStarred ? Colors.amber : Colors.grey,
        ),
        onPressed: onStarTap,
      ),
      onTap: onTap,
    );
  }
}
