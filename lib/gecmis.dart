import 'package:bitki_teshis/gecmisdetay.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // Geçmişi yükle
  Future<void> _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? historyData = prefs.getString('diagnosis_history');
    if (historyData != null) {
      setState(() {
        history = List<Map<String, String>>.from(json.decode(historyData));
      });
    }
  }

  // Geçmişi temizle
  Future<void> _clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('diagnosis_history');
    setState(() {
      history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: const Color.fromARGB(255, 205, 0, 0),
              ),
              onPressed: () => _clearHistory(),
            ),
        ],
      ),
      body:
          history.isEmpty
              ? _buildEmptyHistory()
              : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final item = history[index];
                  return ListTile(
                    leading: Icon(Icons.history, color: Colors.green),
                    title: Text(item['plantName'] ?? "Bilinmeyen Bitki"),
                    subtitle: Text(item['date'] ?? ""),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(item: item),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }

  // Eğer geçmiş boşsa gösterilecek ekran
  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 100, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "Henüz geçmiş bulunmamaktadır.",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
