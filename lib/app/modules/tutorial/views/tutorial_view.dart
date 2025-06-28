import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capstone_project_6/app/modules/tutorial/controllers/tutorial_controller.dart';
import 'package:capstone_project_6/app/modules/videos/views/videos_view.dart';

class Tutorial extends GetView<TutorialController> {
  final TutorialController controller = Get.put(TutorialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Golf Tutorial'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search + Filter Dropdown
           // 🔍 Search + Filter Dropdown (Improved Styling)
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  child: Row(
    children: [
      // Expanded Search Bar dengan styling yang lebih baik
      Expanded(
        child: Container(
          height: 50, // Fixed height untuk konsistensi
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            onSubmitted: (value) => controller.searchByTechnique(value),
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[600],
                size: 22,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 12),

      // Filter Dropdown Button dengan styling yang lebih menarik
      Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[400]!, Colors.blue[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: PopupMenuButton<String>(
          onSelected: (value) => controller.searchByTechnique(value),
          icon: const Icon(
            Icons.tune,
            color: Colors.white,
            size: 22,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "swing",
              child: Row(
                children: [
                  Icon(Icons.sports_golf, size: 20, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Swing Techniques"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "putting",
              child: Row(
                children: [
                  Icon(Icons.flag, size: 20, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Putting"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "chipping",
              child: Row(
                children: [
                  Icon(Icons.golf_course, size: 20, color: Colors.blue),
                  SizedBox(width: 8),
                  Text("Chipping"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "bunker",
              child: Row(
                children: [
                  Icon(Icons.landscape, size: 20, color: Colors.brown),
                  SizedBox(width: 8),
                  Text("Bunker Shots"),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

            // 📹 Video List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.tutorialVideos.isEmpty) {
                  return const Center(child: Text("No videos found."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  itemCount: controller.tutorialVideos.length,
                  itemBuilder: (context, index) {
                    final item = controller.tutorialVideos[index];
                    final videoId = item['videoId'];
                    final title = item['title'];
                    final thumbnailUrl = item['thumbnailUrl'];

                    return GestureDetector(
                      onTap: () => Get.to(() => VideoDetailPage(videoId: videoId, title: title)),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Image.network(
                                thumbnailUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
