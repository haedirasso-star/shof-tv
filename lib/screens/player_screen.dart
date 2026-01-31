import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart'; // اختيارية: للتحكم بالسطوع

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
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _setFullScreen();
    _checkVideoType();
  }

  void _setFullScreen() {
    // إخفاء الأشرطة والتحويل للوضع الأفقي فوراً
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _checkVideoType() {
    // منطق ذكي للتمييز بين روابط البث المباشر وروابط الويب (Embed)
    final url = widget.videoUrl.toLowerCase();
    if (url.contains('.m3u8') || url.contains('.mp4') || url.contains('/live/')) {
      _isWebView = false;
      _initVideoPlayer();
    } else {
      _isWebView = true;
      _initWebView();
    }
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (url) {
          if (mounted) setState(() { _isLoading = false; });
        },
      ))
      ..loadRequest(Uri.parse(widget.videoUrl));
  }

  void _initVideoPlayer() async {
    try {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        isLive: widget.videoUrl.contains('m3u8'),
        aspectRatio: _videoController!.value.aspectRatio,
        allowFullScreen: true,
        fullScreenByDefault: false,
        looping: false,
        // تخصيص الهوية البصرية لـ Shof TV
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.yellowAccent,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        placeholder: Container(color: Colors.black, child: const Center(child: CircularProgressIndicator(color: Colors.yellow))),
        errorBuilder: (context, errorMessage) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.yellow, size: 42),
                const SizedBox(height: 10),
                Text("هذا الرابط لا يستجيب حالياً، جرب لاحقاً", style: const TextStyle(color: Colors.white70)),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("رجوع", style: TextStyle(color: Colors.yellow)))
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint("Video Error: $e");
      setState(() { _hasError = true; });
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    // إعادة النظام للوضع الطبيعي قبل الخروج
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
          // 1. المشغل (فيديو أو ويب)
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.yellow)
                : _hasError
                    ? const Text("خطأ في تشغيل المحتوى", style: TextStyle(color: Colors.white))
                    : _isWebView
                        ? WebViewWidget(controller: _webViewController!)
                        : Chewie(controller: _chewieController!),
          ),

          // 2. واجهة التحكم العلوية (تظهر فوق الفيديو)
          if (!_isLoading)
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.yellow, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title ?? "بث مباشر",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, shadows: [Shadow(blurRadius: 10, color: Colors.black)]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // العلامة المائية في الزاوية المقابلة
                  Opacity(
                    opacity: 0.6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(border: Border.all(color: Colors.yellow, width: 0.5)),
                      child: const Text("SHOF TV", style: TextStyle(color: Colors.yellow, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
