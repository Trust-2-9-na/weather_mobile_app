import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 3; // Set the initial index to 3 for Settings

  bool _isCelsius = true;
  bool _humidityAlert = false;
  bool _temperatureAlert = false;
  bool _notificationsEnabled = true;
  int _refreshInterval = 15;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/sensorData');
        break;
      case 1:
        context.go('/averages');
        break;
      case 2:
        context.go('/charts');
        break;
      case 3:
        context.go('/home');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.thermostat),
            title: Text('Temperature Unit'),
            trailing: DropdownButton<bool>(
              value: _isCelsius,
              items: [
                DropdownMenuItem(
                  value: true,
                  child: Text('Celsius'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('Fahrenheit'),
                ),
              ],
              onChanged: (bool? value) {
                setState(() {
                  _isCelsius = value!;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.water_damage),
            title: Text('Humidity Alerts'),
            trailing: Switch(
              value: _humidityAlert,
              onChanged: (bool value) {
                setState(() {
                  _humidityAlert = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.thermostat_outlined),
            title: Text('Temperature Alerts'),
            trailing: Switch(
              value: _temperatureAlert,
              onChanged: (bool value) {
                setState(() {
                  _temperatureAlert = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Data Refresh Interval (minutes)'),
            trailing: DropdownButton<int>(
              value: _refreshInterval,
              items: [5, 10, 15, 30, 60].map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
              onChanged: (int? value) {
                setState(() {
                  _refreshInterval = value!;
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors, size: 30),
            label: 'Sensor Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, size: 30),
            label: 'Averages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 30),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
