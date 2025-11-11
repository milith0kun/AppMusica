import 'package:freezed_annotation/freezed_annotation.dart';
import 'song_model.dart';

part 'playlist_model.freezed.dart';
part 'playlist_model.g.dart';

@freezed
class PlaylistModel with _$PlaylistModel {
  const factory PlaylistModel({
    required String id,
    required String title,
    String? description,
    @JsonKey(name: 'cover_url') String? coverUrl,
    required String type, // 'curated', 'user', 'featured'
    @JsonKey(name: 'creator_id') String? creatorId,
    @JsonKey(name: 'creator_name') String? creatorName,
    @Default([]) List<SongModel> songs,
    @JsonKey(name: 'song_count') @Default(0) int songCount,
    @JsonKey(name: 'total_duration') @Default(0) int totalDuration, // in seconds
    @Default(false) bool isPublic,
    @Default(false) bool isFeatured,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PlaylistModel;

  factory PlaylistModel.fromJson(Map<String, dynamic> json) =>
      _$PlaylistModelFromJson(json);
}
