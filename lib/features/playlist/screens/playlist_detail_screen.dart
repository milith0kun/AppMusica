import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/playlist_model.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../shared/providers/audio_player_provider.dart';

final playlistDetailProvider = FutureProvider.family<PlaylistModel, String>(
  (ref, playlistId) async {
    final musicRepo = ref.watch(musicRepositoryProvider);
    return await musicRepo.getPlaylistById(playlistId);
  },
);

class PlaylistDetailScreen extends ConsumerWidget {
  final PlaylistModel? playlist;
  final String? playlistId;

  const PlaylistDetailScreen({
    super.key,
    this.playlist,
    this.playlistId,
  }) : assert(playlist != null || playlistId != null);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (playlist != null) {
      return _buildContent(context, ref, playlist!);
    }

    final playlistAsync = ref.watch(playlistDetailProvider(playlistId!));

    return Scaffold(
      body: playlistAsync.when(
        data: (playlist) => _buildContent(context, ref, playlist),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
              const SizedBox(height: AppSpacing.md),
              Text('Error: $error'),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton(
                onPressed: () => ref.invalidate(playlistDetailProvider(playlistId!)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, PlaylistModel playlist) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Cover
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: playlist.coverUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.cardColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.cardColor,
                      child: const Icon(
                        Icons.queue_music,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.backgroundColor.withOpacity(0.8),
                          AppTheme.backgroundColor,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Playlist Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    playlist.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppBorderRadius.circular),
                    ),
                    child: Text(
                      playlist.type == 'curated'
                          ? 'Curada por Expertos'
                          : playlist.type == 'featured'
                              ? 'Destacada'
                              : 'Playlist Personal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  if (playlist.description != null) ...[
                    Text(
                      playlist.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Stats
                  Row(
                    children: [
                      Icon(
                        Icons.music_note,
                        size: 16,
                        color: AppTheme.textTertiaryColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${playlist.songCount} canciones',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textTertiaryColor,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _formatDuration(playlist.totalDuration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: playlist.songs.isEmpty
                              ? null
                              : () {
                                  ref
                                      .read(audioPlayerProvider.notifier)
                                      .playPlaylist(playlist.songs);
                                },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Reproducir Todo'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      IconButton.filled(
                        onPressed: () {
                          // Toggle favorite
                        },
                        icon: const Icon(Icons.favorite_border),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.cardColor,
                        ),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          _showOptionsBottomSheet(context, playlist);
                        },
                        icon: const Icon(Icons.more_vert),
                        style: IconButton.styleFrom(
                          backgroundColor: AppTheme.cardColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Songs List
          if (playlist.songs.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.music_note,
                      size: 64,
                      color: AppTheme.textTertiaryColor,
                    ),
                    SizedBox(height: AppSpacing.md),
                    Text('No hay canciones en esta playlist'),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final song = playlist.songs[index];
                    return SongCard(
                      song: song,
                      onTap: () {
                        ref.read(audioPlayerProvider.notifier).playSong(
                              song,
                              queue: playlist.songs,
                            );
                      },
                      onFavorite: () {
                        // Toggle favorite
                      },
                      onMore: () {
                        // Show song options
                      },
                    );
                  },
                  childCount: playlist.songs.length,
                ),
              ),
            ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    }
    return '${minutes}min';
  }

  void _showOptionsBottomSheet(BuildContext context, PlaylistModel playlist) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (playlist.type == 'user') ...[
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Editar playlist'),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to edit
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: AppTheme.errorColor),
                  title: const Text(
                    'Eliminar playlist',
                    style: TextStyle(color: AppTheme.errorColor),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, playlist);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir'),
                onTap: () {
                  Navigator.pop(context);
                  // Share
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, PlaylistModel playlist) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Playlist'),
        content: Text('¿Estás seguro de eliminar "${playlist.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Delete playlist
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
