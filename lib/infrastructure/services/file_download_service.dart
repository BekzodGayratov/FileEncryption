import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/domain/downloaded_file_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:test/infrastructure/services/encryptoin_service.dart';

class DownloadFileService {
  Future<DownloadedFileModel?> downloadAndEncryptVideo(String videoUrl) async {
    final client = http.Client();
    final request = http.Request('GET', Uri.parse(videoUrl));
    final response = await client.send(request);

    if (response.statusCode == 200) {
      var appDocDir = await getApplicationDocumentsDirectory();
      final vname = path.basename(videoUrl);
      final videoFile = File("${appDocDir.path}/$vname");
      final sink = videoFile.openWrite();

      await for (var chunk in response.stream) {
        sink.add(chunk);
      }
      await sink.close();

      final bytes = await videoFile.readAsBytes();

      final encryptor = StreamEncryptor();

      final originalStream = Stream.value(bytes);

      final encryptedStream = encryptor.encryptStream(originalStream);

      final encryptedBytes = await encryptedStream.fold<Uint8List>(Uint8List(0),
          (previous, element) => Uint8List.fromList(previous + element));

      final directory = await getApplicationDocumentsDirectory();
      final videoFileName = path.basename(videoUrl);
      final encryptedFileName = videoFileName;
      final file = File('${directory.path}/$encryptedFileName');
      await file.writeAsBytes(encryptedBytes);
      Fluttertoast.showToast(msg: "VIDEO DOWNLOADED!");
      return await _storeDownloadedFilePaths(DownloadedFileModel(
          videoUrl: videoUrl, encryptedFilePath: file.path));
    }
  }

  Future<Database> _openDB({required int version}) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/video_files.db';
    return openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS downloaded_files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        videoUrl TEXT,
        encryptedFilePath TEXT
      )
    ''');
    });
  }

//   Future<Database> _openDB({required int version}) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = "${directory.path}/video_files.db";
//     return openDatabase(
//       path,
//       version: version,
//       onCreate: (db, version) async {
//         await db.execute('''
//   CREATE TABLE IF NOT EXISTS downloaded_files (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     videoUrl: TEXT,
//     encryptedFilePath TEXT
//   )
// ''');
//       },
//     );
//   }

  Future<DownloadedFileModel?> _storeDownloadedFilePaths(
      DownloadedFileModel downloadedFileModel) async {
    try {
      final db = await _openDB(version: 1);
      await db.insert("downloaded_files", {
        "videoUrl": downloadedFileModel.videoUrl,
        "encryptedFilePath": downloadedFileModel.encryptedFilePath
      });

      return downloadedFileModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<DownloadedFileModel?> getDecryptedFileModel(String videoUrl) async {
    final db = await _openDB(version: 1);
    var result = await db.query('downloaded_files',
        where: 'videoUrl = ?', whereArgs: [videoUrl]);
    if (result.isNotEmpty) {
      return DownloadedFileModel.fromJson(result[0]);
    } else {
      return null;
    }
  }
}
