import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistApproval extends StatefulWidget {
  const TherapistApproval({Key? key}) : super(key: key);

  @override
  _TherapistApprovalState createState() => _TherapistApprovalState();
}

class _TherapistApprovalState extends State<TherapistApproval> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<TherapistRequest>> _fetchPendingRequests() {
    return _firestore
        .collection('therapist_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TherapistRequest.fromFirestore(doc))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapist Approval Section'),
      ),
      body: StreamBuilder<List<TherapistRequest>>(
        stream: _fetchPendingRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pending requests.'));
          }

          final pendingRequests = snapshot.data!;

          return ListView.builder(
            itemCount: pendingRequests.length,
            itemBuilder: (context, index) {
              final request = pendingRequests[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(request.name),
                  subtitle: Text(request.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _updateRequestStatus(request.id, 'approved'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () => _updateRequestStatus(request.id, 'rejected'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateRequestStatus(String requestId, String status) {
    _firestore.collection('therapist_requests').doc(requestId).update({
      'status': status,
    }).then((_) {
      // Optionally notify the therapist via email or Firebase messaging here
      print('Request status updated to $status');
    }).catchError((error) {
      print('Failed to update status: $error');
    });
  }
}

class TherapistRequest {
  final String id;
  final String name;
  final String email;

  TherapistRequest({required this.id, required this.name, required this.email});

  factory TherapistRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TherapistRequest(
      id: doc.id,
      name: data['name'],
      email: data['email'],
    );
  }
}




