import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:galini/screens/admin/admin_home_screen.dart';
import 'package:galini/screens/admin/settings.dart';
import 'package:galini/screens/admin/therapists.dart';
import 'package:galini/screens/admin/users.dart';


class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int _selectedIndex = 0;
  final _adminScreens = [
    const AdminHomeScreen(), 
    const AdminUsersScreen(),    
    const AdminTherapistsScreen(),    
    AdminSettingsScreen(),    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _adminScreens[_selectedIndex],
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 103, 164, 245),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: "Home"), //Icons.check_circle
            BottomNavigationBarItem(
              icon: Icon(Icons.group), label: "Clients"),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userDoctor), label: "Therapists"),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), label: "Admin Settings"),
          ],
        ),
      ),
    );
  }
}
