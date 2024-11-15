import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/Services/auth.dart';
import 'package:galini/models/user.dart';
import 'package:galini/screens/authenticate/login_screen.dart';
import 'package:galini/screens/authenticate/first_time_questionnaire_screen.dart'; // Ensure this screen exists
import 'package:galini/widgets/navbar_roots.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final Authenticate _auth = Authenticate();
  bool passToggle = true;

  bool isLoading = false;

  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String password = '';

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sign-up Error"),
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

  // Method to check if this is the first time login
  Future<void> checkFirstTimeLogin(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists && userDoc['hasCompletedIntro'] == true) {
        // Navigate to the main dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const NavBarRoots(),
          ),
        );
      } else {
        // Navigate to the first-time questionnaire screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirstTimeQuestionnaireScreen(userId: userId),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog('Failed to check user status. Please try again.');
      print('Error in checkFirstTimeLogin: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Allows the layout to adjust for the keyboard
      body: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey, // Form key to validate the form
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        prefixIcon: const Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2, ),
                        borderRadius: BorderRadius.circular(10), // Focused border color
                      ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        fullName = value!;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        prefixIcon: const Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2, ),
                        borderRadius: BorderRadius.circular(10), // Focused border color
                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        prefixIcon: const Icon(Icons.phone),
                        focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2, ),
                        borderRadius: BorderRadius.circular(10), // Focused border color
                      ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    child: TextFormField(
                      obscureText: passToggle,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),),
                        label: const Text("Enter Password"),
                        prefixIcon: const Icon(Icons.lock),
                        focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue, width: 2, ),
                        borderRadius: BorderRadius.circular(10), // Focused border color
                      ),
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
                      ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),))
                      : InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              // Save the form data
                              _formKey.currentState!.save();
      
                              // Show loading spinner
                              setState(() {
                                isLoading = true;
                              });
      
                              try {
                                // Sign up the user
                                CustomUser? result = await _auth.signUp(
                                  fullName,
                                  email,
                                  phoneNumber,
                                  password,
                                );
      
                                if (result != null) {
                                  // Check if it's the first time login
                                  await checkFirstTimeLogin(result.uid);
                                } else {
                                  _showErrorDialog('Sign up failed. Please try again.');
                                }
                              } catch (e) {
                                _showErrorDialog('$e');
                                print('Sign-up error: $e');
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
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
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(height: 10),
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
                          "Sign In",
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
          ),
    );
      }
    }