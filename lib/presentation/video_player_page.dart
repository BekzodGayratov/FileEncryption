import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test/application/cubit/video_player_cubit.dart';
import 'package:test/infrastructure/services/file_download_service.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({super.key});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PLAYER"),
      ),
      body: BlocProvider(
        create: (context) => VideoPlayerCubit(
            videoUrl:
                "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
            coverImg:
                "https://cdn.motor1.com/images/mgl/Mk3qg6/s3/2017-tesla-roadster-deck-model-petersen-automotive-museum.jpg"),
        child: BlocBuilder<VideoPlayerCubit, VideoPlayerState>(
            builder: (context, state) {
          return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
              error: (err) => Center(
                    child: Text(err),
                  ),
              completed: (controller) {
                return BetterPlayer(controller: controller);
              });
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DownloadFileService().downloadAndEncryptVideo("https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4");
        },
        child: const Icon(Icons.download_outlined),
      ),
    );
  }
}
