import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:logging/logging.dart';

class NetworkService {
  final Logger _logger = Logger('NetworkService');

  NetworkService() {
    _setupLogging();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL; // Set the logging level
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> fetchData() async {
    const timeoutDuration = Duration(seconds: 30); // Use const for the timeout duration

    try {
      final response = await http.get(
        Uri.parse('http://172.16.60.112:8023/api/sensor-data/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(timeoutDuration); // Use the const timeout duration

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON.
        _logger.info('Response data: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        _logger.warning('Failed to load data. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      _logger.severe('SocketException: $e');
    } on TimeoutException catch (e) {
      _logger.severe('TimeoutException: $e');
    } catch (e) {
      _logger.severe('Other Exception: $e');
    }
  }
}
