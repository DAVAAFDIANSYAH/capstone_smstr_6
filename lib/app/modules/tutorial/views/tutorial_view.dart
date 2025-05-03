import 'package:capstone_project_6/app/modules/tutorial/controllers/tutorial_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Tutorial extends GetView<TutorialController> {
  final TutorialController controller = Get.put(TutorialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profile.png'),
                    radius: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Good morning Dapzz',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),
              SizedBox(height: 20),

              // Title
              Text(
                'Tutorial',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),

              // Tutorial List
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.tutorials.length,
                    itemBuilder: (context, index) {
                      final item = controller.tutorials[index];
                      final videoId = item['videoId'];
                      final title = item['title'] ?? 'No Title';
                      final thumbnailUrl = videoId != null
                          ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
                          : 'https://via.placeholder.com/320x180.png?text=No+Thumbnail';

                      return GestureDetector(
                        onTap: () async {
                          if (videoId != null) {
                            final url = 'https://www.youtube.com/watch?v=$videoId';

                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            } else {
                              Get.snackbar('Error', 'Could not open video');
                            }
                          }
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
                                borderRadius:
                                    BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  thumbnailUrl,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(title),
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
      ),
    );
  }
}
