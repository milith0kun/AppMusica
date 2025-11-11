import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/music_service.dart';
import '../models/song_model.dart';
import '../models/album_model.dart';
import '../models/playlist_model.dart';
import '../models/category_model.dart';

final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepository(MusicService());
});

class MusicRepository {
  final MusicService _musicService;

  MusicRepository(this._musicService);

  Future<PaginatedResponse<SongModel>> getSongs({
    int page = 1,
    int limit = 20,
    String? category,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    return await _musicService.getSongs(
      page: page,
      limit: limit,
      category: category,
      search: search,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  Future<SongModel> getSongById(String songId) async {
    return await _musicService.getSongById(songId);
  }

  Future<StreamUrlResponse> getStreamUrl(String songId) async {
    return await _musicService.getStreamUrl(songId);
  }

  Future<PaginatedResponse<AlbumModel>> getAlbums({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    return await _musicService.getAlbums(
      page: page,
      limit: limit,
      search: search,
    );
  }

  Future<AlbumModel> getAlbumById(String albumId) async {
    return await _musicService.getAlbumById(albumId);
  }

  Future<PaginatedResponse<PlaylistModel>> getPlaylists({
    int page = 1,
    int limit = 20,
    String? type,
  }) async {
    return await _musicService.getPlaylists(
      page: page,
      limit: limit,
      type: type,
    );
  }

  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    return await _musicService.getPlaylistById(playlistId);
  }

  Future<PlaylistModel> createPlaylist({
    required String title,
    String? description,
    List<String>? songIds,
  }) async {
    return await _musicService.createPlaylist(
      title: title,
      description: description,
      songIds: songIds,
    );
  }

  Future<PlaylistModel> updatePlaylist(
    String playlistId, {
    String? title,
    String? description,
    List<String>? songIds,
  }) async {
    return await _musicService.updatePlaylist(
      playlistId,
      title: title,
      description: description,
      songIds: songIds,
    );
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _musicService.deletePlaylist(playlistId);
  }

  Future<List<CategoryModel>> getCategories() async {
    return await _musicService.getCategories();
  }

  Future<PaginatedResponse<SongModel>> getSongsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    return await _musicService.getSongsByCategory(
      categoryId,
      page: page,
      limit: limit,
    );
  }

  Future<SearchResults> search(String query, {String? type, int limit = 20}) async {
    return await _musicService.search(query, type: type, limit: limit);
  }
}
