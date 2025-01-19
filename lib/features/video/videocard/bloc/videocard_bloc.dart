import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/features/video/videocard/bloc/videocard_event.dart';
import 'package:youtube_clone/features/video/videocard/bloc/videocard_state.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(const VideoState()) {
    on<SelectVideo>(_onSelectVideo);
  }

  void _onSelectVideo(SelectVideo event, Emitter<VideoState> emit) {
    emit(VideoState(selectedVideo: event.video));
  }
}
