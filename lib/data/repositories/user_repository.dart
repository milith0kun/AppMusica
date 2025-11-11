import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../models/playback_history_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(UserService());
});

class UserRepository {
  final UserService _userService;

  UserRepository([UserService? userService])
      : _userService = userService ?? UserService();

  Future<UserModel> getProfile() async {
    return await _userService.getProfile();
  }

  Future<UserModel> updateProfile({
    String? fullName,
    String? profession,
    String? city,
    String? country,
  }) async {
    return await _userService.updateProfile(
      fullName: fullName,
      profession: profession,
      city: city,
      country: country,
    );
  }

  Future<UserModel> updatePreferences(UserPreferences preferences) async {
    return await _userService.updatePreferences(preferences);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _userService.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<SubscriptionInfo> getSubscription() async {
    return await _userService.getSubscription();
  }

  Future<List<PlaybackHistoryModel>> getHistory({
    int page = 1,
    int limit = 20,
  }) async {
    return await _userService.getHistory(page: page, limit: limit);
  }

  Future<void> logPlayback({
    required String songId,
    required int duration,
    required double percentageCompleted,
    String? source,
  }) async {
    await _userService.logPlayback(
      songId: songId,
      duration: duration,
      percentageCompleted: percentageCompleted,
      source: source,
    );
  }

  Future<void> deleteAccount() async {
    await _userService.deleteAccount();
  }
}
