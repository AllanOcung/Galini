import 'package:cloud_firestore/cloud_firestore.dart';

class TherapistRequest {
  final String name;
  final String specialty;
  final String email;
  final String status;
  final String requestDate; 
  final String location;
  final String phoneNumber;
  //final String role;

  TherapistRequest({
    required this.name,
    required this.specialty,
    required this.email,
    required this.status,
    required this.requestDate,
    required this.location,
    required this.phoneNumber,
  });

  factory TherapistRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TherapistRequest(
      name: data['name'] ?? '',
      specialty: data['specialty'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? 'pending',
      requestDate: (data['requestDate'] as Timestamp?)?.toDate().toString() ?? '',
      location: data['location'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  // Method to convert the TherapistRequest instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
      'email': email,
      'status': status,
      'requestDate': FieldValue.serverTimestamp(), // Automatically set timestamp on Firestore
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }
}
