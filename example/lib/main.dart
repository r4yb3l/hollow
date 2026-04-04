import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import 'bones/bones_registry.dart';

void main() {
  HollowRunner.run(
    app: const App(),
    setup: registerAllBones,
    fixtures: () => [
      Skeleton(
        name: 'article-card',
        loading: false,
        fixture: ArticleCard(data: ArticleCard.mock),
        child: const SizedBox.shrink(),
      ),
    ],
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const FeedScreen(),
    );
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('hollow')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: ArticleCard.feed.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => Skeleton(
          name: 'article-card',
          loading: _loading,
          child: ArticleCard(data: ArticleCard.feed[index]),
        ),
      ),
    );
  }
}

typedef Article = ({String title, String author, String readTime, int likes});

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.data});

  final Article data;

  static const mock = (
    title: 'Pixel-perfect skeletons in Flutter',
    author: 'r4yb3l',
    readTime: '4 min read',
    likes: 128,
  );

  static const feed = <Article>[
    mock,
    (title: 'Building reactive UIs with BLoC', author: 'r4yb3l', readTime: '6 min read', likes: 94),
    (title: 'Flutter performance tips', author: 'r4yb3l', readTime: '5 min read', likes: 211),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/108087778?v=4'),
                ),
                const SizedBox(width: 8),
                Text(data.author, style: Theme.of(context).textTheme.labelMedium),
                const Spacer(),
                Icon(Icons.schedule, size: 14, color: colors.outline),
                const SizedBox(width: 4),
                Text(data.readTime, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 12),
                Icon(Icons.favorite_border, size: 14, color: colors.outline),
                const SizedBox(width: 4),
                Text('${data.likes}', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
