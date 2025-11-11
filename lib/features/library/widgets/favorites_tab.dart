import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/favorites_provider.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../shared/widgets/playlist_card.dart';
import '../../../shared/providers/audio_player_provider.dart';

class FavoritesTab extends ConsumerWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoritesProvider);

    if (favoritesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (favoritesState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
            const SizedBox(height: AppSpacing.md),
            Text('Error: ${favoritesState.error}'),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () {
                ref.read(favoritesProvider.notifier).loadFavorites();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final songs = favoritesState.songs;
    final playlists = favoritesState.playlists;
    final albums = favoritesState.albums;

    final totalItems = songs.length + playlists.length + albums.length;

    if (totalItems == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppTheme.textTertiaryColor,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Sin Favoritos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Añade canciones, playlists o álbumes\na tus favoritos',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(favoritesProvider.notifier).loadFavorites();
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Songs Section
          if (songs.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Canciones',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${songs.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    if (songs.isNotEmpty) {
                      ref.read(audioPlayerProvider.notifier).playPlaylist(songs);
                    }
                  },
                  icon: const Icon(Icons.play_arrow, size: 20),
                  label: const Text('Reproducir'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...songs.map((song) => SongCard(
                  song: song,
                  onTap: () {
                    ref.read(audioPlayerProvider.notifier).playSong(
                          song,
                          queue: songs,
                        );
                  },
                  onFavorite: () async {
                    try {
                      await ref
                          .read(favoritesProvider.notifier)
                          .toggleSongFavorite(song);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Eliminado de favoritos'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: AppTheme.errorColor,
                          ),
                        );
                      }
                    }
                  },
                  isFavorite: true,
                )),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Playlists Section
          if (playlists.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Playlists',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${playlists.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...playlists.map((playlist) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: PlaylistCard(
                    playlist: playlist,
                    isHorizontal: true,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/playlist',
                        arguments: playlist,
                      );
                    },
                  ),
                )),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Albums Section
          if (albums.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  'Álbumes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '(${albums.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.75,
              ),
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/album',
                      arguments: album,
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppTheme.cardColor,
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: album.coverUrl != null
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(AppBorderRadius.md),
                                  child: Image.network(
                                    album.coverUrl!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.album,
                                  size: 48,
                                  color: Colors.white54,
                                ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        album.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        album.artist,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 80), // Bottom padding for mini-player
        ],
      ),
    );
  }
}
