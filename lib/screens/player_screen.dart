import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:webview_flutter/webview_flutter.dart'; // ضروري لتشغيل الأفلام

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String? title;

  const PlayerScreen({super.key, required this.videoUrl, this.title});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  WebViewController? _webViewController;
  bool _isInitialized = false;
  bool _isWebView = false;

  @override
  void initState() {
    super.initState();
    
    // فحص نوع الرابط: إذا كان لا يحتوي على امتداد فيديو مباشر نستخدم WebView
    if (!widget.videoUrl.contains('.m3u8') && !widget.videoUrl.contains('.mp4')) {
      _isWebView = true;
      _initializeWebView();
    } else {
      _initializePlayer();
    }
  }

  // إعداد مشغل الويب للأفلام
  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(widget.videoUrl));
    
    setState(() {
      _isInitialized = true;
    });
  }

  // إعداد مشغل الفيديو للقنوات
  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    
    try {
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        isLive: true,
        aspectRatio: _videoController!.value.aspectRatio,
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
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title ?? "مشاهدة الآن", style: const TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: Center(
        child: !_isInitialized
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.yellow),
                SizedBox(height: 10),
                Text("جاري تجهيز المحتوى...", style: TextStyle(color: Colors.white)),
              ],
            )
          : _isWebView 
              ? WebViewWidget(controller: _webViewController!) // عرض الفيلم
              : Chewie(controller: _chewieController!), // عرض البث المباشر
      ),
    );
  }
}
