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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 60),           
            Padding(
              padding: const EdgeInsets.all(10),             
              child: Image.asset(
                "images/doctors.png",
                 width: 150,
                 height: 150,
                ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Galini",
              style: TextStyle(
                color: Color.fromARGB(255, 103, 164, 245),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),           
            const Text(
              "Empathy at your fingertips",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                //fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 10),
            // Brief Intro
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "''Discover tools and connect with therapists to help you on your mental health journey. Let's heal together.''",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Material(
                  color: const Color.fromARGB(255, 103, 164, 245),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ));
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: const Color.fromARGB(255, 103, 164, 245),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RoleSelectionScreen(),
                          ));
                    },
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
            const Spacer(),
                // Privacy Assurance
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Your data is secure and private with us.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
