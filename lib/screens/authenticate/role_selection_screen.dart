import 'package:flutter/material.dart';
import 'package:galini/screens/authenticate/sign_up_screen.dart';
import 'package:galini/screens/authenticate/therapist_sign_up.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  bool isPatientSelected = true; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  const  Text(
              "Register As",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 103, 164, 245),
              ),
            ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRoleButton(
                label: "Patient",
                isSelected: isPatientSelected,
                onTap: () {
                  setState(() {
                    isPatientSelected = true;
                  });
                },
              ),
              const SizedBox(width: 20),
              Image.asset(
              "images/doctors.png", // Path to your image
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 20),
              _buildRoleButton(
                label: "Therapist",
                isSelected: !isPatientSelected,
                onTap: () {
                  setState(() {
                    isPatientSelected = false;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: isPatientSelected
                ? const SignUpScreen() // Patient registration form
                : const TherapistSignUpScreen(), // Therapist registration form
          ),
        ],
      ),
    );
  }

  Widget _buildRoleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 103, 164, 245) // Selected color
              : Colors.white, // Unselected color
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 103, 164, 245),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color.fromARGB(255, 103, 164, 245),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
