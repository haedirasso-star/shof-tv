import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  final ApiService _apiService = ApiService();
  String? selectedCategoryId; // لتخزين القسم المختار
  String selectedCategoryName = "جميع القنوات";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(selectedCategoryName, 
          style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: Column(
        children: [
          // 1. شريط التصنيفات (Live Categories)
          _buildCategoryFilter(),

          // 2. قائمة القنوات المحدثة
          Expanded(
            child: _buildChannelsList(),
          ),
        ],
      ),
    );
  }

  // ودجت جلب وعرض التصنيفات من السيرفر
  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: FutureBuilder<List<dynamic>>(
        future: _apiService.fetchLiveCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final cat = snapshot.data![index];
              bool isSelected = selectedCategoryId == cat['category_id'];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(cat['category_name']),
                  selected: isSelected,
                  selectedColor: Colors.yellow,
                  backgroundColor: Colors.grey[900],
                  labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white70, fontSize: 12),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedCategoryId = selected ? cat['category_id'] : null;
                      selectedCategoryName = selected ? cat['category_name'] : "جميع القنوات";
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ودجت عرض القنوات المفلترة
  Widget _buildChannelsList() {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.fetchLiveChannels(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.yellow));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("لا توجد قنوات متاحة حالياً", style: TextStyle(color: Colors.white54)));
        }

        // فلترة القنوات بناءً على التصنيف المختار
        final channels = selectedCategoryId == null 
            ? snapshot.data! 
            : snapshot.data!.where((ch) => ch['category_id'] == selectedCategoryId).toList();

        return ListView.builder(
          itemCount: channels.length,
          padding: const EdgeInsets.only(bottom: 20),
          itemBuilder: (context, index) {
            final channel = channels[index];
            final String streamId = channel['stream_id'].toString();
            
            return Card(
              color: const Color(0xFF121212),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.yellow.withOpacity(0.05)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: channel['stream_icon'] ?? "",
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => Container(color: Colors.black26, child: const Icon(Icons.tv, color: Colors.yellow)),
                    errorWidget: (context, url, error) => Container(color: Colors.black26, child: const Icon(Icons.live_tv, color: Colors.yellow)),
                  ),
                ),
                title: Text(
                  channel['name'] ?? "قناة غير معروفة",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                subtitle: Text("جودة عالية • بث مباشر", style: TextStyle(color: Colors.yellow.withOpacity(0.6), fontSize: 11)),
                trailing: const Icon(Icons.play_arrow_rounded, color: Colors.yellow, size: 30),
                onTap: () async {
                  final config = await _apiService.fetchRemoteConfig();
                  // بناء الرابط النهائي للبث
                  String finalUrl = "${config['host']}/live/${config['user']}/${config['pass']}/$streamId.m3u8";
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerScreen(videoUrl: finalUrl, title: channel['name']),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
