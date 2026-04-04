import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import 'bones/bones_registry.dart';
import 'screens/dashboard_screen.dart';
import 'screens/feed_screen.dart';
import 'screens/messages_screen.dart';
import 'widgets/message_tile.dart';
import 'widgets/photo_card.dart';
import 'widgets/profile_card.dart';
import 'widgets/stat_card.dart';

void main() {
  HollowRunner.run(
    app: const App(),
    setup: registerAllBones,
    fixtures: () => [
      Skeleton(
        name: 'photo-card',
        loading: false,
        fixture: const PhotoCard(
          imageUrl:
              'https://images.unsplash.com/photo-1706195782033-6a351ce67878?fm=jpg&q=60&w=3000&auto=format&fit=crop',
          title: 'Pixel-perfect skeletons in Flutter',
          subtitle: 'A deep dive into the RenderObject tree',
          author: 'r4yb3l',
          readTime: '4 min read',
          likes: 128,
        ),
        child: const SizedBox.shrink(),
      ),
      Skeleton(
        name: 'list-tile',
        loading: false,
        fixture: const MessageTile(
          name: 'Laura Mendez',
          message: 'Hey! Check out the new skeleton package',
          time: '2m ago',
          avatarUrl:
              'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg',
        ),
        child: const SizedBox.shrink(),
      ),
      Skeleton(
        name: 'stat-card',
        loading: false,
        fixture: const StatCard(
          title: 'Monthly Revenue',
          value: '\$12,847',
          change: '+12.5%',
          icon: Icons.trending_up,
        ),
        child: const SizedBox.shrink(),
      ),
      Skeleton(
        name: 'profile-card',
        loading: false,
        fixture: const ProfileCard(
          name: 'Gabriel Torres',
          handle: '@gabtorres',
          bio: 'Flutter developer & open source contributor',
          followers: '2.4k',
          following: '312',
        ),
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
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const _Shell(),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _index = 0;

  static const _screens = [
    FeedScreen(),
    MessagesScreen(),
    DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.article_outlined), label: 'Feed'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'Dashboard'),
        ],
      ),
    );
  }
}
