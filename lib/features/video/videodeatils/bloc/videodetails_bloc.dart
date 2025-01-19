import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/features/video/videodeatils/bloc/videodetails_event.dart';
import 'package:youtube_clone/features/video/videodeatils/bloc/videodetails_state.dart';

class VideoDetailsBloc extends Bloc<VideoDetailsEvent, VideoDetailsState> {
  VideoDetailsBloc() : super(const VideoDetailsState()) {
    on<ToggleLike>(_onToggleLike);
    on<ShareVideo>(_onShareVideo);
    on<DownloadVideo>(_onDownloadVideo);
    on<InitializeVideoPlayer>(_onInitializeVideoPlayer);
    on<PlayPauseVideo>(_onPlayPauseVideo);
  }

  void _onToggleLike(ToggleLike event, Emitter<VideoDetailsState> emit) {
    emit(state.copyWith(isLiked: !state.isLiked));
  }

  void _onShareVideo(ShareVideo event, Emitter<VideoDetailsState> emit) {
    Share.share("Check out this video: ${state.controller?.dataSource}");
  }

  Future<void> _onDownloadVideo(
      DownloadVideo event, Emitter<VideoDetailsState> emit) async {
    emit(state.copyWith(isDownloading: true, downloadProgress: 0.0));

    try {
      // Simulate download
      for (double progress = 0; progress <= 1; progress += 0.1) {
        await Future.delayed(const Duration(milliseconds: 500));
        emit(state.copyWith(downloadProgress: progress));
      }
      emit(state.copyWith(isDownloading: false));
    } catch (_) {
      emit(state.copyWith(isDownloading: false));
    }
  }

  void _onInitializeVideoPlayer(
      InitializeVideoPlayer event, Emitter<VideoDetailsState> emit) async {
    final controller = VideoPlayerController.network(event.videoUrl);
    await controller.initialize();
    controller.play();
    emit(state.copyWith(controller: controller, isPlaying: true));
  }

  void _onPlayPauseVideo(PlayPauseVideo event, Emitter<VideoDetailsState> emit) {
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

  @override
  Future<void> close() {
    state.controller?.dispose();
    return super.close();
  }
}
