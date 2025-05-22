import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/statistik_controller.dart';

class Statistik extends GetView<StatistikController> {
  const Statistik ({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StatistikView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StatistikView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
