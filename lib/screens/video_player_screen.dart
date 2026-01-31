import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;
  final String name;

  const VideoPlayerScreen({super.key, required this.url, required this.name});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      // إرسال طلب وكأننا متصفح لفتح الروابط المشفرة أو المحمية
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
        httpHeaders: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36',
        },
      );

      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        allowFullScreen: true,
        isLive: true, // مهم جداً لقنوات البث المباشر
        
        // تخصيص الألوان لتناسب تطبيق Shof TV
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.yellow,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white.withOpacity(0.3),
        ),
        
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text(
                  "عذراً، هذا البث غير متاح حالياً",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.name, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow),
        elevation: 0,
      ),
      body: Center(
        child: _hasError
            ? const Text("خطأ في تشغيل الرابط", style: TextStyle(color: Colors.red))
            : _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Colors.yellow),
                      const SizedBox(height: 20),
                      Text(
                        "جاري تحضير البث المباشر...",
                        style: TextStyle(color: Colors.yellow.withOpacity(0.8)),
                      ),
                    ],
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
