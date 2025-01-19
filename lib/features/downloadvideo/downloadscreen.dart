import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_clone/features/downloadvideo/downloadmanager.dart';
import 'package:youtube_clone/features/video/Videoplayscreen/video_player_screen.dart';
import 'package:youtube_clone/utile/ebcryption.dart';

class DownloadScreen extends StatefulWidget {
  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  late Future<List<File>> _downloadedVideos;
  final DownloadManager _downloadManager = DownloadManager();

  @override
  void initState() {
    super.initState();
    _refreshDownloads();
  }

  void _refreshDownloads() {
    setState(() {
      _downloadedVideos = _downloadManager.getDownloadedVideos();
    });
  }

  void _playVideo(File videoFile) async {
    try {
      final decryptedData = await EncryptionHelper.decryptFile(videoFile);
      final tempDir = await _downloadManager.getDownloadPath();
      final tempFile = File("$tempDir/temp.mp4");
      await tempFile.writeAsBytes(decryptedData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(videoFile: tempFile, videoData: {},),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error playing video: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Downloads")),
      body: FutureBuilder<List<File>>(
        future: _downloadedVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Failed to load downloads."));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No downloads found."));
          }
          final videos = snapshot.data!;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return ListTile(
                title: Text(video.path.split('/').last),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await _downloadManager.deleteVideo(video.path);
                    _refreshDownloads();
                  },
                ),
                onTap: () => _playVideo(video),
              );
            },
          );
        },
      ),
    );
  }
}
