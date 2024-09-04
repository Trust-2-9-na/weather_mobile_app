import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/sensor_data_page.dart';
import 'pages/charts_page.dart';
import 'pages/settings.dart';  // Import the settings page
import 'services/api_service.dart';
import 'services/network_service.dart'; // Import the network service

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService apiService = ApiService();
  final NetworkService networkService = NetworkService(); // Initialize the network service

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => HomePage(apiService: apiService, networkService: networkService),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => HomePage(apiService: apiService, networkService: networkService),
        ),
        GoRoute(
          path: '/sensorData',
          builder: (context, state) => SensorDataPage(apiService: apiService),
        ),
        GoRoute(
          path: '/charts',
          builder: (context, state) => ChartsPage(apiService: apiService),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => SettingsPage(),  // Add the settings route
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          elevation: 10,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class HomePage extends StatefulWidget {
  final ApiService apiService;
  final NetworkService networkService; // Add the network service

  const HomePage({super.key, required this.apiService, required this.networkService});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Sensor Data', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('Averages Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text('Charts Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/sensorData');
        break;
      case 1:
        context.go('/charts');
        break;
      case 2:
        context.go('/settings');  // Navigate to settings
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _widgetOptions.elementAt(_selectedIndex),
            ElevatedButton(
              onPressed: () {
                widget.networkService.fetchData(); // Call the network service
              },
              child: const Text('Fetch Data'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors, size: 30),
            label: 'Sensor Data',
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
