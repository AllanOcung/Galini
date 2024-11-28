import 'package:flutter/material.dart';
import 'package:galini/screens/authenticate/login_screen.dart';
import 'package:galini/screens/authenticate/role_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50), // Add spacing for the logo
            Center(
             child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "images/doctors.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Discover",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 50,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "your",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 50,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "path",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 50,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "to",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 50,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Healing.",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 50,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  '"Empowering minds, one step at a time."',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 103, 164, 245),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Galini"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
            const SizedBox(height: 10),
            Center(
              child: Material(
                color: const Color.fromARGB(255, 103, 164, 245),
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RoleSelectionScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an ",
                    style: TextStyle(
                      color: Color.fromARGB(255, 103, 164, 245),
                      fontSize: 16,
                    ),
                  ),
                  Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      const Text(
                        "Account?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 1,
                          color: Colors.blue,
                          width: 80,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
