import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/services/music_service.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../shared/widgets/playlist_card.dart';
import '../../../shared/providers/audio_player_provider.dart';

// Search provider with debounce
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<SearchResults?>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return null;

  final musicRepo = ref.watch(musicRepositoryProvider);
  await Future.delayed(const Duration(milliseconds: 300)); // Debounce
  return await musicRepo.search(query);
});

class SearchScreenImproved extends ConsumerStatefulWidget {
  const SearchScreenImproved({super.key});

  @override
  ConsumerState<SearchScreenImproved> createState() => _SearchScreenImprovedState();
}

class _SearchScreenImprovedState extends ConsumerState<SearchScreenImproved> {
  final _searchController = TextEditingController();
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim() != _lastQuery) {
      _lastQuery = query.trim();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (query.trim() == _lastQuery && mounted) {
          ref.read(searchQueryProvider.notifier).state = query.trim();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppStrings.searchMusic,
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        ref.read(searchQueryProvider.notifier).state = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _performSearch(value);
            });
          },
        ),
      ),
      body: _searchController.text.isEmpty
          ? _buildEmptyState()
          : _buildSearchResults(searchResults),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: AppTheme.textTertiaryColor,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Busca música terapéutica',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Encuentra canciones, playlists y álbumes\npor título, artista o categoría',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: [
              'Relajación',
              'Meditación',
              'EMDR',
              'Mindfulness',
              'Ansiedad',
            ].map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                backgroundColor: AppTheme.cardColor,
                onPressed: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AsyncValue<SearchResults?> searchResults) {
    return searchResults.when(
      data: (results) {
        if (results == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final hasSongs = results.songs.isNotEmpty;
        final hasPlaylists = results.playlists.isNotEmpty;
        final hasAlbums = results.albums.isNotEmpty;

        if (!hasSongs && !hasPlaylists && !hasAlbums) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppTheme.textTertiaryColor,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'No se encontraron resultados',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Intenta con otros términos de búsqueda',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Songs Section
            if (hasSongs) ...[
              Row(
                children: [
                  Text(
                    'Canciones',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(${results.songs.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...results.songs.take(5).map((song) => SongCard(
                    song: song,
                    onTap: () {
                      ref.read(audioPlayerProvider.notifier).playSong(
                            song,
                            queue: results.songs,
                          );
                    },
                    onFavorite: () {
                      // Toggle favorite
                    },
                  )),
              if (results.songs.length > 5)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: TextButton(
                    onPressed: () {
                      // Show all songs
                    },
                    child: Text('Ver todas (${results.songs.length})'),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Playlists Section
            if (hasPlaylists) ...[
              Row(
                children: [
                  Text(
                    'Playlists',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(${results.playlists.length})',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...results.playlists.take(3).map((playlist) => Padding(
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
              if (results.playlists.length > 3)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: TextButton(
                    onPressed: () {
                      // Show all playlists
                    },
                    child: Text('Ver todas (${results.playlists.length})'),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Albums Section
            if (hasAlbums) ...[
              Row(
                children: [
                  Text(
                    'Álbumes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '(${results.albums.length})',
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
                itemCount: results.albums.length > 4 ? 4 : results.albums.length,
                itemBuilder: (context, index) {
                  final album = results.albums[index];
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
                                : const Center(
                                    child: Icon(
                                      Icons.album,
                                      size: 48,
                                      color: Colors.white54,
                                    ),
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

            const SizedBox(height: 80), // Padding for mini-player
          ],
        );
      },
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
              onPressed: () {
                ref.invalidate(searchResultsProvider);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
