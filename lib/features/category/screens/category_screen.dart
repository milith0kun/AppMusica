import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/song_model.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../shared/providers/audio_player_provider.dart';

final categorySongsProvider = FutureProvider.family<List<SongModel>, String>(
  (ref, categoryId) async {
    final musicRepo = ref.watch(musicRepositoryProvider);
    final result = await musicRepo.getSongsByCategory(
      categoryId,
      limit: AppConstants.maxPageSize,
    );
    return result.items;
  },
);

class CategoryScreen extends ConsumerStatefulWidget {
  final CategoryModel category;

  const CategoryScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  String _sortBy = 'title';
  bool _isGridView = false;

  @override
  Widget build(BuildContext context) {
    final songsAsync = ref.watch(categorySongsProvider(widget.category.id));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
                onPressed: () {
                  setState(() {
                    _isGridView = !_isGridView;
                  });
                },
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                onSelected: (value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'title',
                    child: Text('Título A-Z'),
                  ),
                  const PopupMenuItem(
                    value: 'popularity',
                    child: Text('Más populares'),
                  ),
                  const PopupMenuItem(
                    value: 'duration',
                    child: Text('Duración'),
                  ),
                ],
              ),
            ],
          ),

          // Description
          if (widget.category.description != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  widget.category.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                ),
              ),
            ),

          // Songs Count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Text(
                    '${widget.category.songCount} canciones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      songsAsync.whenData((songs) {
                        if (songs.isNotEmpty) {
                          ref
                              .read(audioPlayerProvider.notifier)
                              .playPlaylist(songs);
                        }
                      });
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Reproducir Todo'),
                  ),
                ],
              ),
            ),
          ),

          // Songs Content
          songsAsync.when(
            data: (songs) {
              if (songs.isEmpty) {
                return const SliverFillRemaining(
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
                        Text('No hay canciones en esta categoría'),
                      ],
                    ),
                  ),
                );
              }

              // Sort songs
              final sortedSongs = List<SongModel>.from(songs);
              switch (_sortBy) {
                case 'title':
                  sortedSongs.sort((a, b) => a.title.compareTo(b.title));
                  break;
                case 'popularity':
                  sortedSongs.sort((a, b) => b.playCount.compareTo(a.playCount));
                  break;
                case 'duration':
                  sortedSongs.sort((a, b) => a.duration.compareTo(b.duration));
                  break;
              }

              if (_isGridView) {
                return SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 0.7,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final song = sortedSongs[index];
                        return _buildGridSongCard(context, ref, song);
                      },
                      childCount: sortedSongs.length,
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final song = sortedSongs[index];
                      return SongCard(
                        song: song,
                        onTap: () {
                          ref.read(audioPlayerProvider.notifier).playSong(
                                song,
                                queue: sortedSongs,
                              );
                        },
                        onFavorite: () {
                          // Toggle favorite
                        },
                      );
                    },
                    childCount: sortedSongs.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.errorColor,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Error: $error'),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(categorySongsProvider(widget.category.id));
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
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

  Widget _buildGridSongCard(BuildContext context, WidgetRef ref, SongModel song) {
    return InkWell(
      onTap: () {
        ref.read(audioPlayerProvider.notifier).playSong(song);
      },
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              child: Container(
                color: AppTheme.cardColor,
                child: song.coverUrl != null
                    ? Image.network(
                        song.coverUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : const Icon(
                        Icons.music_note,
                        size: 48,
                        color: Colors.white54,
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Title
          Text(
            song.title,
            style: Theme.of(context).textTheme.titleSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Artist
          Text(
            song.artist,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
