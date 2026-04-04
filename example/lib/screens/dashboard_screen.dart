import 'package:flutter/material.dart';
import 'package:hollow/hollow.dart';

import '../widgets/profile_card.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Skeleton(
              name: 'stat-card',
              loading: _loading,
              child: const StatCard(
                title: 'Monthly Revenue',
                value: '\$12,847',
                change: '+12.5%',
                icon: Icons.trending_up,
              ),
            ),
            const SizedBox(height: 12),
            Skeleton(
              name: 'stat-card',
              loading: _loading,
              child: const StatCard(
                title: 'Active Users',
                value: '3,241',
                change: '+4.2%',
                icon: Icons.people_outline,
              ),
            ),
            const SizedBox(height: 12),
            Skeleton(
              name: 'stat-card',
              loading: _loading,
              child: const StatCard(
                title: 'New Installs',
                value: '891',
                change: '+8.1%',
                icon: Icons.download_outlined,
              ),
            ),
            const SizedBox(height: 20),
            Skeleton(
              name: 'profile-card',
              loading: _loading,
              child: const ProfileCard(
                name: 'Gabriel Torres',
                handle: '@gabtorres',
                bio: 'Flutter developer & open source contributor',
                followers: '2.4k',
                following: '312',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
