import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/home/home_screen.dart';
import 'package:galini/screens/home/messages_screen.dart';
import 'package:galini/screens/home/schedule_screen.dart';
import 'package:galini/screens/home/self_assessment_screen.dart';
import 'package:galini/screens/home/therapist_finder_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  final _screens = [
    const HomeScreen(),
    MessagesScreen(),
    const ScheduleScreen(),
    const SelfAssessmentScreen(),
    const TherapistFinderScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
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
                icon: Icon(Icons.home_filled), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(
                  CupertinoIcons.chat_bubble_text_fill,
                ),
                label: "Messages"),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined), label: "Schedule"),
            BottomNavigationBarItem(
                icon: Icon(Icons.self_improvement), label: "Self-Assessment"),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.userDoctor), label: "Therapist"),
          ],
        ),
      ),
    );
  }
}



