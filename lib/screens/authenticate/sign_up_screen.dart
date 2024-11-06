import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galini/Services/auth.dart';
import 'package:galini/models/user.dart';
import 'package:galini/screens/authenticate/login_screen.dart';
import 'package:galini/widgets/navbar_roots.dart';

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
  String selectedRole = 'user'; // Default role is 'user'

  // This method shows a dialog in case of error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
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


  @override
  Widget build(BuildContext context) {
    return Material(
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
                      fullName = value!;
                    },
                  ),
                ),
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
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                //   child: DropdownButtonFormField<String>(
                //     value: selectedRole,
                //     decoration: const InputDecoration(
                //       labelText: "Role",
                //       border: OutlineInputBorder(),
                //       prefixIcon: Icon(Icons.person_outline),
                //     ),
                //     items: const [
                //       DropdownMenuItem(
                //         value: 'user',
                //         child: Text("Register as User"),
                //       ),
                //       DropdownMenuItem(
                //         value: 'therapist',
                //         child: Text("Register as Therapist"),
                //       ),
                //     ],
                //     onChanged: (value) {
                //       setState(() {
                //         selectedRole = value!;
                //       });
                //     },
                //   ),
                // ),
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
                            // Save the form data
                            _formKey.currentState!.save();

                            // Show loading spinner
                            setState(() {
                              isLoading = true;
                            });

                            // Sign up the user with the selected role
                            CustomUser? result = await _auth.signUp(
                              fullName,
                              email,
                              phoneNumber,
                              password
                            );

                            if (result != null) {
                               // Navigate to user dashboard
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NavBarRoots(),
                                  ),
                                );
                            } else {
                              _showErrorDialog('Sign up failed. Please try again.');
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
                              "Create Account",
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
