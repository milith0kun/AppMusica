import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// Base shimmer widget with app theme colors
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.cardColor,
      highlightColor: AppTheme.cardColor.withOpacity(0.3),
      child: child,
    );
  }
}

/// Shimmer placeholder for a rectangular box
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppBorderRadius.md,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Shimmer loading for song card
class SongCardShimmer extends StatelessWidget {
  const SongCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            // Album cover
            const ShimmerBox(
              width: 56,
              height: 56,
              borderRadius: AppBorderRadius.sm,
            ),
            const SizedBox(width: AppSpacing.md),
            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 16,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ShimmerBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 14,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Duration
            const ShimmerBox(
              width: 40,
              height: 14,
              borderRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for playlist card (horizontal)
class PlaylistCardShimmer extends StatelessWidget {
  final bool isHorizontal;

  const PlaylistCardShimmer({
    super.key,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return AppShimmer(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              // Playlist cover
              const ShimmerBox(
                width: 80,
                height: 80,
                borderRadius: AppBorderRadius.md,
              ),
              const SizedBox(width: AppSpacing.md),
              // Playlist info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 18,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    ShimmerBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 14,
                      borderRadius: 4,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    const ShimmerBox(
                      width: 60,
                      height: 12,
                      borderRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return AppShimmer(
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Playlist cover
            const ShimmerBox(
              width: 160,
              height: 160,
              borderRadius: AppBorderRadius.md,
            ),
            const SizedBox(height: AppSpacing.sm),
            // Title
            const ShimmerBox(
              width: 140,
              height: 16,
              borderRadius: 4,
            ),
            const SizedBox(height: AppSpacing.xs),
            // Description
            const ShimmerBox(
              width: 100,
              height: 14,
              borderRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for category card
class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ShimmerBox(
              width: 48,
              height: 48,
              borderRadius: 24,
            ),
            const SizedBox(height: AppSpacing.sm),
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.2,
              height: 16,
              borderRadius: 4,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading for album grid item
class AlbumGridShimmer extends StatelessWidget {
  const AlbumGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album cover
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Title
          const ShimmerBox(
            width: double.infinity,
            height: 16,
            borderRadius: 4,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Artist
          ShimmerBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 14,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Shimmer loading for home screen sections
class HomeSectionShimmer extends StatelessWidget {
  const HomeSectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        AppShimmer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 24,
              borderRadius: 4,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Horizontal scroll list
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: 3,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                right: index < 2 ? AppSpacing.md : 0,
              ),
              child: const PlaylistCardShimmer(isHorizontal: false),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading for a full list of songs
class SongListShimmer extends StatelessWidget {
  final int itemCount;

  const SongListShimmer({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const SongCardShimmer(),
    );
  }
}

/// Shimmer loading for a grid of albums
class AlbumGridShimmerList extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;

  const AlbumGridShimmerList({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const AlbumGridShimmer(),
    );
  }
}

/// Shimmer loading for category grid
class CategoryGridShimmer extends StatelessWidget {
  final int itemCount;

  const CategoryGridShimmer({
    super.key,
    this.itemCount = 6,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.2,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const CategoryCardShimmer(),
    );
  }
}

/// Shimmer loading for player screen
class PlayerScreenShimmer extends StatelessWidget {
  const PlayerScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large album art
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.8,
              borderRadius: AppBorderRadius.xl,
            ),
            const SizedBox(height: AppSpacing.xl),
            // Song title
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 28,
              borderRadius: 4,
            ),
            const SizedBox(height: AppSpacing.md),
            // Artist
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 20,
              borderRadius: 4,
            ),
            const SizedBox(height: AppSpacing.xl),
            // Progress bar
            ShimmerBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 4,
              borderRadius: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => ShimmerBox(
                  width: index == 2 ? 72 : 48,
                  height: index == 2 ? 72 : 48,
                  borderRadius: index == 2 ? 36 : 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
