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

  final homeKey = GlobalKey<HomeScreenState>();
  final companyKey = GlobalKey<CompaniesScreenState>();
  final analyticsKey = GlobalKey<AnalyticsState>();
  final profileKey = GlobalKey<ProfileScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(key: homeKey),
          CompaniesScreen(key: companyKey),
          Analytics(key: analyticsKey),
          ProfileScreen(key: profileKey),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffF8F8F8), // or Colors.white
        selectedItemColor: const Color(0xff1E6BE3),
        unselectedItemColor: Colors.black54,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          switch (index) {
            case 0:
              homeKey.currentState?.refreshData();
              break;
            case 1:
              companyKey.currentState?.refreshData();
              break;
            case 2:
              analyticsKey.currentState?.refreshData();
              break;
            case 3:
              profileKey.currentState?.refreshData();
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Companies",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
