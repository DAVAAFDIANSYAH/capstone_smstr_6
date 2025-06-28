import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import '../controllers/history_controller.dart';

class History extends GetView<HistoryController> {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshHistory)
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.value.isNotEmpty &&
            controller.historyList.isEmpty) {
          return _errorState();
        }
        if (controller.historyList.isEmpty) return _emptyState();

        final sortedList = controller.historyList.toList()
          ..sort((a, b) => DateTime.parse(b.timestamp)
              .compareTo(DateTime.parse(a.timestamp)));

        return RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    // const Text(
                    //   "Pose Category Chart",
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    // ),
                    const SizedBox(height: 12),
                    Center(
                      child: Container(
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius: BorderRadius.circular(16),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: Colors.black12,
                        //       blurRadius: 8,
                        //       offset: Offset(0, 4),
                        //     ),
                        //   ],
                        // ),
                        padding: const EdgeInsets.all(16),
                        child: PieChart(
                          dataMap: _categoryData(sortedList),
                          colorList: [
                            Colors.teal,
                            Colors.orange,
                            Colors.blueAccent,
                            Colors.deepPurple,
                            Colors.green,
                            Colors.redAccent,
                          ],
                          chartRadius: MediaQuery.of(context).size.width * 0.55,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 24,
                          animationDuration: const Duration(milliseconds: 1000),
                          legendOptions: const LegendOptions(
                            legendPosition: LegendPosition.right,
                            legendTextStyle: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValuesInPercentage: true,
                            showChartValuesOutside: true,
                            chartValueStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedList.length,
                  itemBuilder: (_, i) => _historyItem(sortedList[i], i),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _emptyState() => _centerMessage(
        icon: Icons.history,
        title: 'No Pose History',
        message: 'Your pose detection results will appear here',
        buttonLabel: 'Refresh',
        onPressed: controller.refreshHistory,
      );

  Widget _errorState() => _centerMessage(
        icon: Icons.error_outline,
        color: Colors.red,
        title: 'Error Loading History',
        message: controller.errorMessage.value,
        buttonLabel: 'Try Again',
        onPressed: controller.refreshHistory,
      );

  Widget _centerMessage({
    required IconData icon,
    required String title,
    required String message,
    String buttonLabel = '',
    VoidCallback? onPressed,
    Color color = Colors.grey,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: (color as MaterialColor)[300]),
          const SizedBox(height: 16),
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          if (onPressed != null)
            ElevatedButton(onPressed: onPressed, child: Text(buttonLabel)),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      );

 Widget _historyItem(PoseHistory item, int index) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: ListTile(
      onTap: () => (item),
      leading: _imageThumb(item.image),
      title: Text(
        item.label.isNotEmpty ? item.label : 'Unknown Pose',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Time: ${_formatDate(item.timestamp)}',
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _confirmDelete(item, index),
      ),
    ),
  );
}


  Widget _imageThumb(String image) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: image.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _imageWidget(image, 50, 50),
            )
          : const Icon(Icons.image, color: Colors.grey),
    );
  }

  // void _showDetail(PoseHistory item) {
  //   Get.dialog(AlertDialog(
  //     title: Text(item.label),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         if (item.image.isNotEmpty)
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(8),
  //             child: _imageWidget(item.image, double.infinity, 200),
  //           ),
  //         const SizedBox(height: 12),
  //         Text('Pose: ${item.label}'),
  //         Text('Time: ${_formatDate(item.timestamp)}'),
  //         Text('ID: ${item.id}'),
  //       ],
  //     ),
  //     actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
  //   ));
  // }

  void _confirmDelete(PoseHistory item, int index) {
  Get.dialog(AlertDialog(
    title: const Text('Delete History'),
    content: Text('Are you sure you want to delete "${item.label}"?'),
    actions: [
      TextButton(onPressed: Get.back, child: const Text('Cancel')),
      TextButton(
        onPressed: () async {
          Get.back();
          await controller.deletePoseHistory(item.id);
        },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: const Text('Delete'),
      ),
    ],
  ));
}


  Widget _imageWidget(String url, double width, double height) {
    if (url.startsWith('data:image/')) {
      try {
        return Image.memory(
          base64Decode(url.split(',').last),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      } catch (_) {
        return _imageError(width, height);
      }
    }

    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imageError(width, height),
    );
  }

  Widget _imageError(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.red),
    );
  }

  int _thisWeekCount(List<PoseHistory> list) {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return list.where((item) {
      try {
        return DateTime.parse(item.timestamp).isAfter(weekAgo);
      } catch (_) {
        return false;
      }
    }).length;
  }

  String _formatDate(String timestamp) {
    try {
      final dt = DateTime.parse(timestamp).toLocal();
      return DateFormat('dd MMM yyyy, HH:mm').format(dt);
    } catch (_) {
      return timestamp;
    }
  }

  Map<String, double> _categoryData(List<PoseHistory> list) {
    final Map<String, double> dataMap = {};
    for (var item in list) {
      final label = item.label.isNotEmpty ? item.label : 'Unknown';
      dataMap[label] = (dataMap[label] ?? 0) + 1;
    }
    return dataMap;
  }
}
