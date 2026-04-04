import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import '../widgets/message_tile.dart';

const _messages = [
  (
    name: 'Laura Mendez',
    message: 'Hey! Check out the new skeleton package',
    time: '2m ago',
    avatarUrl:
        'https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg',
  ),
  (
    name: 'Carlos Ruiz',
    message: 'The shimmer animation looks really smooth!',
    time: '15m ago',
    avatarUrl:
        'https://static.vecteezy.com/system/resources/thumbnails/005/346/410/small/close-up-portrait-of-smiling-handsome-young-caucasian-man-face-looking-at-camera-on-isolated-light-gray-studio-background-photo.jpg',
  ),
  (
    name: 'Ana García',
    message: 'Can we ship this to production by Friday?',
    time: '1h ago',
    avatarUrl:
        'https://img.freepik.com/free-photo/portrait-beautiful-young-woman-standing-grey-wall_176420-35165.jpg',
  ),
  (
    name: 'David Kim',
    message: 'LGTM, approved your PR',
    time: '3h ago',
    avatarUrl: null,
  ),
];

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
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
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _messages.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final m = _messages[index];
          return Skeleton(
            name: 'list-tile',
            loading: _loading,
            child: MessageTile(
              name: m.name,
              message: m.message,
              time: m.time,
              avatarUrl: m.avatarUrl,
            ),
          );
        },
      ),
    );
  }
}
