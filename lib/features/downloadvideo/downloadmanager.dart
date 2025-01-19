import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clone/utile/ebcryption.dart';

class DownloadManager {
  final _dio = dio.Dio();

  // Get the download path from app's documents directory
  Future<String> getDownloadPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Download a video and encrypt it
  Future<void> downloadVideo({
    required String url,
    required String fileName,
    required Function(double) onProgress,
    required Function onComplete,
    required Function onError,
  }) async {
    try {
      final downloadPath = await getDownloadPath();
      final filePath = "$downloadPath/$fileName.encvid";  // Ensure file is saved with .encvid extension

      // Download the video
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );
      print("Video downloaded to: $filePath");

      // Encrypt the video file
      final encryptedData = await EncryptionHelper.encryptFile(File(filePath));
      await File(filePath).writeAsBytes(encryptedData);
      print("Video encrypted and saved.");

      onComplete();  // Notify that download is complete
    } catch (e) {
      onError(e);  // Handle errors
    }
  }

  // Get list of downloaded and encrypted videos
  Future<List<File>> getDownloadedVideos() async {
    final downloadPath = await getDownloadPath();
    final dir = Directory(downloadPath);

    return dir
        .listSync()
        .where((file) => file.path.endsWith('.encvid'))  // Ensure we fetch .encvid files
        .map((file) => File(file.path))
        .toList();
  }

  // Delete a downloaded video
  Future<void> deleteVideo(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
