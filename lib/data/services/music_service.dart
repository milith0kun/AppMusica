import 'package:dio/dio.dart';
import '../../core/utils/api_client.dart';
import '../../core/constants/app_constants.dart';
import '../models/song_model.dart';
import '../models/album_model.dart';
import '../models/playlist_model.dart';
import '../models/category_model.dart';

class MusicService {
  final ApiClient _apiClient;

  MusicService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  // Songs
  Future<PaginatedResponse<SongModel>> getSongs({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? category,
    String? search,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/songs',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (category != null) 'category': category,
          if (search != null) 'search': search,
          if (sortBy != null) 'sortBy': sortBy,
          if (sortOrder != null) 'sortOrder': sortOrder,
        },
      );

      return PaginatedResponse<SongModel>.fromJson(
        response.data['data'],
        (json) => SongModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SongModel> getSongById(String songId) async {
    try {
      final response = await _apiClient.dio.get('/songs/$songId');
      return SongModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<StreamUrlResponse> getStreamUrl(String songId) async {
    try {
      final response = await _apiClient.dio.get('/songs/$songId/stream');
      return StreamUrlResponse.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Albums
  Future<PaginatedResponse<AlbumModel>> getAlbums({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? search,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/albums',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null) 'search': search,
        },
      );

      return PaginatedResponse<AlbumModel>.fromJson(
        response.data['data'],
        (json) => AlbumModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<AlbumModel> getAlbumById(String albumId) async {
    try {
      final response = await _apiClient.dio.get('/albums/$albumId');
      return AlbumModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Playlists
  Future<PaginatedResponse<PlaylistModel>> getPlaylists({
    int page = 1,
    int limit = AppConstants.defaultPageSize,
    String? type,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/playlists',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (type != null) 'type': type,
        },
      );

      return PaginatedResponse<PlaylistModel>.fromJson(
        response.data['data'],
        (json) => PlaylistModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    try {
      final response = await _apiClient.dio.get('/playlists/$playlistId');
      return PlaylistModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlaylistModel> createPlaylist({
    required String title,
    String? description,
    List<String>? songIds,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/playlists',
        data: {
          'title': title,
          if (description != null) 'description': description,
          if (songIds != null) 'songIds': songIds,
        },
      );

      return PlaylistModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlaylistModel> updatePlaylist(
    String playlistId, {
    String? title,
    String? description,
    List<String>? songIds,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/playlists/$playlistId',
        data: {
          if (title != null) 'title': title,
          if (description != null) 'description': description,
          if (songIds != null) 'songIds': songIds,
        },
      );

      return PlaylistModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deletePlaylist(String playlistId) async {
    try {
      await _apiClient.dio.delete('/playlists/$playlistId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Categories
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get('/categories');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PaginatedResponse<SongModel>> getSongsByCategory(
    String categoryId, {
    int page = 1,
    int limit = AppConstants.defaultPageSize,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/categories/$categoryId/songs',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return PaginatedResponse<SongModel>.fromJson(
        response.data['data'],
        (json) => SongModel.fromJson(json as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Search
  Future<SearchResults> search(
    String query, {
    String? type,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/search',
        queryParameters: {
          'q': query,
          if (type != null) 'type': type,
          'limit': limit,
        },
      );

      return SearchResults.fromJson(response.data['data']);
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

class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List?)
              ?.map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? AppConstants.defaultPageSize,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class SearchResults {
  final List<SongModel> songs;
  final List<PlaylistModel> playlists;
  final List<AlbumModel> albums;

  SearchResults({
    required this.songs,
    required this.playlists,
    required this.albums,
  });

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
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
