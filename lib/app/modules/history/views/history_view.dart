import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class History extends GetView<HistoryController> {
  const History({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshHistory(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty && controller.historyList.isEmpty) {
          return _buildErrorState();
        }

        if (controller.historyList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: Column(
            children: [
              _buildStatsCard(),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.historyList.length,
                  itemBuilder: (_, index) => _buildHistoryItem(controller.historyList[index], index),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 120,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'No Pose History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your pose detection results will appear here',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.refreshHistory(),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 120,
            color: Colors.red[300],
          ),
          const SizedBox(height: 20),
          const Text(
            'Error Loading History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => controller.refreshHistory(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    final historyCount = controller.historyList.length;
    final thisWeekCount = _getThisWeekCount();

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
            _statItem('Total', historyCount.toString()),
            _statItem('This Week', thisWeekCount.toString()),
            _statItem('Latest', _getLatestLabel()),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(PoseHistory item, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: () => _showDetailDialog(item),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: item.image.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImageWidget(item.image, 50, 50),
                )
              : const Icon(Icons.image, color: Colors.grey),
        ),
        title: Text(
          item.label.isNotEmpty ? item.label : 'Unknown Pose',
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detected: ${item.label}',
              style: const TextStyle(fontSize: 13),
            ),
            Text(
              'Time: ${item.formattedDate}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getLabelColor(item.label),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(item, index);
                } else if (value == 'detail') {
                  _showDetailDialog(item);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'detail',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 8),
                      Text('Detail'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailDialog(PoseHistory item) {
    Get.dialog(
      AlertDialog(
        title: Text(item.label),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildImageWidget(item.image, double.infinity, 200),
              ),
            const SizedBox(height: 16),
            Text('Pose: ${item.label}'),
            const SizedBox(height: 8),
            Text('Time: ${item.formattedDate}'),
            const SizedBox(height: 8),
            Text('ID: ${item.id}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(PoseHistory item, int index) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete History'),
        content: Text('Are you sure you want to delete "${item.label}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.historyList.removeAt(index);
              Get.snackbar(
                'Deleted',
                '${item.label} removed from history',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getLabelColor(String label) {
    // Assign colors based on pose type
    switch (label.toLowerCase()) {
      case 'warrior':
      case 'warrior pose':
        return Colors.red;
      case 'tree':
      case 'tree pose':
        return Colors.green;
      case 'downward dog':
      case 'downward facing dog':
        return Colors.blue;
      case 'mountain':
      case 'mountain pose':
        return Colors.brown;
      case 'cobra':
      case 'cobra pose':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  int _getThisWeekCount() {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    
    return controller.historyList.where((item) {
      try {
        final itemDate = DateTime.parse(item.timestamp);
        return itemDate.isAfter(weekAgo);
      } catch (e) {
        return false;
      }
    }).length;
  }

  String _getLatestLabel() {
    if (controller.historyList.isEmpty) return '-';
    return controller.historyList.first.label;
  }

  Widget _buildImageWidget(String imageUrl, double width, double height) {
    // Debug print untuk melihat URL gambar
    debugPrint('🖼️ Loading image from: $imageUrl');
    
    // Cek apakah URL sudah lengkap atau perlu ditambahkan base URL
    String fullImageUrl = imageUrl;
    
    // Jika image hanya berupa path/filename, tambahkan base URL
    // if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
    //   fullImageUrl = 'http://10.137.254.52:5000$imageUrl';
    //   debugPrint('🖼️ Full image URL: $fullImageUrl');
    // }
    
    // Cek jika image adalah base64
    if (imageUrl.startsWith('data:image/')) {
      debugPrint('🖼️ Image is base64 format');
      try {
        String base64String = imageUrl.split(',')[1];
        return Image.memory(
          base64Decode(base64String),
          width: width == double.infinity ? null : width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('❌ Error loading base64 image: $error');
            return Container(
              width: width == double.infinity ? null : width,
              height: height,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            );
          },
        );
      } catch (e) {
        debugPrint('❌ Error decoding base64: $e');
        return Container(
          width: width == double.infinity ? null : width,
          height: height,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.red),
        );
      }
    }
    
    // Untuk URL biasa
    return Image.network(
      fullImageUrl,
      width: width == double.infinity ? null : width,
      height: height,
      fit: BoxFit.cover,
      headers: {
        'User-Agent': 'Flutter App',
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          debugPrint('✅ Image loaded successfully: $fullImageUrl');
          return child;
        }
        return Container(
          width: width == double.infinity ? null : width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('❌ Error loading image: $error');
        debugPrint('❌ URL: $fullImageUrl');
        debugPrint('❌ Stack trace: $stackTrace');
        
        return Container(
          width: width == double.infinity ? null : width,
          height: height,
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image, color: Colors.red, size: 30),
              if (width == double.infinity) // Hanya tampilkan text di dialog
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}