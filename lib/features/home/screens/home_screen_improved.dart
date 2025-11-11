import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/providers/auth_provider.dart';
import '../../../data/models/user_model.dart';

class HomeScreenImproved extends ConsumerStatefulWidget {
  const HomeScreenImproved({super.key});

  @override
  ConsumerState<HomeScreenImproved> createState() => _HomeScreenImprovedState();
}

class _HomeScreenImprovedState extends ConsumerState<HomeScreenImproved> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final subscription = user?.subscription;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            elevation: 0,
            backgroundColor: AppTheme.backgroundColor,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.backgroundColor,
                      AppTheme.surfaceColor,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getGreeting(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppTheme.textSecondaryColor,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    user?.name ?? 'Terapeuta',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimaryColor,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Profile avatar
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/settings');
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: AppTheme.shadowMd,
                                ),
                                child: user?.avatarUrl != null
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user!.avatarUrl!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Subscription Banner (if trial or near expiration)
          if (subscription?.status == 'trial' || subscription?.status == 'trialing')
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: GradientCard(
                  gradientColors: const [
                    AppTheme.primaryColor,
                    AppTheme.secondaryColor,
                  ],
                  onTap: () {
                    Navigator.pushNamed(context, '/subscription');
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Prueba Gratuita Activa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_getDaysRemaining(subscription)} días restantes',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Quick Actions
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          'Buscar',
                          Icons.search,
                          AppTheme.primaryColor,
                          () {
                            // Navigate to search with focus
                            DefaultTabController.of(context).animateTo(2);
                          },
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _buildQuickAction(
                          context,
                          'Favoritos',
                          Icons.favorite,
                          AppTheme.accentColor,
                          () {
                            // Navigate to library favorites
                            DefaultTabController.of(context).animateTo(1);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Categories Section
          SliverToBoxAdapter(
            child: _buildSectionHeader('Categorías Terapéuticas'),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.sm,
                mainAxisSpacing: AppSpacing.sm,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = AppConstants.categories[index];
                  return _buildCategoryCard(context, category);
                },
                childCount: AppConstants.categories.length > 6
                    ? 6
                    : AppConstants.categories.length,
              ),
            ),
          ),

          // Featured Playlists Section
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Destacados para Ti'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < 4 ? AppSpacing.md : 0,
                    ),
                    child: _buildPlaylistCard(context, index),
                  );
                },
              ),
            ),
          ),

          // Recent Activity
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          SliverToBoxAdapter(
            child: _buildSectionHeader('Continuar Escuchando'),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _buildRecentSongCard(context, index),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días';
    } else if (hour < 18) {
      return 'Buenas tardes';
    } else {
      return 'Buenas noches';
    }
  }

  int _getDaysRemaining(SubscriptionInfo? subscription) {
    if (subscription?.trialEndDate == null) return 14;
    final remaining =
        subscription!.trialEndDate!.difference(DateTime.now()).inDays;
    return remaining > 0 ? remaining : 0;
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppTheme.textPrimaryColor,
          letterSpacing: 0.15,
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return PremiumCard(
      onTap: onTap,
      gradient: LinearGradient(
        colors: [
          color.withOpacity(0.2),
          color.withOpacity(0.05),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String category) {
    final gradients = [
      AppTheme.primaryGradient,
      AppTheme.accentGradient,
      const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ];

    final icons = [
      Icons.self_improvement,
      Icons.bolt,
      Icons.spa,
      Icons.psychology,
      Icons.lightbulb,
      Icons.favorite,
    ];

    return GradientCard(
      gradientColors: gradients[AppConstants.categories.indexOf(category) % gradients.length]
          .colors,
      onTap: () {
        // Navigate to category
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[AppConstants.categories.indexOf(category) % icons.length],
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, int index) {
    return SizedBox(
      width: 160,
      child: PremiumCard(
        onTap: () {
          // Navigate to playlist
        },
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: AppTheme.cardGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppBorderRadius.lg),
                  topRight: Radius.circular(AppBorderRadius.lg),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.music_note,
                  size: 48,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Playlist ${index + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '12 canciones',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSongCard(BuildContext context, int index) {
    return PremiumCard(
      onTap: () {
        // Play song
      },
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          // Album art
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: AppTheme.cardGradient,
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: const Icon(
              Icons.music_note,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Song info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Canción ${index + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Artista • Álbum',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Play button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
