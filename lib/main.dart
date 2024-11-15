// Import required packages and Firebase setup
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:galini/screens/admin/admin_navbar.dart';
import 'package:galini/screens/therapist/navbar_roots.dart';
import 'package:galini/widgets/navbar_roots.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:galini/Services/auth.dart';
import 'package:galini/models/user.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/welcomeScreen/welcome_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
//import 'package:page_transition/page_transition.dart'; // For smooth screen transitions

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseApi().initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: Authenticate().customUser,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Galini',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 103, 164, 245),
          primaryColor: Colors.white,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: const Color.fromARGB(255, 103, 164, 245),
              ),
        ),
        home: const SplashWrapper(),
      ),
    );
  }
}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return AnimatedSplashScreen(
      splash: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Galini',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 103, 164, 245),
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      animationDuration: const Duration(milliseconds: 800),
      nextScreen: user == null
          ? const WelcomeScreen()
          : FutureBuilder<String>(
              future: getUserRole(user.uid), // Check role dynamically
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.hasData) {
                  return const WelcomeScreen(); // Fallback in case of error
                } else {
                  switch (snapshot.data) {
                    case 'user':
                      return const NavBarRoots();
                    case 'therapist':
                      return const NavBarRoot();
                    case 'admin':
                      return const AdminNavBar();
                    default:
                      return const WelcomeScreen(); // Fallback for unknown roles
                  }
                }
              },
            ),
    );
  }
}


Future<String> getUserRole(String uid) async {
  // Fetch the user data from the main users collection
  final userDoc = await FirebaseApi.getUserDocument(uid); // Adjust method to match your Firebase structure
  if (userDoc != null && userDoc['role'] == 'user') {
    return 'user';
  }

  // Check the therapist_requests collection
  final therapistDoc = await FirebaseApi.getTherapistDocument(uid);
  if (therapistDoc != null) {
    return 'therapist';
  }

  // Add any additional collections for admin or other roles
  if (userDoc != null && userDoc['role'] == 'admin') {
    return 'admin';
  }

  return 'unknown'; // Fallback for undefined roles
}


class FirebaseApi {
  // Fetch user document from the main 'users' collection
  static Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
      final userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        return userSnapshot.data(); // Return the user data as a map
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching user document: $e");
      return null; // Handle errors gracefully
    }
  }

  // Fetch therapist document from the 'therapist_requests' collection
  static Future<Map<String, dynamic>?> getTherapistDocument(String uid) async {
    try {
      final therapistRef = FirebaseFirestore.instance
          .collection('therapist_requests')
          .doc(uid);
      final therapistSnapshot = await therapistRef.get();

      if (therapistSnapshot.exists) {
        return therapistSnapshot.data(); // Return the therapist data as a map
      } else {
        return null; // Return null if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching therapist document: $e");
      return null; // Handle errors gracefully
    }
  }
}
