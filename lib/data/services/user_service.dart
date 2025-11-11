import 'package:dio/dio.dart';
import '../../core/utils/api_client.dart';
import '../models/user_model.dart';
import '../models/playback_history_model.dart';

class UserService {
  final ApiClient _apiClient;

  UserService({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  Future<UserModel> getProfile() async {
    try {
      final response = await _apiClient.dio.get('/users/profile');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? profession,
    String? city,
    String? country,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/users/profile',
        data: {
          if (fullName != null) 'fullName': fullName,
          if (profession != null) 'profession': profession,
          if (city != null) 'city': city,
          if (country != null) 'country': country,
        },
      );

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updatePreferences(UserPreferences preferences) async {
    try {
      final response = await _apiClient.dio.put(
        '/users/preferences',
        data: preferences.toJson(),
      );

      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.dio.post(
        '/users/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<SubscriptionInfo> getSubscription() async {
    try {
      final response = await _apiClient.dio.get('/users/subscription');
      return SubscriptionInfo.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<PlaybackHistoryModel>> getHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/history',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data = response.data['data']['items'];
      return data.map((json) => PlaybackHistoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> logPlayback({
    required String songId,
    required int duration,
    required double percentageCompleted,
    String? source,
  }) async {
    try {
      await _apiClient.dio.post(
        '/history/log',
        data: {
          'songId': songId,
          'duration': duration,
          'percentageCompleted': percentageCompleted,
          if (source != null) 'source': source,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _apiClient.dio.delete('/users/account');
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
