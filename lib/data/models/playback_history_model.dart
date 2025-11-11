import 'package:freezed_annotation/freezed_annotation.dart';
import 'song_model.dart';

part 'playback_history_model.freezed.dart';
part 'playback_history_model.g.dart';

@freezed
class PlaybackHistoryModel with _$PlaybackHistoryModel {
  const factory PlaybackHistoryModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'song_id') required String songId,
    SongModel? song,
    @JsonKey(name: 'played_at') required DateTime playedAt,
    @JsonKey(name: 'duration_played') required int durationPlayed, // in seconds
    @JsonKey(name: 'percentage_completed') @Default(0.0) double percentageCompleted,
    String? source, // 'search', 'playlist', 'album', 'recommendation'
  }) = _PlaybackHistoryModel;

  factory PlaybackHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$PlaybackHistoryModelFromJson(json);
}
