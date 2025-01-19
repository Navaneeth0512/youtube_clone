import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  const VideoEvent();

  @override
  List<Object?> get props => [];
}

class SelectVideo extends VideoEvent {
  final Map<String, dynamic> video;

  const SelectVideo({required this.video});

  @override
  List<Object?> get props => [video];
}
