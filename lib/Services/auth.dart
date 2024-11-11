import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galini/models/user.dart';
import 'package:bcrypt/bcrypt.dart';

class Authenticate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create CustomUser object based on Firebase User
  CustomUser? _userFromFirebaseUser(User? user, {String? fullName, String? email, String? phoneNumber, String? password, String? role}) {
    return user != null
        ? CustomUser(
            uid: user.uid,
            fullName: fullName ?? '',
            email: email ?? '',
            phoneNumber: phoneNumber ?? '',
            password: password ?? '',
            role: role ?? '',
          )
        : null;
  }

  // Auth change user stream
  Stream<CustomUser?> get customUser {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;

      // Fetch additional user data from Firestore
      DocumentSnapshot<Map<String, dynamic>> userData = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic>? data = userData.data();

      // Ensure all required arguments are passed to fromFirestore
      String fullName = data?['fullName'] ?? '';
      String email = data?['email'] ?? '';
      String phoneNumber = data?['phoneNumber'] ?? '';
      String role = data?['role'] ?? '';

      if (data != null) {
        return CustomUser.fromFirestore(data, user.uid, fullName, email, phoneNumber, role);
      } else {
        throw Exception('User data not found in Firestore.');
      }
        });
  }

  // Register Therapist with email and password
  Future<void> registerTherapist(String name, String email, String status, String password, String experience, String qualifications, String location, String phoneNumber) async {
    try {
      // Step 1: Register therapist with Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Step 2: Hash the password and store additional therapist details in Firestore
      if (user != null) {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        await _firestore.collection('therapist_requests').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'status': 'pending',
          'experience': experience,
          'qualifications': qualifications,
          'password': hashedPassword,
          'role': 'therapist',
          'requestDate': FieldValue.serverTimestamp(),
          'location': location,
          'phoneNumber': phoneNumber,
        });
      } else {
        throw Exception('Failed to create therapist user.');
      }
    } catch (error) {
      throw Exception('Failed to submit therapist registration: ${error.toString()}');
    }
  }

  // Sign-up for regular users with email & password
  Future<CustomUser?> signUp(String fullName, String email, String phoneNumber, String password) async {
    try {
      // Step 1: Register user with Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Step 2: Store additional user details in Firestore
      if (user != null) {
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

        CustomUser newUser = CustomUser(
          uid: user.uid,
          fullName: fullName,
          email: email,
          phoneNumber: phoneNumber,
          password: hashedPassword,
          role: 'user',
          hasCompletedIntro: false,
        );

        // Save to Firestore
        await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Sign-up failed: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<CustomUser?> signIn(String email, String password) async {
    try {
      // Step 1: Authenticate with Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Step 2: Fetch Additional user details from Firestore
      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          String role = userData.data()?['role'] ?? '';
          String fullName = userData.data()?['fullName'] ?? '';
          String phoneNumber = userData.data()?['phoneNumber'] ?? '';
          String email = userData.data()?['email'] ?? '';

          return CustomUser.fromFirestore(userData.data()!, user.uid, fullName, email, phoneNumber, role);
        } else {
          throw Exception('User data not found in Firestore.');
        }
      } else {
        throw Exception('No user found after authentication.');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
