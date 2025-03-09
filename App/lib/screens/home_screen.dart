import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:test_app/services/api_service.dart';
import 'package:test_app/widgets/device_card.dart';
import 'package:test_app/widgets/loading_widgets.dart';
import 'package:test_app/widgets/radar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _devices = [];
  Map<String, double> _previousRSSI = {}; // Store previous smoothed_rssi
  bool _isLoading = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchDevices();
    _timer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) => _fetchDevices(),
    );
  }

  Future<void> _fetchDevices() async {
    try {
      List<Map<String, dynamic>> devices = await ApiService.fetchDevices();

      setState(() {
        for (var device in devices) {
          String address = device["address"] ?? "Unknown";
          double currentRSSI =
              (device["smoothed_rssi"] is num)
                  ? device["smoothed_rssi"].toDouble()
                  : -100.0; // Default RSSI if not found

          // Movement detection logic
          if (_previousRSSI.containsKey(address)) {
            double previousRSSI = _previousRSSI[address]!;

            if (currentRSSI > previousRSSI) {
              device["movement"] = "Moving Closer";
            } else if (currentRSSI < previousRSSI) {
              device["movement"] = "Moving Away";
            } else {
              device["movement"] = "Stable";
            }
          } else {
            device["movement"] = "Stable"; // First-time detection
          }

          _previousRSSI[address] = currentRSSI; // Store previous RSSI
        }

        _devices = devices;
        _isLoading = false;
      });

      log("📡 Updated Devices: $_devices"); // Debugging log
    } catch (e) {
      log("❌ Error fetching devices: $e");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BLE Device Scanner")),
      body:
          _isLoading
              ? const LoadingWidget()
              : Column(
                children: [
                  // Radar UI at the top
                  SizedBox(
                    height: 300, // Adjust radar size
                    child: RadarView(devices: _devices),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Available Devices",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Expanded list below Radar
                  Expanded(child: _buildDeviceList()),
                ],
              ),
    );
  }

  Widget _buildDeviceList() {
    return _devices.isEmpty
        ? const Center(
          child: Text("No devices found", style: TextStyle(fontSize: 18)),
        )
        : AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _devices.length,
            itemBuilder: (context, index) {
              final device = _devices[index];
              log('Device///////////${device['estimated_distance']}');

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: DeviceCard(
                      name: device["name"] ?? "Unknown",
                      address: device["address"] ?? "N/A",
                      distance:
                          // (device["estimated_distance"] is num) ?
                          "${device["estimated_distance"]}" ?? "Unknown",
                      movement: device["movement"] ?? "Stable",
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }
}
