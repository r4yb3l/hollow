import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import '../widgets/photo_card.dart';

const _articles = [
  (
    title: 'Pixel-perfect skeletons in Flutter',
    subtitle: 'A deep dive into the RenderObject tree',
    author: 'r4yb3l',
    readTime: '4 min read',
    likes: 128,
    imageUrl:
        'https://images.unsplash.com/photo-1706195782033-6a351ce67878?fm=jpg&q=60&w=3000&auto=format&fit=crop',
  ),
  (
    title: 'Building reactive UIs with BLoC',
    subtitle: 'State management patterns that scale',
    author: 'r4yb3l',
    readTime: '6 min read',
    likes: 94,
    imageUrl:
        'https://images.unsplash.com/photo-1555066931-4365d14bab8c?fm=jpg&q=60&w=3000&auto=format&fit=crop',
  ),
  (
    title: 'Flutter performance tips you should know',
    subtitle: 'From repaint boundaries to shader warm-up',
    author: 'r4yb3l',
    readTime: '5 min read',
    likes: 211,
    imageUrl:
        'https://images.unsplash.com/photo-1550439062-609e1531270e?fm=jpg&q=60&w=3000&auto=format&fit=crop',
  ),
];

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
      appBar: AppBar(title: const Text('Feed')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _articles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final a = _articles[index];
          return Skeleton(
            name: 'photo-card',
            loading: _loading,
            child: PhotoCard(
              imageUrl: a.imageUrl,
              title: a.title,
              subtitle: a.subtitle,
              author: a.author,
              readTime: a.readTime,
              likes: a.likes,
            ),
          );
        },
      ),
    );
  }
}
