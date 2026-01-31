import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  // أضفنا Title اختياري ليعرف المستخدم ماذا يشاهد
  final String? title; 

  const PlayerScreen({super.key, required this.videoUrl, this.title});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // التحديث الجديد لـ Flutter يستخدم networkUrl
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    
    try {
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        isLive: true, // ضروري جداً لقنوات IPTV
        aspectRatio: _videoController.value.aspectRatio, // جلب الأبعاد تلقائياً
        errorBuilder: (context, errorMessage) => Center(
          child: Text("خطأ في التشغيل: $errorMessage", 
          style: const TextStyle(color: Colors.white))
        ),
      );
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Video Error: $e");
    }
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
      appBar: widget.title != null ? AppBar(
        title: Text(widget.title!, style: const TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ) : null,
      body: Center(
        child: _isInitialized && _chewieController != null 
          ? Chewie(controller: _chewieController!) 
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.yellow),
                SizedBox(height: 10),
                Text("جاري الاتصال بالبث...", style: TextStyle(color: Colors.white)),
              ],
            ),
      ),
    );
  }
}
