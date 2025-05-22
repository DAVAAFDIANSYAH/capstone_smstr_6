import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class History extends GetView<HistoryController> {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller sudah di-initialize (bisa di binding atau manual)
    final ctrl = controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() {
        final history = ctrl.history;
        if (history.isEmpty) return _buildEmptyState();

        return Column(
          children: [
            _buildStatsCard(history),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (_, i) => _buildHistoryItem(history[i], i),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/orang.jpg', height: 120, width: 120, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text('No Detection History', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Your detection results will appear here', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStatsCard(List<Map<String, dynamic>> history) {
    final thisWeek = history.where((e) => e['timestamp'].isAfter(DateTime.now().subtract(const Duration(days: 7)))).length;
    final avgConfidence = history.map((e) => e['confidence']).reduce((a, b) => a + b) / history.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Total', history.length.toString()),
            _statItem('This Week', thisWeek.toString()),
            _statItem('Avg. Conf.', '${(avgConfidence * 100).toStringAsFixed(1)}%'),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item, int index) {
    final ctrl = controller;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => Get.toNamed('/detection-detail', arguments: item),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(item['thumbnailUrl'], width: 50, height: 50, fit: BoxFit.cover),
        ),
        title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result: ${item['result']}', style: const TextStyle(fontSize: 13)),
            if (item['notes'] != null && item['notes'].isNotEmpty)
              Text(item['notes'], style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey)),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: _getConfidenceColor(item['confidence']),
              child: Text(
                '${(item['confidence'] * 100).toInt()}%',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                ctrl.deleteHistory(index);
                Get.snackbar('Deleted', '${item['title']} removed from history');
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return Colors.green;
    if (confidence >= 0.7) return Colors.orange;
    return Colors.red;
  }
}
