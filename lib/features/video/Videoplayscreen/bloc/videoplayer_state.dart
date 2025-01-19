import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerState extends Equatable {
  final VideoPlayerController? controller;
  final bool isPlaying;
  final bool isFullScreen;
  final String? error; // New property for error messages

  const VideoPlayerState({
    this.controller,
    this.isPlaying = false,
    this.isFullScreen = true,
    this.error, // Initialize error property
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? isPlaying,
    bool? isFullScreen,
    String? error, // Include error in copyWith
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      isPlaying: isPlaying ?? this.isPlaying,
      isFullScreen: isFullScreen ?? this.isFullScreen,
      error: error ?? this.error, // Update error property
    );
  }

  @override
  List<Object?> get props => [controller, isPlaying, isFullScreen, error];
}
