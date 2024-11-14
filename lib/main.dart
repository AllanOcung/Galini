//import the Firebase core plugin and the configuration file
import 'package:firebase_core/firebase_core.dart';
import 'package:galini/Services/firebase_api.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:galini/Services/auth.dart';
import 'package:galini/models/user.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/welcomeScreen/welcome_screen.dart';
import 'package:galini/screens/home/home_screen.dart';  
import 'package:animated_splash_screen/animated_splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
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
        home: const SplashWrapper(),  // Use the wrapper for splash screen
      ),
    );
  }
}

// Wrapper to determine the next screen after splash
class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser?>(context);

    return AnimatedSplashScreen(
      backgroundColor: const Color.fromARGB(255, 103, 164, 245),
      splash: const Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [     
          Text(
            'Galini',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          // SizedBox(height: 2),
          // Text(
          //   'Empathy at your fingertips',
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontStyle: FontStyle.italic,
          //     color: Colors.white70,
          //   ),
          // ),
        ],
      ),
      duration: 6000,
      splashTransition: SplashTransition.fadeTransition,
      // Direct user based on login state
      nextScreen: user == null ? const WelcomeScreen() : const HomeScreen(),
    );
  }
}
