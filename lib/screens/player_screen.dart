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
    // إخفاء أشرطة النظام (ساعة، إشعارات) لتجربة كاملة
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _checkVideoType();
  }

  void _checkVideoType() {
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
        isLive: widget.videoUrl.contains('.m3u8'),
        aspectRatio: _videoController!.value.aspectRatio,
        allowFullScreen: true,
        fullScreenByDefault: false,
        // تخصيص الألوان
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.yellowAccent,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white24,
        ),
        // هنا يمكنك استدعاء إعلان قبل البدء
        placeholder: Container(color: Colors.black),
        errorBuilder: (context, errorMessage) {
          return Center(child: Text("عذراً، الرابط لا يعمل حالياً", style: TextStyle(color: Colors.white)));
        },
      );
    } catch (e) {
      debugPrint("Video Error: $e");
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    // إظهار أشرطة النظام والرجوع للوضع العمودي
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. جسم المشغل
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.yellow)
                : _isWebView
                    ? WebViewWidget(controller: _webViewController!)
                    : _chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : const Text("خطأ في الاتصال", style: TextStyle(color: Colors.white)),
          ),

          // 2. زر العودة الاحترافي (يختفي في وضع الويب)
          if (!_isLoading)
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.yellow, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          
          // 3. علامة مائية (Watermark) باسم تطبيقك Shof TV لزيادة الاحترافية
          Positioned(
            bottom: 20,
            right: 20,
            child: Opacity(
              opacity: 0.5,
              child: Text("SHOF TV LIVE", style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
