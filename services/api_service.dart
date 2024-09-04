import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../models/sensor_data.dart';

class ApiService {
  final String baseUrl = 'http://192.168.236.248:8000';
  final Logger logger = Logger();

  Future<List<SensorData>> fetchSensorData() async {
    final response = await http.get(Uri.parse('$baseUrl/api/sensor-data/'));
    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SensorData.fromJson(item)).toList();
    } else {
      logger.e('Failed to load sensor data: ${response.statusCode}');
      logger.e('Response body: ${response.body}');
      throw Exception('Failed to load sensor data');
    }
  }

  Future<List<SensorData>> fetchChartData() async {
    // Reusing the same endpoint since it's the only one available
    final response = await http.get(Uri.parse('$baseUrl/api/sensor-data/'));
    logger.i('Response status: ${response.statusCode}');
    logger.i('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => SensorData.fromJson(item)).toList();
    } else {
      logger.e('Failed to load chart data: ${response.statusCode}');
      logger.e('Response body: ${response.body}');
      throw Exception('Failed to load chart data');
    }
  }
}
