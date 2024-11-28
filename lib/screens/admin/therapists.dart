import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTherapistsScreen extends StatelessWidget {
  const AdminTherapistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Center(child: Text("Therapists")),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                  labelText: "Search Therapists...",
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
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('therapist_requests')
                    .where('status', isEqualTo: 'approved')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error loading data"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No approved therapists found"));
                  }

                  final therapists = snapshot.data!.docs;

                  // Sort patients alphabetically by name
                  therapists.sort((a, b) {
                    final nameA = a['name'] ?? '';
                    final nameB = b['name'] ?? '';
                    return nameA.compareTo(nameB);
                  });

                  return ListView.builder(
                    itemCount: therapists.length,
                    itemBuilder: (context, index) {
                      final therapist = therapists[index];
                      final therapistId = therapist.id;
                      final therapistName = therapist['name'] ?? 'No Name';
                      final therapistEmail = therapist['email'] ?? 'No Email';

                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(therapistName),
                        subtitle: Text(therapistEmail),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteTherapist(therapistId);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          // Option to view therapist profile or other actions
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => TherapistManagementScreen()),
                          // );
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

  // Function to delete therapist from Firestore
  void _deleteTherapist(String therapistId) async {
    try {
      await FirebaseFirestore.instance
          .collection('therapist_requests')
          .doc(therapistId)
          .delete();
      debugPrint("Therapist deleted: $therapistId");
    } catch (e) {
      debugPrint("Failed to delete therapist: $e");
    }
  }
}
