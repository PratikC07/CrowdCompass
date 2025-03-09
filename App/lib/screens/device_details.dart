import 'package:flutter/material.dart';

class DeviceDetailScreen extends StatelessWidget {
  final String name;
  final String address;
  final double estimatedDistance;
  final double smoothedRssi;

  const DeviceDetailScreen({
    Key? key,
    required this.name,
    required this.address,
    required this.estimatedDistance,
    required this.smoothedRssi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device Details"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Hero(
          tag: address,
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isNotEmpty ? name : "Unknown Device",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Address: $address",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  "Estimated Distance: ${estimatedDistance.toStringAsFixed(2)} meters",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Smoothed RSSI: ${smoothedRssi.toStringAsFixed(1)} dBm",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
