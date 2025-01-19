import 'package:equatable/equatable.dart';

abstract class VideoDetailsEvent extends Equatable {
  const VideoDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ToggleLike extends VideoDetailsEvent {}

class ShareVideo extends VideoDetailsEvent {}

class DownloadVideo extends VideoDetailsEvent {}

class InitializeVideoPlayer extends VideoDetailsEvent {
  final String videoUrl;

  const InitializeVideoPlayer(this.videoUrl);

  @override
  List<Object?> get props => [videoUrl];
}

class PlayPauseVideo extends VideoDetailsEvent {}
