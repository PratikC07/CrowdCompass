import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final String movement; // Added movement status

  const DeviceCard({
    Key? key,
    required this.name,
    required this.address,
    required this.distance,
    required this.movement, // Receive movement status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blueAccent.withOpacity(0.3),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isNotEmpty ? name : "Unknown Device",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Address: $address",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            "Distance: $distance",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Status: $movement", // Show movement status
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  movement == "Moving Closer"
                      ? Colors.green
                      : movement == "Moving Away"
                      ? Colors.red
                      : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
