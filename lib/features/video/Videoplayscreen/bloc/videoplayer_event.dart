import 'package:equatable/equatable.dart';

abstract class VideoPlayerEvent extends Equatable {
  const VideoPlayerEvent();

  @override
  List<Object?> get props => [];
}

class InitializeVideoPlayer extends VideoPlayerEvent {
  final String videoUrl;

  const InitializeVideoPlayer(this.videoUrl);

  @override
  List<Object?> get props => [videoUrl];
}

class PlayPauseVideo extends VideoPlayerEvent {}

class ToggleFullScreen extends VideoPlayerEvent {}
