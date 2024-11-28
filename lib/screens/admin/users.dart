import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Center(child: Text("Patients")),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 50, // Adjusts height of the search field
              width: 350,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search Clients...",
                  filled: true,
                  fillColor: Colors.white, // Light grey background
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded edges
                    borderSide: BorderSide.none, // Removes default border
                  ),
                ),
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('role', isEqualTo: 'user')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No patients found."),
                    );
                  }
                  final patients = snapshot.data!.docs;

                  // Sort patients alphabetically by name
                  patients.sort((a, b) {
                    final nameA = a['fullName'] ?? '';
                    final nameB = b['fullName'] ?? '';
                    return nameA.compareTo(nameB);
                  });


                  return ListView.builder(
                    itemCount: patients.length,
                    itemBuilder: (context, index) {
                      final patient = patients[index].data() as Map<String, dynamic>;
                      final name = patient['fullName'] ?? 'Unknown';
                      final email = patient['email'] ?? 'No email';

                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("images/doctor1.jpg"),
                        ),
                        title: Text(name),
                        subtitle: Text(email),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteUser(patients[index].id);
                          },
                        ),
                        onTap: () {
                          // Option to view user profile
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      debugPrint("User deleted: $userId");
    } catch (e) {
      debugPrint("Failed to delete user: $e");
    }
  }
}
