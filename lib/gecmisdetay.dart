import 'package:flutter/material.dart';

class HistoryDetailPage extends StatelessWidget {
  final Map<String, String> item;

  const HistoryDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teşhis Detayı", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['plantName'] ?? "Bilinmeyen Bitki",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Teşhis Tarihi: ${item['date'] ?? ""}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              "Sonuç:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              item['diagnosisResult'] ?? "Teşhis bilgisi bulunamadı.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            if (item.containsKey('imagePath'))
              Image.asset(
                item['imagePath']!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
