import 'dart:typed_data';
import 'dart:io';
import 'dart:async';
import 'package:encrypt/encrypt.dart';

class FileEncryptionSerice {
  final _key = Key.fromUtf8("KeyForNodejsServerAndFlutterAppp"); // 32 byte
  final _iv = IV.fromUtf8("EncryptAndDecryp"); // initialization vector

  Encrypted encrypt(Uint8List bytes) {
    final encrypter = Encrypter(AES(_key,
        mode: AESMode.cbc,
        padding: 'PKCS7')); // create an AES encrypter with the shared key
    return encrypter.encryptBytes(bytes, iv: _iv);
  }

  List<int> decrypt(Encrypted dataToDecrypt) {
    final encrypter = Encrypter(AES(_key,
        mode: AESMode.cbc,
        padding: 'PKCS7')); // create an AES encrypter with the shared key

    return encrypter.decryptBytes(dataToDecrypt, iv: _iv);
  }
}

class StreamEncryptor {
  final String encryptionKey = "KeyForNodejsServerAndFlutterAppp";

  Stream<List<int>> encryptStream(Stream<List<int>> inputStream) async* {
    final keyBytes = encryptionKey.codeUnits;
    final keyLength = keyBytes.length;
    var i = 0;

    await for (final chunk in inputStream) {
      final encryptedChunk =
          List<int>.from(chunk.map((byte) => byte ^ keyBytes[i]));
      yield encryptedChunk;

      i = (i + 1) % keyLength;
    }
  }

  Stream<List<int>> decryptStream(Stream<List<int>> inputStream) {
    final controller = StreamController<List<int>>();
    final decryptSink = controller.sink;

    final keyBytes = encryptionKey.codeUnits;
    final keyLength = keyBytes.length;
    var i = 0;

    inputStream.listen((chunk) {
      final decryptedChunk =
          List<int>.from(chunk.map((byte) => byte ^ keyBytes[i]));
      decryptSink.add(decryptedChunk);

      i = (i + 1) % keyLength;
    }, onDone: () {
      decryptSink.close();
    }, onError: (error) {
      controller.addError(error);
    });

    return controller.stream;
  }
}

// void main() async {
//   const encryptedVideoPath = '/path/to/encrypted_video.mp4';
//   const decryptedVideoPath = '/path/to/decrypted_video.mp4';

//   final encryptor = StreamEncryptor();

//   // Encrypt the video file
//   final fileInput = File(encryptedVideoPath).openRead();
//   final encryptedStream = encryptor.encryptStream(fileInput);
//   final encryptedFile = File(decryptedVideoPath);
//   await encryptedStream.pipe(encryptedFile.openWrite());
//   final encryptedBytes = await encryptedStream.fold<Uint8List>(
//     Uint8List(0),
//     (Uint8List previous, List<int> element) =>
//         Uint8List.fromList(previous + element),
//   );

//   // Decrypt the video file
//   final encryptedInput = encryptedFile.openRead();
//   final decryptedStream = encryptor.decryptStream(encryptedInput);
//   final decryptedFile = File('/path/to/output/decrypted_video.mp4');
//   await decryptedStream.pipe(decryptedFile.openWrite());
// }
