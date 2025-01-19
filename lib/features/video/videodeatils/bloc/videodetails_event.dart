
import 'package:equatable/equatable.dart';

abstract class VideoDetailsEvent extends Equatable {
  const VideoDetailsEvent();

  @override
  List<Object> get props => [];
}

class InitializeVideoPlayer extends VideoDetailsEvent {
  final String videoUrl;

  const InitializeVideoPlayer(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}

class ToggleLike extends VideoDetailsEvent {}

class ShareVideo extends VideoDetailsEvent {}

class DownloadVideo extends VideoDetailsEvent {
  final String videoUrl;  // Define the videoUrl parameter

  const DownloadVideo({required this.videoUrl});

  @override
  List<Object> get props => [videoUrl];
}

class PlayPauseVideo extends VideoDetailsEvent {}
