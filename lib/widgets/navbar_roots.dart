import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/home/home_screen.dart';
import 'package:galini/screens/home/messages_screen.dart';
import 'package:galini/screens/home/schedule_screen.dart';
import 'package:galini/screens/home/therapist_finder_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galini/screens/therapist/assessment_categories_screen.dart';

class NavBarRoots extends StatefulWidget {
  const NavBarRoots({super.key});

  @override
  State<NavBarRoots> createState() => _NavBarRootsState();
}

class _NavBarRootsState extends State<NavBarRoots> {
  int _selectedIndex = 0;
  String? _userId; // Variable to store the logged-in user's ID

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getUserId();
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  final _screens = [
    const HomeScreen(),
    // MessagesScreen expects userId as a parameter
    // We'll set it later after fetching the user ID
    null, 
    const ScheduleScreen(),
    const AssessmentCategoriesScreen(),
    //const SelfAssessmentScreen(),
    const TherapistFinderScreen(),
  ];

  // Fetch user ID from Firestore or Firebase Authentication
  Future<void> _getUserId() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, get the user ID from Firebase
        setState(() {
          _userId = user.uid; // Set the logged-in user's ID
        });
      }
    } catch (e) {
      print("Error fetching user ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Update the second screen to pass the user ID if available
    if (_userId != null) {
      _screens[1] = MessagesScreen(currentUserId: _userId!); // Pass the user ID
    }

    return Scaffold(
      backgroundColor: const Color(0xFFD3E9FF),
      body: _screens[_selectedIndex] ?? const SizedBox.shrink(), // Show empty if not ready
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10), // Margin to give "floating" effect
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0, // Remove default elevation
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 103, 164, 245),
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
          ),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.chat_bubble_text_fill,
              ),
              label: "Messages",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              label: "Schedule",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement),
              label: "Self-Assessment",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userDoctor),
              label: "Therapist",
            ),
          ],
        ),
      ),
    );
  }
}












// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:galini/screens/home/home_screen.dart';
// import 'package:galini/screens/home/messages_screen.dart';
// import 'package:galini/screens/home/schedule_screen.dart';
// import 'package:galini/screens/home/self_assessment_screen.dart';
// import 'package:galini/screens/home/therapist_finder_screen.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class NavBarRoots extends StatefulWidget {
//   const NavBarRoots({super.key});

//   @override
//   State<NavBarRoots> createState() => _NavBarRootsState();
// }

// class _NavBarRootsState extends State<NavBarRoots> {
//   int _selectedIndex = 0;
//   final _screens = [
//     const HomeScreen(),
//     MessagesScreen(),
//     const ScheduleScreen(),
//     const SelfAssessmentScreen(),
//     const TherapistFinderScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:const Color(0xFFD3E9FF),
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: Container(
//         margin: const EdgeInsets.all(10), // Margin to give "floating" effect
//         decoration: BoxDecoration(
//           color: Colors.white.withOpacity(0.9),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             const BoxShadow(
//               color: Colors.black12,
//               blurRadius: 10,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           elevation: 0, // Remove default elevation
//           backgroundColor: Colors.transparent,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: const Color.fromARGB(255, 103, 164, 245),
//           unselectedItemColor: Colors.black26,
//           selectedLabelStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontSize: 13,
//           ),
//           currentIndex: _selectedIndex,
//           onTap: (index) {
//             setState(() {
//               _selectedIndex = index;
//             });
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home_filled),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                   CupertinoIcons.chat_bubble_text_fill,
//                 ),
//               label: "Messages",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_month_outlined),
//               label: "Schedule",
//             ),
//             BottomNavigationBarItem(
//                icon: Icon(Icons.self_improvement),
//               label: "Self-Assessment",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(FontAwesomeIcons.userDoctor),
//               label: "Therapist",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
