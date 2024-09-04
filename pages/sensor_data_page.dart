import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/sensor_data.dart';
import 'package:go_router/go_router.dart';

class SensorDataPage extends StatefulWidget {
  final ApiService apiService;

  const SensorDataPage({super.key, required this.apiService});

  @override
  _SensorDataPageState createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late Future<List<SensorData>> _sensorDataFuture;

  @override
  void initState() {
    super.initState();
    _sensorDataFuture = widget.apiService.fetchSensorData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _sensorDataFuture = widget.apiService.fetchSensorData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<SensorData>>(
        future: _sensorDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final now = DateTime.now();
            final oneHourAgo = now.subtract(Duration(hours: 1));

            // Filter data from the last hour
            final recentData = data.where((e) => e.timestamp.isAfter(oneHourAgo)).toList();
            final validData = recentData.where((e) => e.temperature != null && e.humidity != null).toList();

            double avgTemp = 0;
            double avgHumidity = 0;

            if (validData.isNotEmpty) {
              avgTemp = validData.map((e) => e.temperature!).reduce((a, b) => a + b) / validData.length;
              avgHumidity = validData.map((e) => e.humidity!).reduce((a, b) => a + b) / validData.length;
            }

            // Format averages to 1 decimal point
            String avgTempFormatted = avgTemp.toStringAsFixed(1);
            String avgHumidityFormatted = avgHumidity.toStringAsFixed(1);

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Average Temperature (Last Hour): $avgTempFormatted °C', style: const TextStyle(fontSize: 20)),
                        Text('Average Humidity (Last Hour): $avgHumidityFormatted %', style: const TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Timestamp')),
                        DataColumn(label: Text('Temperature (°C)')),
                        DataColumn(label: Text('Humidity (%)')),
                      ],
                      rows: data.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.timestamp.toString())),
                            DataCell(Text(item.temperature.toString())),
                            DataCell(Text(item.humidity.toString())),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.go('/settings');
          }
        },
      ),
    );
  }
}
