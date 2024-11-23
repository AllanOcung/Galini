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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("images/back3.jpg"), // Your background image path
            fit: BoxFit.cover,
            alignment: Alignment.center,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2), // Darker overlay for better readability
              BlendMode.darken,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align everything to the start (left)
          children: [
            const SizedBox(height: 200),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "Find",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
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
                    "the best",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
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
                    "therapist",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
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
                    "for you.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 55,
                      height: 1.2,
                      letterSpacing: 2,
                      wordSpacing: 2,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  '"Empathy at your fingertips"',
                  textAlign: TextAlign.left, // Align text to the left
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Adjusted for visibility
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                      "Let's Start!",
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
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                
                children: [
                  Text(
                    "I have an ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                  Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      //decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
