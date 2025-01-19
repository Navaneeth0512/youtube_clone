import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/features/video/videocard/bloc/videocard_bloc.dart';
import 'package:youtube_clone/features/video/videocard/bloc/videocard_event.dart';
import 'package:youtube_clone/features/video/videodeatils/videodetailscreen.dart';

class VideoCard extends StatelessWidget {
  final Map<String, dynamic> video;

  const VideoCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Ensure VideoBloc is available in the widget tree
        final videoBloc = context.read<VideoBloc>();

        if (videoBloc != null) {
          videoBloc.add(SelectVideo(video: video));
        }

        // Navigate to VideoDetailsScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoDetailsScreen(video: video),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              video['thumbnail'] ?? '', // Default to empty string if null
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${video['channel'] ?? 'Unknown Channel'} • "
                    "${video['views'] ?? '0 views'} • "
                    "${video['uploaded'] ?? 'Unknown time'}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
