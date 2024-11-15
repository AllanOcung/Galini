import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/therapist/appointment_screen.dart';
import 'package:galini/screens/therapist/home_screen.dart';
import 'package:galini/screens/therapist/inbox_screen.dart';
import 'package:galini/screens/therapist/more_screen.dart';
import 'package:galini/screens/therapist/patient_screen.dart';
//import 'package:provider/provider.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class NavBarRoot extends StatefulWidget {
  const NavBarRoot({Key? key}) : super(key: key);

  @override
  State<NavBarRoot> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoot> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const PatientsScreen(),
    ChatsScreen(),
    TherapistAppointmentsScreen(),
    MoreScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Responsive bottom padding for devices with varying screen sizes
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF7D99AA),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(), // Smooth scroll effect
        children: _screens,       
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        padding: EdgeInsets.only(bottom: bottomPadding), // Adaptive bottom padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15, // Increased for a more distinct floating effect
              spreadRadius: 3,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF7D99AA),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
          ),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: "Patients",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_text_fill),
              label: "Inbox",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Appointments",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "More",
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
