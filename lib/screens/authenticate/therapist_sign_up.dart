import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/Services/auth.dart';
import 'package:galini/screens/authenticate/login_screen.dart';
import 'package:galini/screens/welcomeScreen/welcome_screen.dart';

class TherapistSignUpScreen extends StatefulWidget {
  const TherapistSignUpScreen({super.key});

  @override
  State<TherapistSignUpScreen> createState() => _TherapistSignUpScreenState();
}

class _TherapistSignUpScreenState extends State<TherapistSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final Authenticate _auth = Authenticate();
  
  bool passToggle = true;
  bool isLoading = false;
  String name = '';
  String email = '';
  String status = '';
  String experience = '';
  String qualifications = '';
  String password = '';
  String location = '';
  String phoneNumber = '';
  //String selectedRole = 'therapist'; // Default role is 'therapist'


  // This method shows a dialog in case of success or failure
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

    Future<void> registerTherapist() async {
    setState(() => isLoading = true);
    try {
      await _auth.registerTherapist(
        name,
        email,
        status,
        password,
        experience,
        qualifications,
        location,
        phoneNumber,
      );
    } catch (e) {
      _showDialog("Error", "Registration failed: ${e.toString()}");
    } finally {
      setState(() => isLoading = false);
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "images/doctors.png",
                    width: 150,
                    height: 150,
                  ),
                ),
                // Name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value!;
                    },
                  ),
                ),
                // Email
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                // Phone
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value!;
                    },
                  ),
                ),
                // Location
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Location",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      location = value!;
                    },
                  ),
                ),
                // Experience
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Experience (in years)",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timeline),
                    ),
                    onSaved: (value) {
                      experience = value!;
                    },
                  ),
                ),
                // Qualifications
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "About",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    onSaved: (value) {
                      qualifications = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TextFormField(
                    obscureText: passToggle,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      label: const Text("Enter Password"),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: passToggle
                            ? const Icon(CupertinoIcons.eye_slash_fill)
                            : const Icon(CupertinoIcons.eye_fill),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : InkWell(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() => isLoading = true); // Start loading

                          try {
                            // Call the async register function and await completion
                            await registerTherapist();

                            // Navigate to the welcome screen if successful
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                            );
                          } catch (error) {
                            // Show error dialog if registration fails
                            _showDialog("Registration Failed", error.toString());
                          } finally {
                            setState(() => isLoading = false); // Stop loading
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: 330,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 103, 164, 245),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "Create account",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 103, 164, 245),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
