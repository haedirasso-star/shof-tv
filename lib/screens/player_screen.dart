import 'package:flutter/material.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // فحص الرابط: إذا لم يكن فيديو مباشر (m3u8) نفتحه كمتصفح للأفلام
    if (!widget.videoUrl.contains('.m3u8') && !widget.videoUrl.contains('.mp4')) {
      _isWebView = true;
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black)
        ..loadRequest(Uri.parse(widget.videoUrl));
      setState(() { _isInitialized = true; });
    } else {
      _initVideo();
    }
  }

  void _initVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: true,
        aspectRatio: _videoController!.value.aspectRatio,
      );
      setState(() { _isInitialized = true; });
    } catch (e) {
      debugPrint("خطأ في المشغل: $e");
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
        title: Text(widget.title ?? "Shof TV", style: const TextStyle(color: Colors.yellow)),
        backgroundColor: Colors.black,
      ),
      body: !_isInitialized 
        ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
        : _isWebView 
            ? WebViewWidget(controller: _webViewController!) 
            : Chewie(controller: _chewieController!),
    );
  }
}
