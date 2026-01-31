import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  final String whatsapp = "009647714415816";
  final String telegram = "https://t.me/O_2828";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("الدعم الفني"), backgroundColor: Colors.yellow),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Shof TV v1.0", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => launchUrl(Uri.parse("https://wa.me/$whatsapp")), child: Text("واتساب")),
            ElevatedButton(onPressed: () => launchUrl(Uri.parse(telegram)), child: Text("تليجرام")),
          ],
        ),
      ),
    );
  }
}
