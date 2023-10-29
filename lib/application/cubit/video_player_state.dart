part of 'video_player_cubit.dart';

@freezed
class VideoPlayerState with _$VideoPlayerState {
  const factory VideoPlayerState.initial() = _Initial;
  const factory VideoPlayerState.loading() = _Loading;
  const factory VideoPlayerState.error(String err) = _Error;
  const factory VideoPlayerState.completed(
      BetterPlayerController playerController) = _Completed;
}
