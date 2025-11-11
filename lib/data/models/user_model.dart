import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    required String fullName,
    required String profession,
    String? country,
    String? city,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'last_access') DateTime? lastAccess,
    @Default('active') String status,
    SubscriptionInfo? subscription,
    UserPreferences? preferences,
    @Default(false) bool professionalVerified,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class SubscriptionInfo with _$SubscriptionInfo {
  const factory SubscriptionInfo({
    required String plan, // 'monthly', 'annual', 'trial', 'none'
    required String status, // 'active', 'past_due', 'canceled', 'trialing'
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'next_billing_date') DateTime? nextBillingDate,
    @JsonKey(name: 'trial_ends_at') DateTime? trialEndsAt,
    String? stripeCustomerId,
    String? stripeSubscriptionId,
  }) = _SubscriptionInfo;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionInfoFromJson(json);
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    @Default('es') String language,
    @Default('256kbps') String audioQuality,
    @Default(true) bool autoplay,
    @Default(true) bool notificationsEnabled,
    @Default(true) bool historyEnabled,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}
