import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/features/video/videodeatils/bloc/videodetails_bloc.dart';
import 'package:youtube_clone/features/video/videodeatils/bloc/videodetails_event.dart';
import 'package:youtube_clone/features/video/videodeatils/bloc/videodetails_state.dart';
import 'package:youtube_clone/widgets/expandable.dart';

class VideoDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoDetailsScreen({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VideoDetailsBloc()
        ..add(InitializeVideoPlayer(video['videoUrl'])),
      child: Scaffold(
        appBar: AppBar(title: Text(video['title'])),
        body: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
          builder: (context, state) {
            final bloc = context.read<VideoDetailsBloc>();
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Player
                  if (state.controller != null && state.controller!.value.isInitialized)
                    AspectRatio(
                      aspectRatio: state.controller!.value.aspectRatio,
                      child: VideoPlayer(state.controller!),
                    ),

                  // Video Title
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      video['title'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Video Details
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${video['views']} • ${video['uploaded']}"),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                state.isLiked
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color: state.isLiked ? Colors.blue : Colors.grey,
                              ),
                              onPressed: () => bloc.add(ToggleLike()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: () => bloc.add(ShareVideo()),
                            ),
                            IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: state.isDownloading
                                  ? null
                                  : () => bloc.add(DownloadVideo()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Download Progress Indicator
                  if (state.isDownloading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LinearProgressIndicator(value: state.downloadProgress),
                    ),

                  // Expandable Description
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ExpandableText(
                      text:
                          "This is an expandable description widget. It allows long text to be collapsed or expanded for better readability.",
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () => context.read<VideoDetailsBloc>().add(PlayPauseVideo()),
              child: Icon(
                state.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            );
          },
        ),
      ),
    );
  }
}
