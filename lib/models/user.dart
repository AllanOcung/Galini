class CustomUser {
  final String uid;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;

  CustomUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  factory CustomUser.fromFirestore(Map<String, dynamic> data, String uid, String fullName, String email, String phoneNumber, String role) {
    return CustomUser(
      uid: uid,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: data['password'] ?? '',  // If you choose to store it
      role: role,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password, // Consider if you want to store the password
      'role': role,
    };
  }
}
