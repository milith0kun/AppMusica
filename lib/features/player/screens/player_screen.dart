import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/audio_player_provider.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioPlayerProvider);
    final song = audioState.currentSong;

    if (song == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text('No hay canción reproduciéndose'),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          'Reproduciendo desde',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          audioState.playlist.isNotEmpty
                              ? 'Playlist'
                              : 'Canción',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        _showOptionsBottomSheet(context, ref, song);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Album Art
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Hero(
                  tag: 'cover_${song.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: song.coverUrl ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppTheme.cardColor,
                          child: const Icon(
                            Icons.music_note,
                            size: 120,
                            color: Colors.white54,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppTheme.cardColor,
                          child: const Icon(
                            Icons.music_note,
                            size: 120,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Song Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    Text(
                      song.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      song.artist,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 6,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                      ),
                      child: Slider(
                        value: audioState.position.inSeconds.toDouble(),
                        max: audioState.duration.inSeconds.toDouble() > 0
                            ? audioState.duration.inSeconds.toDouble()
                            : 1.0,
                        onChanged: (value) {
                          ref.read(audioPlayerProvider.notifier).seek(
                                Duration(seconds: value.toInt()),
                              );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(audioState.position),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            _formatDuration(audioState.duration),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Shuffle
                    IconButton(
                      icon: Icon(
                        Icons.shuffle,
                        color: audioState.shuffleMode
                            ? AppTheme.primaryColor
                            : Colors.white54,
                      ),
                      iconSize: 28,
                      onPressed: () {
                        ref.read(audioPlayerProvider.notifier).setShuffleMode(
                              !audioState.shuffleMode,
                            );
                      },
                    ),

                    // Previous
                    IconButton(
                      icon: const Icon(Icons.skip_previous),
                      iconSize: 40,
                      onPressed: audioState.currentIndex > 0
                          ? () {
                              ref.read(audioPlayerProvider.notifier).skipToPrevious();
                            }
                          : null,
                    ),

                    // Play/Pause
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppTheme.primaryGradient,
                      ),
                      child: IconButton(
                        icon: Icon(
                          audioState.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        iconSize: 48,
                        onPressed: () {
                          ref.read(audioPlayerProvider.notifier).togglePlayPause();
                        },
                      ),
                    ),

                    // Next
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      iconSize: 40,
                      onPressed: audioState.currentIndex <
                              audioState.playlist.length - 1
                          ? () {
                              ref.read(audioPlayerProvider.notifier).skipToNext();
                            }
                          : null,
                    ),

                    // Repeat
                    IconButton(
                      icon: Icon(
                        audioState.loopMode == LoopMode.one
                            ? Icons.repeat_one
                            : Icons.repeat,
                        color: audioState.loopMode != LoopMode.off
                            ? AppTheme.primaryColor
                            : Colors.white54,
                      ),
                      iconSize: 28,
                      onPressed: () {
                        final nextMode = audioState.loopMode == LoopMode.off
                            ? LoopMode.all
                            : audioState.loopMode == LoopMode.all
                                ? LoopMode.one
                                : LoopMode.off;
                        ref.read(audioPlayerProvider.notifier).setLoopMode(nextMode);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Queue Info
              if (audioState.playlist.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: InkWell(
                    onTap: () {
                      _showQueueBottomSheet(context, ref);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.queue_music, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Cola: ${audioState.playlist.length} canciones',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _showOptionsBottomSheet(
    BuildContext context,
    WidgetRef ref,
    dynamic song,
  ) {
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
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Añadir a favoritos'),
                onTap: () {
                  // Add to favorites
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Añadir a playlist'),
                onTap: () {
                  // Add to playlist
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Información de la canción'),
                onTap: () {
                  // Show song info
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartir'),
                onTap: () {
                  // Share
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQueueBottomSheet(BuildContext context, WidgetRef ref) {
    final audioState = ref.read(audioPlayerProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.lg),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      const Icon(Icons.queue_music),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Cola de reproducción',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: audioState.playlist.length,
                    itemBuilder: (context, index) {
                      final song = audioState.playlist[index];
                      final isCurrent = index == audioState.currentIndex;

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                          child: CachedNetworkImage(
                            imageUrl: song.coverUrl ?? '',
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 48,
                              height: 48,
                              color: AppTheme.cardColor,
                              child: const Icon(Icons.music_note, size: 24),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 48,
                              height: 48,
                              color: AppTheme.cardColor,
                              child: const Icon(Icons.music_note, size: 24),
                            ),
                          ),
                        ),
                        title: Text(
                          song.title,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isCurrent ? AppTheme.primaryColor : null,
                              ),
                        ),
                        subtitle: Text(song.artist),
                        trailing: isCurrent
                            ? const Icon(
                                Icons.volume_up,
                                color: AppTheme.primaryColor,
                              )
                            : null,
                        onTap: () {
                          ref.read(audioPlayerProvider.notifier).skipToIndex(index);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
