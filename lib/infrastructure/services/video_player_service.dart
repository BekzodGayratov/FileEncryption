import 'dart:io';
import 'dart:typed_data';

import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test/infrastructure/services/encryptoin_service.dart';
import 'package:test/infrastructure/services/file_download_service.dart';

class CoursePreviewVideoPlayerServce {
  BetterPlayerDataSource? _betterPlayerDataSource;
  BetterPlayerController? _betterPlayerController;
  BetterPlayerController? get playerController => _betterPlayerController!;
  final DownloadFileService _downloadFileService = DownloadFileService();

  Future<void> initializePlayer(
      {required String videoUrl,
      required String coverImg,
      bool? autoDispose}) async {
    var result = await _downloadFileService.getDecryptedFileModel(videoUrl);

    if (result != null) {
      final encryptedFile = File(result.encryptedFilePath!);
      final encryptedInput = encryptedFile.openRead();
      final decryptedStream = StreamEncryptor().decryptStream(encryptedInput);
      //

      final decryptedBytes = await decryptedStream.fold<Uint8List>(Uint8List(0),
          (previous, element) => Uint8List.fromList(previous + element));

      _betterPlayerDataSource =
          BetterPlayerDataSource.memory(decryptedBytes.toList());
    } else {
      _betterPlayerDataSource = BetterPlayerDataSource.network(
        liveStream: false,
        videoUrl.toString(),
      );
    }

    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            looping: false,
            allowedScreenSleep: true,
            autoPlay: true,
            autoDispose: autoDispose ?? true,
            aspectRatio: 16 / 9,
            handleLifecycle: false,
            placeholder: Image.network(coverImg.toString()),
            errorBuilder: (context, errorMessage) =>
                const Center(child: Text("Video failed")),
            fit: BoxFit.cover),
        betterPlayerDataSource: _betterPlayerDataSource);
  }

  void dispose() {
    if (_betterPlayerController != null) {
      _betterPlayerController!.dispose(forceDispose: true);
      return;
    }
  }
}
