import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import 'package:youtube_clone/utile/ebcryption.dart';

class DownloadManager {
  final _storage = const FlutterSecureStorage();
  final _dio = dio.Dio();
  Future<String> getDownloadPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> downloadVideo({
    required String url,
    required String fileName,
    required Function(double) onProgress,
    required Function onComplete,
    required Function onError,
  }) async {
    try {
      final downloadPath = await getDownloadPath();
      final filePath = "$downloadPath/$fileName.encvid";

      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      final encryptedData = await EncryptionHelper.encryptFile(File(filePath));
      await File(filePath).writeAsBytes(encryptedData);

      onComplete();
    } catch (e) {
      onError(e);
    }
  }

  Future<List<File>> getDownloadedVideos() async {
    final downloadPath = await getDownloadPath();
    final dir = Directory(downloadPath);
    return dir
        .listSync()
        .where((file) => file.path.endsWith('.encvid'))
        .map((file) => File(file.path))
        .toList();
  }

  Future<void> deleteVideo(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
