import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/playback_history_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../shared/widgets/song_card.dart';
import '../../../shared/providers/audio_player_provider.dart';
import 'package:intl/intl.dart';

final historyProvider = FutureProvider<List<PlaybackHistoryModel>>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  return await userRepo.getHistory(limit: 100);
});

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return historyAsync.when(
      data: (history) {
        if (history.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: AppTheme.textTertiaryColor,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Sin Historial',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Tu historial de reproducción\naparecerá aquí',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Group by date
        final groupedHistory = <String, List<PlaybackHistoryModel>>{};
        for (final item in history) {
          final dateKey = DateFormat('yyyy-MM-dd').format(item.playedAt);
          if (!groupedHistory.containsKey(dateKey)) {
            groupedHistory[dateKey] = [];
          }
          groupedHistory[dateKey]!.add(item);
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(historyProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: groupedHistory.length,
            itemBuilder: (context, index) {
              final dateKey = groupedHistory.keys.elementAt(index);
              final items = groupedHistory[dateKey]!;
              final date = DateTime.parse(dateKey);
              final dateLabel = _formatDateLabel(date);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                      horizontal: AppSpacing.sm,
                    ),
                    child: Text(
                      dateLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  ...items.map((item) {
                    if (item.song == null) return const SizedBox.shrink();

                    return Column(
                      children: [
                        SongCard(
                          song: item.song!,
                          onTap: () {
                            ref.read(audioPlayerProvider.notifier).playSong(
                                  item.song!,
                                );
                          },
                          onMore: () {
                            _showHistoryItemOptions(context, ref, item);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 72,
                            bottom: AppSpacing.xs,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: AppTheme.textTertiaryColor,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                DateFormat('HH:mm').format(item.playedAt),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textTertiaryColor,
                                    ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Icon(
                                Icons.play_circle_outline,
                                size: 12,
                                color: AppTheme.textTertiaryColor,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '${item.percentageCompleted.toInt()}% reproducido',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.textTertiaryColor,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: AppSpacing.lg),
                ],
              );
            },
          ),
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
                ref.invalidate(historyProvider);
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Hoy';
    } else if (dateOnly == yesterday) {
      return 'Ayer';
    } else if (now.difference(dateOnly).inDays < 7) {
      return DateFormat('EEEE', 'es').format(date);
    } else {
      return DateFormat('d \'de\' MMMM', 'es').format(date);
    }
  }

  void _showHistoryItemOptions(
    BuildContext context,
    WidgetRef ref,
    PlaybackHistoryModel item,
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
                leading: const Icon(Icons.play_arrow),
                title: const Text('Reproducir'),
                onTap: () {
                  Navigator.pop(context);
                  if (item.song != null) {
                    ref.read(audioPlayerProvider.notifier).playSong(item.song!);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Añadir a favoritos'),
                onTap: () {
                  Navigator.pop(context);
                  // Add to favorites
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Añadir a playlist'),
                onTap: () {
                  Navigator.pop(context);
                  // Add to playlist
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                title: const Text(
                  'Eliminar del historial',
                  style: TextStyle(color: AppTheme.errorColor),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Delete from history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Eliminado del historial'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
