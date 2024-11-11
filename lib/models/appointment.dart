class Appointment {
  String appointmentId;
  String patientId;
  String therapistId;
  DateTime appointmentDate;
  String timeSlot;
  String status; // e.g., "pending", "confirmed", "completed"

  Appointment({
    required this.appointmentId,
    required this.patientId,
    required this.therapistId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
  });

  // Convert Appointment object to Firestore document format
  Map<String, dynamic> toMap() {
    return {
      'appointmentId': appointmentId,
      'patientId': patientId,
      'therapistId': therapistId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'timeSlot': timeSlot,
      'status': status,
    };
  }

  // Create Appointment object from Firestore document
  static Appointment fromMap(Map<String, dynamic> map) {
    return Appointment(
      appointmentId: map['appointmentId'],
      patientId: map['patientId'],
      therapistId: map['therapistId'],
      appointmentDate: DateTime.parse(map['appointmentDate']),
      timeSlot: map['timeSlot'],
      status: map['status'],
    );
  }
}
