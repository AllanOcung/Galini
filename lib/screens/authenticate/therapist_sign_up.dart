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

  // Form fields
  String name = '';
  String specialty = '';
  String email = '';
  String password = '';
  String experience = '';
  String qualifications = '';
  String location = '';
  String phoneNumber = '';

  // Helper method to show dialogs
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
  }

  // Async method to register therapist
  Future<void> registerTherapist() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);

      try {
        await _auth.registerTherapist(
          name,
          specialty,
          email,
          'pending', // Default status
          password,
          experience,
          qualifications,
          location,
          phoneNumber,
        );

        // Navigate to welcome screen upon successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      } catch (error) {
        _showDialog("Registration Failed", error.toString());
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  // Field widget helper
  Widget _buildField({
    required String labelText,
    required IconData prefixIcon,
    required Function(String?) onSaved,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextFormField(
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(prefixIcon),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: suffixIcon,
        ),
        keyboardType: keyboardType,
        onSaved: onSaved,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                _buildField(
                  labelText: "Full Name",
                  prefixIcon: Icons.person,
                  onSaved: (value) => name = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your full name' : null,
                ),
                _buildField(
                  labelText: "Specialty",
                  prefixIcon: Icons.work,
                  onSaved: (value) => specialty = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your specialty' : null,
                ),
                _buildField(
                  labelText: "Email Address",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => email = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                _buildField(
                  labelText: "Phone Number",
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => phoneNumber = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your phone number' : null,
                ),
                _buildField(
                  labelText: "Location",
                  prefixIcon: Icons.location_on,
                  onSaved: (value) => location = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your location' : null,
                ),
                _buildField(
                  labelText: "Experience (in years)",
                  prefixIcon: Icons.timeline,
                  keyboardType: TextInputType.number,
                  onSaved: (value) => experience = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your experience' : null,
                ),
                _buildField(
                  labelText: "About / Qualifications",
                  prefixIcon: Icons.school,
                  onSaved: (value) => qualifications = value!,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter your qualifications' : null,
                ),
                _buildField(
                  labelText: "Enter Password",
                  prefixIcon: Icons.lock,
                  obscureText: passToggle,
                  onSaved: (value) => password = value!,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  suffixIcon: InkWell(
                    onTap: () => setState(() => passToggle = !passToggle),
                    child: Icon(passToggle ? CupertinoIcons.eye_slash_fill : CupertinoIcons.eye_fill),
                  ),
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    : InkWell(
                        onTap: registerTherapist,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          width: 330,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 103, 164, 245),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      ),
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
    );
  }
}
