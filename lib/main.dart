import 'package:flutter/material.dart';
import 'package:galini/screens/welcome_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: WelcomeScreen(),
  //   );
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Galini',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 51, 172, 92),
        primaryColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: const Color.fromARGB(255, 51, 172, 92)),
      ),
      home: Center(
      child: AnimatedSplashScreen(
              splash: const Text(
                  'Galini',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                
              backgroundColor: const Color.fromARGB(255, 51, 172, 92),
              duration: 6000,
              nextScreen: const WelcomeScreen(),
              splashTransition: SplashTransition.fadeTransition,),
    ),
    );
  }
}
