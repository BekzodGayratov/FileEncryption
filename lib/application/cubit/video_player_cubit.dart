import 'package:better_player/better_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test/infrastructure/services/video_player_service.dart';
part 'video_player_state.dart';
part 'video_player_cubit.freezed.dart';

class VideoPlayerCubit extends Cubit<VideoPlayerState> {
  VideoPlayerCubit(
      {required String videoUrl, required String coverImg, bool? autoDispose})
      : super(const VideoPlayerState.initial()) {
    initializeVideoPlayer(videoUrl: videoUrl, coverImg: coverImg);
  }
  final CoursePreviewVideoPlayerServce _coursePreviewVideoPlayerServce =
      CoursePreviewVideoPlayerServce();

  void initializeVideoPlayer(
      {required String? videoUrl,
      required String coverImg,
      bool? autoDispose}) async {
    if (videoUrl == null) {
      emit(const _Error("Video url does not provided"));
      return;
    } else {
      emit(const _Loading());
      await _coursePreviewVideoPlayerServce.initializePlayer(
          videoUrl: videoUrl, coverImg: coverImg);
      emit(_Completed(_coursePreviewVideoPlayerServce.playerController!));
    }
  }
}
