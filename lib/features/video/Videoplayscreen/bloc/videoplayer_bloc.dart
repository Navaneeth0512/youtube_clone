import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/features/video/Videoplayscreen/bloc/videoplayer_event.dart';
import 'package:youtube_clone/features/video/Videoplayscreen/bloc/videoplayer_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  VideoPlayerBloc() : super(const VideoPlayerState()) {
    on<InitializeVideoPlayer>(_onInitializeVideoPlayer);
    on<PlayPauseVideo>(_onPlayPauseVideo);
    on<ToggleFullScreen>(_onToggleFullScreen);
  }

  Future<void> _onInitializeVideoPlayer(
      InitializeVideoPlayer event, Emitter<VideoPlayerState> emit) async {
    final controller = VideoPlayerController.network(event.videoUrl);
    await controller.initialize();
    controller.play();
    emit(state.copyWith(controller: controller, isPlaying: true));
  }

  void _onPlayPauseVideo(PlayPauseVideo event, Emitter<VideoPlayerState> emit) {
    final controller = state.controller;
    if (controller != null) {
      if (controller.value.isPlaying) {
        controller.pause();
        emit(state.copyWith(isPlaying: false));
      } else {
        controller.play();
        emit(state.copyWith(isPlaying: true));
      }
    }
  }

  void _onToggleFullScreen(ToggleFullScreen event, Emitter<VideoPlayerState> emit) {
    emit(state.copyWith(isFullScreen: !state.isFullScreen));
  }

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}
