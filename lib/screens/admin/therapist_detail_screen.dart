import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestDetailScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailScreen({super.key, required this.requestId});

  @override
  _RequestDetailScreenState createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  Map<String, dynamic>? therapistData;

  @override
  void initState() {
    super.initState();
    fetchTherapistDetails();
  }

  Future<void> fetchTherapistDetails() async {
    try {
      DocumentSnapshot requestDoc = await FirebaseFirestore.instance
          .collection('therapist_requests')
          .doc(widget.requestId)
          .get();

      String therapistId = requestDoc['uid'];
      DocumentSnapshot therapistDoc = await FirebaseFirestore.instance
          .collection('therapist_requests')
          .doc(therapistId)
          .get();

      setState(() {
        therapistData = therapistDoc.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print('Error fetching therapist details: $e');
    }
  }

Future<void> approveRequest() async {
  try {
    final therapistRequestRef = FirebaseFirestore.instance
        .collection('therapist_requests')
        .doc(widget.requestId);

    // First, update the status to "approved"
    await therapistRequestRef.update({'status': 'approved'});

    // After updating the status, the Firebase function will automatically trigger
    print("Request approved, email will be sent, and therapist moved to 'users' collection.");
  } catch (e) {
    print("Error approving request: $e");
  }
}



  Future<void> rejectRequest() async {
    try {
       final therapistRequestRef = FirebaseFirestore.instance
        .collection('therapist_requests')
        .doc(widget.requestId);

      // Update the status to "rejected" and then delete the document
      await therapistRequestRef.update({'status': 'rejected'});
      await therapistRequestRef.delete();

      print("Request rejected.");
    } catch (e) {
      print("Error rejecting request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (therapistData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Therapist Details"),
          backgroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Therapist Details'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("images/doctor1.jpg"),
            ),
            const SizedBox(height: 20),
            Text(
              therapistData!['name'] ?? 'N/A',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              therapistData!['email'] ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.grey[300], thickness: 1),
            const SizedBox(height: 16),
            _buildDetailRow("Phone", therapistData!['phoneNumber'] ?? 'N/A'),
            _buildDetailRow("Location", therapistData!['location'] ?? 'N/A'),
            _buildDetailRow("Experience", "${therapistData!['experience'] ?? 'N/A'} years"),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "About the Therapist:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              therapistData!['qualifications'] ?? 'No information available.',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton("Approve", const Color.fromARGB(255, 103, 164, 245), approveRequest),
                _buildActionButton("Reject", Colors.red, rejectRequest),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            "$title:",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
