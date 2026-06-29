import 'package:flutter/material.dart';
import 'package:zuperr/Screens/Analytics/analytics.dart';
import 'package:zuperr/Screens/Companies/companies.dart';
import 'package:zuperr/Screens/HomeScreen/HomeScreen.dart';
import 'package:zuperr/Screens/ProfileScreen/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),        // 👈 your existing UI
    const CompaniesScreen(),
    const Analytics(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // ✅ keeps state
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xff1E6BE3),
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: "Companies"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analytics"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}