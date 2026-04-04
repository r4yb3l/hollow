import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  const PhotoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.readTime,
    required this.likes,
  });

  final String imageUrl;
  final String title;
  final String subtitle;
  final String author;
  final String readTime;
  final int likes;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              height: 200,
              color: colors.surfaceContainerHighest,
              child: const Icon(Icons.image, size: 48),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/108087778?v=4',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    author,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Icon(Icons.favorite_border, size: 18, color: colors.outline),
                const SizedBox(width: 4),
                Text('$likes', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 12),
                Icon(Icons.schedule, size: 16, color: colors.outline),
                const SizedBox(width: 4),
                Text(
                  readTime,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
