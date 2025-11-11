import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/widgets/playlist_card.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/playlist_model.dart';
import '../../../data/models/category_model.dart';
import '../../../shared/providers/audio_player_provider.dart';

// Providers for home data
final featuredPlaylistsProvider = FutureProvider<List<PlaylistModel>>((ref) async {
  final musicRepo = ref.watch(musicRepositoryProvider);
  final result = await musicRepo.getPlaylists(type: 'featured', limit: 10);
  return result.items;
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final musicRepo = ref.watch(musicRepositoryProvider);
  return await musicRepo.getCategories();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredPlaylists = ref.watch(featuredPlaylistsProvider);
    final categories = ref.watch(categoriesProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appName),
            if (authState.user != null)
              Text(
                'Hola, ${authState.user!.fullName.split(' ').first}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredPlaylistsProvider);
          ref.invalidate(categoriesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subscription Status Banner
              if (authState.user?.subscription != null)
                _buildSubscriptionBanner(context, authState.user!.subscription!),

              const SizedBox(height: AppSpacing.lg),

              // Categories
              Text(
                AppStrings.categories,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              categories.when(
                data: (cats) => _buildCategoriesGrid(context, cats),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Featured Playlists
              Text(
                AppStrings.featured,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              featuredPlaylists.when(
                data: (playlists) => _buildFeaturedPlaylists(context, ref, playlists),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionBanner(BuildContext context, SubscriptionInfo subscription) {
    final isTrialing = subscription.status == 'trialing';
    final daysRemaining = isTrialing && subscription.trialEndsAt != null
        ? subscription.trialEndsAt!.difference(DateTime.now()).inDays
        : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.white),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTrialing ? AppStrings.trialActive : AppStrings.subscriptionActive,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isTrialing)
                  Text(
                    '$daysRemaining días restantes',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
              ],
            ),
          ),
          if (isTrialing)
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/subscription');
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Suscribirse'),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, List<CategoryModel> categories) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length > 6 ? 6 : categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(context, category);
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/category',
          arguments: category,
        );
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              size: 32,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              category.name,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedPlaylists(
    BuildContext context,
    WidgetRef ref,
    List<PlaylistModel> playlists,
  ) {
    if (playlists.isEmpty) {
      return const Center(
        child: Text('No hay playlists destacadas'),
      );
    }

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return PlaylistCard(
            playlist: playlist,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/playlist',
                arguments: playlist,
              );
            },
          );
        },
      ),
    );
  }
}
