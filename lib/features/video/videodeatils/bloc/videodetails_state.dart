import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsState extends Equatable {
  final bool isLiked;
  final bool isDownloading;
  final double downloadProgress;
  final bool isPlaying;
  final VideoPlayerController? controller;

  const VideoDetailsState({
    this.isLiked = false,
    this.isDownloading = false,
    this.downloadProgress = 0.0,
    this.isPlaying = false,
    this.controller,
  });

  VideoDetailsState copyWith({
    bool? isLiked,
    bool? isDownloading,
    double? downloadProgress,
    bool? isPlaying,
    VideoPlayerController? controller,
  }) {
    return VideoDetailsState(
      isLiked: isLiked ?? this.isLiked,
      isDownloading: isDownloading ?? this.isDownloading,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      isPlaying: isPlaying ?? this.isPlaying,
      controller: controller ?? this.controller,
    );
  }

  @override
  List<Object?> get props => [isLiked, isDownloading, downloadProgress, isPlaying, controller];
}
