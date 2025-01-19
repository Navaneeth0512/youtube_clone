import 'package:equatable/equatable.dart';

class VideoState extends Equatable {
  final Map<String, dynamic>? selectedVideo;

  const VideoState({this.selectedVideo});

  @override
  List<Object?> get props => [selectedVideo ?? {}];
}
