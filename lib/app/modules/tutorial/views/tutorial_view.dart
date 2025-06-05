// import 'package:capstone_project_6/app/modules/videos/views/videos_view.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:capstone_project_6/app/modules/tutorial/controllers/tutorial_controller.dart';

// class Tutorial extends GetView<TutorialController> {
//   final TutorialController controller = Get.put(TutorialController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Golf Tutorial'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: (value) => controller.searchByTechnique(value),
//             icon: const Icon(Icons.filter_list),
//             itemBuilder: (context) => [
//               const PopupMenuItem(value: "swing", child: Text("Swing")),
//               const PopupMenuItem(value: "putting", child: Text("Putting")),
//               const PopupMenuItem(value: "chipping", child: Text("Chipping")),
//               const PopupMenuItem(value: "bunker", child: Text("Bunker Shots")),
//             ],
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (controller.tutorialVideos.isEmpty) {
//               return const Center(child: Text("No videos found."));
//             }

//             return ListView.builder(
//               padding: const EdgeInsets.only(bottom: 24),
//               itemCount: controller.tutorialVideos.length,
//               itemBuilder: (context, index) {
//                 final item = controller.tutorialVideos[index];
//                 final videoId = item['videoId'];
//                 final title = item['title'];
//                 final thumbnailUrl = item['thumbnailUrl'];

//                 return GestureDetector(
//                   onTap: () => Get.to(() => VideoDetailPage(videoId: videoId, title: title)),
//                   child: Card(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     margin: const EdgeInsets.only(bottom: 24),
//                     elevation: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                           child: Image.network(
//                             thumbnailUrl,
//                             height: 180,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             title,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }


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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Expanded Search Bar
                  Expanded(
                    child: TextField(
                      onSubmitted: (value) => controller.searchByTechnique(value),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Filter Dropdown Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) => controller.searchByTechnique(value),
                      icon: const Icon(Icons.filter_list),
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "swing", child: Text("Swing")),
                        PopupMenuItem(value: "putting", child: Text("Putting")),
                        PopupMenuItem(value: "chipping", child: Text("Chipping")),
                        PopupMenuItem(value: "bunker", child: Text("Bunker Shots")),
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
