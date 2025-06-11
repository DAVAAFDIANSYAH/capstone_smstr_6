import 'package:capstone_project_6/app/modules/statistik/views/diagram.dart';
import 'package:capstone_project_6/app/modules/statistik/views/streamlit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capstone_project_6/app/modules/statistik/controllers/statistik_controller.dart';

class Statistik extends GetView {
  final StatistikController controller = Get.put(StatistikController());

  Statistik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchArticles();
    controller.fetchLokasi();
    controller.fetchTutorial();

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.teal.shade700,
        title: const Text('visualisasi', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          // Button untuk membuka Streamlit
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Buka Visualisasi SwingPro',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StreamlitView()),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.errorMsg.isNotEmpty) {
          return Center(child: Text(controller.errorMsg.value));
        }

        int articlesCount = controller.articles.length;
        int lokasiCount = controller.lokasi.length;
        int tutorialCount = controller.tutorial.length;
        int total = articlesCount + lokasiCount + tutorialCount;

        if (total == 0) {
          return const Center(child: Text('Tidak ada data untuk ditampilkan'));
        }

        List<ChartData> chartData = [
          ChartData('Articles', articlesCount.toDouble(), Colors.teal.shade400),
          ChartData('Lokasi', lokasiCount.toDouble(), Colors.orange.shade400),
          ChartData('Tutorial', tutorialCount.toDouble(), Colors.deepPurple.shade400),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Pie Chart
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: CustomPaint(
                      painter: PieChartPainter(data: chartData),
                    ),
                  ),
                  Column(
                    children: [
                      const Text('Total', style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Text('$total', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Legend
              Column(
                children: chartData.map((d) {
                  double percent = (d.value / total * 100);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        Container(width: 16, height: 16, decoration: BoxDecoration(color: d.color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(d.label)),
                        Text('${d.value.toStringAsFixed(0)} - ${percent.toStringAsFixed(1)}%'),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),

              // Bar Chart
              const Text('Diagram Batang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              BarChartManual(data: chartData, total: total),

              const SizedBox(height: 40),

              // Tabel Data
              const Text('Tabel Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Kategori')),
                  DataColumn(label: Text('Jumlah')),
                  DataColumn(label: Text('Persentase')),
                ],
                rows: chartData.map((d) {
                  double percent = (d.value / total * 100);
                  return DataRow(cells: [
                    DataCell(Text(d.label)),
                    DataCell(Text('${d.value.toInt()}')),
                    DataCell(Text('${percent.toStringAsFixed(1)}%')),
                  ]);
                }).toList(),
              ),
            ],
          ),
        );
      }),
    );
  }
}

