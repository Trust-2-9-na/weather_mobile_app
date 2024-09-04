// lib/models/sensor_data.dart

// ignore_for_file: unused_import
import 'dart:convert';

class SensorData {
  final DateTime timestamp;
  final double? temperature;
  final double? humidity;

  SensorData({
    required this.timestamp,
    this.temperature,
    this.humidity,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      timestamp: DateTime.parse(json['timestamp']),
      temperature: (json['temperature'] as num?)?.toDouble(),
      humidity: (json['humidity'] as num?)?.toDouble(),
      
    );
  }
}
