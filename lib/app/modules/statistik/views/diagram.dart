import 'package:flutter/material.dart';

/// Data model untuk chart
class ChartData {
  final String label;
  final double value;
  final Color color;

  ChartData(this.label, this.value, this.color);
}

/// Custom painter untuk Pie Chart
class PieChartPainter extends CustomPainter {
  final List<ChartData> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    double total = data.fold(0, (sum, item) => sum + item.value);
    double startAngle = -90.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 40;

    for (var d in data) {
      final sweepAngle = (d.value / total) * 360;
      paint.color = d.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 20),
        _degreesToRadians(startAngle),
        _degreesToRadians(sweepAngle),
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  double _degreesToRadians(double degrees) => degrees * 3.1415926535897932 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Widget untuk Bar Chart manual
class BarChartManual extends StatelessWidget {
  final List<ChartData> data;
  final int total;

  const BarChartManual({Key? key, required this.data, required this.total}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double maxHeight = 150;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: data.map((d) {
        final height = (d.value / total) * maxHeight;

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(d.value.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: 30,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: d.color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 8),
            Text(d.label, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
