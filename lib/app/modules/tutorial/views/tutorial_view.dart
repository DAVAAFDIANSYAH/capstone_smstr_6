import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capstone_project_6/app/modules/tutorial/controllers/tutorial_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:capstone_project_6/app/modules/videos/views/videos_view.dart';

class Tutorial extends GetView<TutorialController> {
  final TutorialController controller = Get.put(TutorialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Golf Tutorials'),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              // Row(
              //   children: [
              //     const CircleAvatar(
              //       backgroundImage: AssetImage('assets/profile.png'),
              //       radius: 24,
              //     ),
              //     const SizedBox(width: 12),
              //     const Text(
              //       'Good morning Dapzz',
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //     ),
              //     const Spacer(),
              //   ],
              // ),
              const SizedBox(height: 5),

              // Title
              const Text(
                'Golf Tutorials',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Loading indicator if tutorials are still loading
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: controller.tutorialVideos.length,
                      itemBuilder: (context, index) {
                        final item = controller.tutorialVideos[index];
                        final videoId = item.id;
                        final title = item.title;
                        final thumbnailUrl = item.thumbnailUrl;

                        return GestureDetector(
                          onTap: () {
                            // Navigate to video detail page
                            Get.to(() => VideoDetailPage(
                              videoId: videoId,
                              title: title,
                            ));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 4,
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
