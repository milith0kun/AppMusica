import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/song_model.dart';
import '../../core/theme/app_theme.dart';

class SongCard extends StatelessWidget {
  final SongModel song;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onMore;
  final bool isFavorite;
  final bool showAlbum;

  const SongCard({
    super.key,
    required this.song,
    required this.onTap,
    this.onFavorite,
    this.onMore,
    this.isFavorite = false,
    this.showAlbum = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            // Cover Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              child: CachedNetworkImage(
                imageUrl: song.coverUrl ?? '',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 56,
                  height: 56,
                  color: AppTheme.cardColor,
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 56,
                  height: 56,
                  color: AppTheme.cardColor,
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (showAlbum && song.album != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      song.album!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Duration
            Text(
              _formatDuration(song.duration),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: AppSpacing.sm),

            // Actions
            if (onFavorite != null)
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.accentColor : Colors.white54,
                ),
                onPressed: onFavorite,
                iconSize: 20,
              ),
            if (onMore != null)
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white54),
                onPressed: onMore,
                iconSize: 20,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
