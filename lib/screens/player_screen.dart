import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // وضع الشاشة بالعرض لتجربة سينمائية
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // فحص نوع الرابط
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
        allowFullScreen: true,
        fullScreenByDefault: false,
        // ملاحظة: تم حذف backgroundColor لحل مشكلة فشل البناء في Codemagic
      );
    } catch (e) {
      debugPrint("خطأ في تشغيل الفيديو: $e");
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    // إعادة الشاشة للوضع العمودي عند الخروج
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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
              : _chewieController != null 
                  ? Chewie(controller: _chewieController!)
                  : const Text("خطأ في تحميل المشغل", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
