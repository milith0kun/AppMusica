import 'package:freezed_annotation/freezed_annotation.dart';
import 'song_model.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    required String id,
    required String title,
    String? description,
    required String artist,
    int? year,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @Default([]) List<SongModel> songs,
    @JsonKey(name: 'song_count') @Default(0) int songCount,
    @JsonKey(name: 'total_duration') @Default(0) int totalDuration, // in seconds
    List<String>? categories,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}
