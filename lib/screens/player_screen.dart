import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  PlayerScreen({required this.videoUrl});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl);
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
      isLive: true, // مهم جداً للقنوات المباشرة
      aspectRatio: 16 / 9,
      errorBuilder: (context, errorMessage) => Center(child: Text("خطأ في التشغيل: $errorMessage")),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _chewieController != null 
          ? Chewie(controller: _chewieController!) 
          : CircularProgressIndicator(color: Colors.yellow),
      ),
    );
  }
}
