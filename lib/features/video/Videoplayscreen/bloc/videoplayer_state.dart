import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState extends Equatable {
  final VideoPlayerController? controller;
  final bool isPlaying;
  final bool isFullScreen;

  const VideoPlayerState({
    this.controller,
    this.isPlaying = false,
    this.isFullScreen = true,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? isPlaying,
    bool? isFullScreen,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullScreen: isFullScreen ?? this.isFullScreen,
    );
  }

  @override
  List<Object?> get props => [controller, isPlaying, isFullScreen];
}
