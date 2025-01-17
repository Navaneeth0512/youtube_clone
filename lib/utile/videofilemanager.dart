import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class VideoFileManager {
  static Future<String> getDownloadsDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/videos';
  }

  static Future<File> saveVideo(Uint8List data, String fileName) async {
    final directory = await getDownloadsDirectory();
    final filePath = '$directory/$fileName';
    final file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return await file.writeAsBytes(data);
  }

  static Future<List<File>> getDownloadedVideos() async {
    final directory = await getDownloadsDirectory();
    final dir = Directory(directory);
    if (!await dir.exists()) {
      return [];
    }
    return dir.listSync().whereType<File>().toList();
  }

  static Future<void> deleteVideo(String fileName) async {
    final directory = await getDownloadsDirectory();
    final filePath = '$directory/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
