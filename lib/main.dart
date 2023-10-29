import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test/presentation/video_player_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoPlayerPage(),
    );
  }
}
