import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import 'bones/bones_registry.dart';

void main() {
  registerAllBones();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
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
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
            Skeleton(
              name: 'photo-card',
              loading: _loading,
              fixture: const PhotoCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1706195782033-6a351ce67878?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                title: 'Pixel-perfect skeletons in Flutter',
                subtitle: 'A deep dive into the RenderObject tree',
                author: 'r4yb3l',
                readTime: '4 min read',
                likes: 128,
              ),
              child: const PhotoCard(
                imageUrl:
                    'https://images.unsplash.com/photo-1706195782033-6a351ce67878?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                title: 'Pixel-perfect skeletons in Flutter',
                subtitle: 'A deep dive into the RenderObject tree',
                author: 'r4yb3l',
                readTime: '4 min read',
                likes: 128,
              ),
            ),
            const SizedBox(height: 16),
            Skeleton(
              name: 'profile-card',
              loading: _loading,
              fixture: const ProfileCard(
                name: 'Gabriel Torres',
                handle: '@gabtorres',
                bio: 'Flutter developer & open source contributor',
                followers: '2.4k',
                following: '312',
              ),
              child: const ProfileCard(
                name: 'Gabriel Torres',
                handle: '@gabtorres',
                bio: 'Flutter developer & open source contributor',
                followers: '2.4k',
                following: '312',
              ),
            ),
            const SizedBox(height: 16),
            Skeleton(
              name: 'stat-card',
              loading: _loading,
              fixture: const StatCard(
                title: 'Monthly Revenue',
                value: '\$12,847',
                change: '+12.5%',
                icon: Icons.trending_up,
              ),
              child: const StatCard(
                title: 'Monthly Revenue',
                value: '\$12,847',
                change: '+12.5%',
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(height: 16),
            Skeleton(
              name: 'list-tile',
              loading: _loading,
              fixture: const MessageTile(
                name: 'Laura Mendez',
                message: 'Hey! Check out the new skeleton package',
                time: '2m ago',
                avatarUrl: 'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?semt=ais_incoming&w=740&q=80',
              ),
              child: const MessageTile(
                name: 'Laura Mendez',
                message: 'Hey! Check out the new skeleton package',
                time: '2m ago',
                avatarUrl: 'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?semt=ais_incoming&w=740&q=80',
              ),
            ),
            const SizedBox(height: 16),
            Skeleton(
              name: 'list-tile',
              loading: _loading,
              fixture: const MessageTile(
                name: 'Carlos Ruiz',
                message: 'The shimmer animation looks smooth!',
                time: '15m ago',
                avatarUrl: 'https://static.vecteezy.com/system/resources/thumbnails/005/346/410/small/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg',
              ),
              child: const MessageTile(
                name: 'Carlos Ruiz',
                message: 'The shimmer animation looks smooth!',
                time: '15m ago',
                avatarUrl: 'https://static.vecteezy.com/system/resources/thumbnails/005/346/410/small/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg',
              ),
            ),
          ],
              ),
            ),
      ),
        );
      }
    }

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
            errorBuilder: (_, __, ___) => Container(
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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
                Text(
                  '$likes',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
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

class ProfileCard extends StatefulWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.handle,
    required this.bio,
    required this.followers,
    required this.following,
  });

  final String name;
  final String handle;
  final String bio;
  final String followers;
  final String following;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final _controller = ExpansibleController();
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        controller: _controller,
        initiallyExpanded: false,
        onExpansionChanged: (v) => setState(() => _expanded = v),
        tilePadding: const EdgeInsets.all(20),
        childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            'https://st5.depositphotos.com/88987118/74071/v/450/depositphotos_740719558-stock-illustration-man-professional-business-casual-young.jpg',
          ),
        ),
        title: Text(
          widget.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        subtitle: Text(
          widget.handle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.primary,
              ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilledButton.tonal(
              onPressed: () {},
              child: const Text('Follow'),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _expanded ? _controller.collapse() : _controller.expand();
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: colors.surfaceContainerHighest,
                child: Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 18,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.bio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _Stat(label: 'Followers', value: widget.followers),
              _Stat(label: 'Following', value: widget.following),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
  });

  final String title;
  final String value;
  final String change;
  final IconData icon;

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
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: colors.primary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                change,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  const MessageTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.avatarUrl,
  });

  final String name;
  final String message;
  final String time;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        time,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
