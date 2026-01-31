import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // أضفت هذا للتحكم في وضع الشاشة
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String? title;
  const PlayerScreen({super.key, required this.videoUrl, this.title});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  WebViewController? _webViewController;
  bool _isWebView = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    
    // إجبار الشاشة على الوضع الأفقي عند بدء التشغيل لتجربة أفضل
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    if (!widget.videoUrl.contains('.m3u8') && !widget.videoUrl.contains('.mp4')) {
      _isWebView = true;
      _initWebView();
    } else {
      _initVideoPlayer();
    }
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadRequest(Uri.parse(widget.videoUrl));
    if (mounted) setState(() { _isLoading = false; });
  }

  void _initVideoPlayer() async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: true,
        aspectRatio: _videoController!.value.aspectRatio,
        backgroundColor: Colors.black,
        allowFullScreen: true,
      );
    } catch (e) {
      debugPrint("Video Init Error: $e");
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    // إعادة الشاشة للوضع الطبيعي عند الخروج من المشغل
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title ?? "Shof TV", style: const TextStyle(color: Colors.yellow, fontSize: 18)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: Center(
        child: _isLoading 
          ? const CircularProgressIndicator(color: Colors.yellow)
          : _isWebView 
              ? WebViewWidget(controller: _webViewController!) 
              : Chewie(controller: _chewieController!),
      ),
    );
  }
}
