import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'bloc/videoplayer_bloc.dart';
import 'bloc/videoplayer_event.dart';
import 'bloc/videoplayer_state.dart';

class VideoPlayerScreen extends StatelessWidget {
  final Map<String, dynamic> videoData;

  const VideoPlayerScreen({Key? key, required this.videoData, required File videoFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          VideoPlayerBloc()..add(InitializeVideoPlayer(videoData['videoUrl'])),
      child: Scaffold(
        appBar: AppBar(
          title: Text(videoData['title']),
        ),
        body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state.controller == null || !state.controller!.value.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Center(
              child: AspectRatio(
                aspectRatio: state.controller!.value.aspectRatio,
                child: VideoPlayer(state.controller!),
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            final bloc = context.read<VideoPlayerBloc>();
            return FloatingActionButton(
              onPressed: () => bloc.add(PlayPauseVideo()),
              child: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            final bloc = context.read<VideoPlayerBloc>();
            return !state.isFullScreen
                ? BottomAppBar(
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: () => bloc.add(ToggleFullScreen()),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
