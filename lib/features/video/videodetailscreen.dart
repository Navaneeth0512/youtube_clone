import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/utile/downloadmanager.dart';
import 'package:youtube_clone/widgets/expandable.dart';

class VideoDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> video;

  const VideoDetailsScreen({Key? key, required this.video}) : super(key: key);

  @override
  _VideoDetailsScreenState createState() => _VideoDetailsScreenState();
}

class _VideoDetailsScreenState extends State<VideoDetailsScreen> {
  late VideoPlayerController _controller;
  bool _isLiked = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.video['videoUrl'])
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _shareVideo() {
    Share.share("Check out this video: ${widget.video['videoUrl']}");
  }

  Future<void> _downloadVideo() async {
    setState(() {
      _isDownloading = true;
    });

    final downloadManager = DownloadManager();
    final fileName = widget.video['title'].replaceAll(' ', '_');

    try {
      await downloadManager.downloadVideo(
        url: widget.video['videoUrl'],
        fileName: fileName,
        onProgress: (progress) {
          setState(() {
            _downloadProgress = progress;
          });
        },
        onComplete: () {
          setState(() {
            _isDownloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Download complete!")),
          );
        },
        onError: (error) {
          setState(() {
            _isDownloading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download failed: $error")),
          );
        },
      );
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.video['title'])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),

            // Video Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.video['title'],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Video Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${widget.video['views']} • ${widget.video['uploaded']}"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: _isLiked ? Colors.blue : Colors.grey,
                        ),
                        onPressed: _toggleLike,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: _shareVideo,
                      ),
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: _isDownloading ? null : _downloadVideo,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Download Progress Indicator
            if (_isDownloading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: LinearProgressIndicator(value: _downloadProgress),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
