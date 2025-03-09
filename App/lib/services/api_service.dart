import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  // static const String _baseUrl = "http://192.168.0.111:5001"; // Flask server IP
  static const String _baseUrl = "http://10.0.2.2:5001"; // Works in Emulator
  /// Fetches the BLE devices from Flask API
  static Future<List<Map<String, dynamic>>> fetchDevices() async {
    try {
      final response = await http
          .get(
            Uri.parse("$_baseUrl/scan"),
            headers: {"Accept": "application/json"},
          )
          .timeout(const Duration(seconds: 5)); // Timeout after 5 seconds

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<Map<String, dynamic>> devices = List<Map<String, dynamic>>.from(
          data,
        );

        // Log only first 2 devices for debugging
        log("📡 Fetched Devices: ${devices.take(2).toList()}");

        return devices;
      } else {
        log("❌ Failed to load BLE devices. Status: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      log("⚠️ Error fetching BLE devices: $e");
      return [];
    }
  }
}
