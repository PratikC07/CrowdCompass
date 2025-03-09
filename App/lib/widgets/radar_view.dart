import 'dart:math';
import 'package:flutter/material.dart';

class RadarView extends StatefulWidget {
  final List<Map<String, dynamic>> devices;

  const RadarView({super.key, required this.devices});

  @override
  _RadarViewState createState() => _RadarViewState();
}

class _RadarViewState extends State<RadarView> {
  final Map<String, Offset> _devicePositions = {};
  final double radarSize = 250;

  @override
  void didUpdateWidget(covariant RadarView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _calculatePositions();
  }

  void _calculatePositions() {
    for (var device in widget.devices) {
      final String address = device["address"];

      // Ensure estimated_distance is treated as a double
      final double distance =
          double.tryParse(device["estimated_distance"].toString()) ?? 30.0;

      double angle = _getStableAngle(address);
      double maxRadius = radarSize / 2 - 20;
      double scaledDistance = (distance * 5).clamp(
        0.0,
        maxRadius,
      ); // Scale for UI

      double x = scaledDistance * cos(angle);
      double y = scaledDistance * sin(angle);

      _devicePositions[address] = Offset(x, y);
    }
    setState(() {});
  }

  double _getStableAngle(String address) {
    return (address.hashCode % 360) * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: radarSize,
        height: radarSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(radarSize, radarSize),
              painter: RadarPainter(),
            ),
            ...widget.devices.map((device) {
              final position =
                  _devicePositions[device["address"]] ?? Offset.zero;
              return Positioned(
                left: (radarSize / 2 + position.dx).clamp(
                  0.0,
                  radarSize - 20.0,
                ),
                top: (radarSize / 2 + position.dy).clamp(0.0, radarSize - 20.0),
                child: Column(
                  children: [
                    const Icon(Icons.circle, color: Colors.red, size: 10),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        device["name"] ?? "Unknown",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint =
        Paint()
          ..color = Colors.blueAccent.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    double radiusStep = size.width / 6;

    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radiusStep * i, circlePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
