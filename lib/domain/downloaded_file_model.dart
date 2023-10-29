// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DownloadedFileModel {
  final String? videoUrl;
  final String? encryptedFilePath;

  DownloadedFileModel({
    this.videoUrl,
    this.encryptedFilePath,
  });

  DownloadedFileModel copyWith({
    String? videoUrl,
    String? encryptedFilePath,
  }) =>
      DownloadedFileModel(
        videoUrl: videoUrl ?? this.videoUrl,
        encryptedFilePath: encryptedFilePath ?? this.encryptedFilePath,
      );

  factory DownloadedFileModel.fromRawJson(String str) =>
      DownloadedFileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DownloadedFileModel.fromJson(Map<String, Object?> json) =>
      DownloadedFileModel(
        videoUrl: json["videoUrl"].toString(),
        encryptedFilePath: json["encryptedFilePath"].toString(),
      );

  Map<String, Object?> toJson() => {
        "videoUrl": videoUrl.toString(),
        "encryptedFilePath": encryptedFilePath.toString(),
      };

  @override
  bool operator ==(covariant DownloadedFileModel other) {
    if (identical(this, other)) return true;

    return other.videoUrl == videoUrl &&
        other.encryptedFilePath == encryptedFilePath;
  }

  @override
  int get hashCode => videoUrl.hashCode ^ encryptedFilePath.hashCode;
}
