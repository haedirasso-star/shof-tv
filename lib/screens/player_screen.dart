import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart'; 

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
    _initializePlayer();
  }

  // دالة موحدة لبدء التشغيل مع التحكم في إعدادات النظام
  void _initializePlayer() async {
    _setFullScreen();
    _checkVideoType();
    
    // ضبط السطوع لأقصى درجة عند بدء الفيلم (اختياري)
    try {
      await ScreenBrightness().setScreenBrightness(0.8);
    } catch (e) {
      debugPrint("Brightness Error: $e");
    }
  }

  void _setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _checkVideoType() {
    final url = widget.videoUrl.toLowerCase();
    // تحسين المنطق للتعرف على روابط البث بدقة أكبر
    if (url.contains('.m3u8') || url.contains('.mp4') || url.contains('.mkv') || url.contains('/live/')) {
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
        isLive: widget.videoUrl.contains('m3u8') || widget.videoUrl.contains('/live/'),
        aspectRatio: _videoController!.value.aspectRatio,
        allowFullScreen: true,
        // واجهة تحكم Shof TV الاحترافية
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.yellow,
          handleColor: Colors.yellowAccent,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
        placeholder: Container(
          color: Colors.black, 
          child: const Center(child: CircularProgressIndicator(color: Colors.yellow))
        ),
        errorBuilder: (context, errorMessage) {
          return _buildErrorWidget();
        },
      );
    } catch (e) {
      debugPrint("Video Error: $e");
      if (mounted) setState(() { _hasError = true; });
    }
    if (mounted) setState(() { _isLoading = false; });
  }

  @override
  void dispose() {
    // إعادة السطوع للوضع الطبيعي وإعادة الشاشة للوضع الرأسي
    _resetScreenSettings();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _resetScreenSettings() async {
    await ScreenBrightness().resetScreenBrightness();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // مشغل المحتوى
          Center(
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.yellow)
                : _hasError
                    ? _buildErrorWidget()
                    : _isWebView
                        ? WebViewWidget(controller: _webViewController!)
                        : Chewie(controller: _chewieController!),
          ),

          // واجهة التحكم العلوية
          if (!_isLoading)
            Positioned(
              top: 20,
              left: 10,
              right: 20,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.yellow, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title ?? "بث مباشر - Shof TV",
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 15, color: Colors.black)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // العلامة المائية للتطبيق
                  _buildWatermark(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWatermark() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          "TOL • SHOF",
          style: TextStyle(color: Colors.yellow, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cast_connected_outlined, color: Colors.yellow, size: 60),
          const SizedBox(height: 15),
          const Text(
            "عذراً، السيرفر لا يستجيب حالياً",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("الرجوع للقائمة", style: TextStyle(color: Colors.yellow, fontSize: 18)),
          )
        ],
      ),
    );
  }
}
