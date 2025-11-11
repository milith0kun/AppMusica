import 'package:freezed_annotation/freezed_annotation.dart';

part 'song_model.freezed.dart';
part 'song_model.g.dart';

@freezed
class SongModel with _$SongModel {
  const factory SongModel({
    required String id,
    required String title,
    required String artist,
    String? album,
    @JsonKey(name: 'album_id') String? albumId,
    required int duration, // in seconds
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'waveform_url') String? waveformUrl,
    List<String>? categories,
    List<String>? tags,
    String? description,
    AudioMetadata? metadata,
    @JsonKey(name: 'play_count') @Default(0) int playCount,
    @Default(false) bool isFavorite,
  }) = _SongModel;

  factory SongModel.fromJson(Map<String, dynamic> json) =>
      _$SongModelFromJson(json);
}

@freezed
class AudioMetadata with _$AudioMetadata {
  const factory AudioMetadata({
    int? bpm, // beats per minute
    String? key, // musical key
    String? instrument,
    String? type, // 'instrumental', 'vocal', 'ambient', 'rhythmic'
    String? intensity, // 'low', 'medium', 'high'
  }) = _AudioMetadata;

  factory AudioMetadata.fromJson(Map<String, dynamic> json) =>
      _$AudioMetadataFromJson(json);
}

@freezed
class StreamUrlResponse with _$StreamUrlResponse {
  const factory StreamUrlResponse({
    @JsonKey(name: 'stream_url') required String streamUrl,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    required SongModel song,
  }) = _StreamUrlResponse;

  factory StreamUrlResponse.fromJson(Map<String, dynamic> json) =>
      _$StreamUrlResponseFromJson(json);
}
