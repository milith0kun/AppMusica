import 'package:dio/dio.dart';
import '../../core/utils/api_client.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart';
import '../models/album_model.dart';

class FavoritesService {
  final ApiClient _apiClient;

  FavoritesService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<FavoritesData> getFavorites({String? type}) async {
    try {
      final response = await _apiClient.dio.get(
        '/favorites',
        queryParameters: {
          if (type != null) 'type': type,
        },
      );

      return FavoritesData.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> addToFavorites({
    required String type,
    required String itemId,
  }) async {
    try {
      await _apiClient.dio.post(
        '/favorites',
        data: {
          'type': type,
          'itemId': itemId,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeFromFavorites(String favoriteId) async {
    try {
      await _apiClient.dio.delete('/favorites/$favoriteId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> isFavorite({
    required String type,
    required String itemId,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/favorites/check/$type/$itemId',
      );

      return response.data['data']['isFavorite'] ?? false;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final message = error.response?.data['message'] ?? 'Error desconocido';
      return message;
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Tiempo de espera agotado';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Error de conexión. Verifica tu internet.';
    } else {
      return 'Error desconocido';
    }
  }
}

class FavoritesData {
  final List<SongModel> songs;
  final List<PlaylistModel> playlists;
  final List<AlbumModel> albums;

  FavoritesData({
    required this.songs,
    required this.playlists,
    required this.albums,
  });

  factory FavoritesData.fromJson(Map<String, dynamic> json) {
    return FavoritesData(
      songs: (json['songs'] as List?)
              ?.map((item) => SongModel.fromJson(item))
              .toList() ??
          [],
      playlists: (json['playlists'] as List?)
              ?.map((item) => PlaylistModel.fromJson(item))
              .toList() ??
          [],
      albums: (json['albums'] as List?)
              ?.map((item) => AlbumModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}
