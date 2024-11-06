import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galini/screens/admin/therapist_detail_screen.dart';
import 'package:intl/intl.dart';

class RequestsListScreen extends StatefulWidget {
  const RequestsListScreen({super.key});

  @override
  _RequestsListScreenState createState() => _RequestsListScreenState();
}

class _RequestsListScreenState extends State<RequestsListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchPendingRequests(); // Fetch the pending requests when the screen initializes
  }

  Future<void> fetchPendingRequests() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('therapist_requests')
          .where('status', isEqualTo: 'pending')
          .get();

      setState(() {
        _pendingRequests = snapshot.docs; // Set the list of pending requests
      });
    } catch (e) {
      print('Error fetching pending requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Pending Requests"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _pendingRequests.isEmpty
            ? const Center(child: Text("No pending requests found."))
            : ListView.builder(
                itemCount: _pendingRequests.length,
                itemBuilder: (context, index) {
                  final request = _pendingRequests[index];
                  Timestamp requestDateTimestamp = request['requestDate']; // Get the Timestamp
                  DateTime requestDate = requestDateTimestamp.toDate(); // Convert to DateTime
                  // Format the date and time using intl package
                  String formattedDateTime = DateFormat('yyyy-MM-dd kk:mm').format(requestDate);

                  return GestureDetector(
                    onTap: () {
                      // Navigate to the request detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetailScreen(requestId: request.id), // Pass the request ID
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage("images/doctor1.jpg"), // Use a placeholder image
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request['name'] ?? 'Unknown Therapist',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                // Displaying date and time in one Text widget
                                Text("Request Date: $formattedDateTime", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                //Text("Request Date: ${requestDate.toLocal().toString().split(' ')[0]}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ); 
                },
              ),
      ),
    );
  }
}
