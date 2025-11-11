import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/favorites_service.dart';
import '../../data/models/song_model.dart';
import '../../data/models/playlist_model.dart';
import '../../data/models/album_model.dart';

// Favorites State
class FavoritesState {
  final List<SongModel> songs;
  final List<PlaylistModel> playlists;
  final List<AlbumModel> albums;
  final bool isLoading;
  final String? error;

  const FavoritesState({
    this.songs = const [],
    this.playlists = const [],
    this.albums = const [],
    this.isLoading = false,
    this.error,
  });

  FavoritesState copyWith({
    List<SongModel>? songs,
    List<PlaylistModel>? playlists,
    List<AlbumModel>? albums,
    bool? isLoading,
    String? error,
  }) {
    return FavoritesState(
      songs: songs ?? this.songs,
      playlists: playlists ?? this.playlists,
      albums: albums ?? this.albums,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool isSongFavorite(String songId) {
    return songs.any((song) => song.id == songId);
  }

  bool isPlaylistFavorite(String playlistId) {
    return playlists.any((playlist) => playlist.id == playlistId);
  }

  bool isAlbumFavorite(String albumId) {
    return albums.any((album) => album.id == albumId);
  }
}

// Favorites Notifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesService _favoritesService;

  FavoritesNotifier(this._favoritesService) : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final data = await _favoritesService.getFavorites();
      state = state.copyWith(
        songs: data.songs,
        playlists: data.playlists,
        albums: data.albums,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleSongFavorite(SongModel song) async {
    final isFavorite = state.isSongFavorite(song.id);

    // Optimistic update
    if (isFavorite) {
      state = state.copyWith(
        songs: state.songs.where((s) => s.id != song.id).toList(),
      );
    } else {
      state = state.copyWith(
        songs: [...state.songs, song],
      );
    }

    try {
      if (isFavorite) {
        // Find and remove from server
        await _favoritesService.removeFromFavorites(song.id);
      } else {
        await _favoritesService.addToFavorites(
          type: 'song',
          itemId: song.id,
        );
      }
    } catch (e) {
      // Revert on error
      if (isFavorite) {
        state = state.copyWith(
          songs: [...state.songs, song],
        );
      } else {
        state = state.copyWith(
          songs: state.songs.where((s) => s.id != song.id).toList(),
        );
      }
      rethrow;
    }
  }

  Future<void> togglePlaylistFavorite(PlaylistModel playlist) async {
    final isFavorite = state.isPlaylistFavorite(playlist.id);

    // Optimistic update
    if (isFavorite) {
      state = state.copyWith(
        playlists: state.playlists.where((p) => p.id != playlist.id).toList(),
      );
    } else {
      state = state.copyWith(
        playlists: [...state.playlists, playlist],
      );
    }

    try {
      if (isFavorite) {
        await _favoritesService.removeFromFavorites(playlist.id);
      } else {
        await _favoritesService.addToFavorites(
          type: 'playlist',
          itemId: playlist.id,
        );
      }
    } catch (e) {
      // Revert on error
      if (isFavorite) {
        state = state.copyWith(
          playlists: [...state.playlists, playlist],
        );
      } else {
        state = state.copyWith(
          playlists: state.playlists.where((p) => p.id != playlist.id).toList(),
        );
      }
      rethrow;
    }
  }

  Future<void> toggleAlbumFavorite(AlbumModel album) async {
    final isFavorite = state.isAlbumFavorite(album.id);

    // Optimistic update
    if (isFavorite) {
      state = state.copyWith(
        albums: state.albums.where((a) => a.id != album.id).toList(),
      );
    } else {
      state = state.copyWith(
        albums: [...state.albums, album],
      );
    }

    try {
      if (isFavorite) {
        await _favoritesService.removeFromFavorites(album.id);
      } else {
        await _favoritesService.addToFavorites(
          type: 'album',
          itemId: album.id,
        );
      }
    } catch (e) {
      // Revert on error
      if (isFavorite) {
        state = state.copyWith(
          albums: [...state.albums, album],
        );
      } else {
        state = state.copyWith(
          albums: state.albums.where((a) => a.id != album.id).toList(),
        );
      }
      rethrow;
    }
  }
}

// Provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>(
  (ref) => FavoritesNotifier(FavoritesService()),
);
