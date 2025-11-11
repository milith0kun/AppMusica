import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.library),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: AppStrings.favorites),
            Tab(text: AppStrings.playlists),
            Tab(text: AppStrings.history),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFavoritesTab(),
          _buildPlaylistsTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Text('Favoritos'),
    );
  }

  Widget _buildPlaylistsTab() {
    return const Center(
      child: Text('Playlists'),
    );
  }

  Widget _buildHistoryTab() {
    return const Center(
      child: Text('Historial'),
    );
  }
}
