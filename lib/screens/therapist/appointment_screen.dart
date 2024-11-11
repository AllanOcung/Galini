// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class TherapistAppointmentsScreen extends StatefulWidget {
//   @override
//   _TherapistAppointmentsScreenState createState() =>
//       _TherapistAppointmentsScreenState();
// }

// class _TherapistAppointmentsScreenState
//     extends State<TherapistAppointmentsScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Map<String, dynamic>> pendingAppointments = [];
//   List<Map<String, dynamic>> upcomingAppointments = [];
//   List<Map<String, dynamic>> declinedAppointments = [];
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchAppointments();
//   }

//   // Fetch appointments categorized by their status with real-time updates
//   void _fetchAppointments() {
//     final user = _auth.currentUser;
//     if (user != null) {
//       _firestore
//           .collection('appointments')
//           .where('therapistId', isEqualTo: user.uid)
//           .snapshots()
//           .listen((snapshot) {
//         setState(() {
//           pendingAppointments = [];
//           upcomingAppointments = [];
//           declinedAppointments = [];
//           _isLoading = false;

//           for (var doc in snapshot.docs) {
//             final appointment = {
//               'appointmentId': doc.id,
//               'patientId': doc['patientId'],
//               'patientName': doc['patientName'],
//               'appointmentDate': doc['appointmentDate'].toDate(),
//               'timeSlot': doc['timeSlot'],
//               'status': doc['status'],
//             };

//             switch (doc['status']) {
//               case 'pending':
//                 pendingAppointments.add(appointment);
//                 break;
//               case 'approved':
//                 upcomingAppointments.add(appointment);
//                 break;
//               case 'declined':
//                 declinedAppointments.add(appointment);
//                 break;
//             }
//           }
//         });
//       });
//     }
//   }

//   // Action methods with error handling
//   Future<void> _updateAppointmentStatus(
//       String appointmentId, String newStatus) async {
//     try {
//       await _firestore.collection('appointments').doc(appointmentId).update({
//         'status': newStatus,
//       });
//     } catch (e) {
//       _showErrorDialog('Failed to update appointment status');
//     }
//   }

//   Future<void> _rescheduleAppointment(String appointmentId) async {
//     DateTime? newDate = await _selectNewDate(context);
//     if (newDate != null) {
//       try {
//         await _firestore.collection('appointments').doc(appointmentId).update({
//           'appointmentDate': newDate,
//         });
//       } catch (e) {
//         _showErrorDialog('Failed to reschedule appointment');
//       }
//     }
//   }

//   Future<void> _showErrorDialog(String message) async {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   // Select new date for rescheduling
//   Future<DateTime?> _selectNewDate(BuildContext context) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(Duration(days: 30)),
//     );
//     return selectedDate;
//   }

//   // Widget to build the appointment list based on the selected category
//   Widget _buildAppointmentList(
//       List<Map<String, dynamic>> appointments, String category) {
//     return ListView.builder(
//       itemCount: appointments.length,
//       itemBuilder: (context, index) {
//         final appointment = appointments[index];
//         String formattedDate =
//             DateFormat('yyyy-MM-dd').format(appointment['appointmentDate']);
//         return Card(
//           margin: EdgeInsets.all(8.0),
//           child: ListTile(
//             title: Text('${appointment['patientName']}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Date: $formattedDate'),
//                 Text('Time: ${appointment['timeSlot']}'),
//                 Text('Status: ${appointment['status']}'),
//               ],
//             ),
//             trailing: category == 'Pending'
//                 ? Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.check),
//                         onPressed: () => _updateAppointmentStatus(
//                             appointment['appointmentId'], 'approved'),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.cancel),
//                         onPressed: () => _updateAppointmentStatus(
//                             appointment['appointmentId'], 'declined'),
//                       ),
//                     ],
//                   )
//                 : category == 'Upcoming'
//                     ? Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.access_time),
//                             onPressed: () =>
//                                 _rescheduleAppointment(appointment['appointmentId']),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.done),
//                             onPressed: () => _updateAppointmentStatus(
//                                 appointment['appointmentId'], 'completed'),
//                           ),
//                         ],
//                       )
//                     : null,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text("Appointments")),
//         backgroundColor: const Color(0xFFBDDDFC),
//         automaticallyImplyLeading: false,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AppointmentCategoryScreen(
//                                 category: 'Pending',
//                                 appointments: pendingAppointments,
//                               ),
//                             ),
//                           );
//                         },
//                         child: const Text("Pending"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AppointmentCategoryScreen(
//                                 category: 'Upcoming',
//                                 appointments: upcomingAppointments,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Text("Upcoming"),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AppointmentCategoryScreen(
//                                 category: 'Declined',
//                                 appointments: declinedAppointments,
//                               ),
//                             ),
//                           );
//                         },
//                         child: Text("Declined"),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: _buildAppointmentList(pendingAppointments, 'Pending'),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// // New screen to show appointments by category
// class AppointmentCategoryScreen extends StatelessWidget {
//   final String category;
//   final List<Map<String, dynamic>> appointments;

//   AppointmentCategoryScreen({
//     required this.category,
//     required this.appointments,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('$category Appointments'),
//       ),
//       body: appointments.isEmpty
//           ? Center(child: Text('No appointments available in this category'))
//           : ListView.builder(
//               itemCount: appointments.length,
//               itemBuilder: (context, index) {
//                 final appointment = appointments[index];
//                 String formattedDate =
//                     DateFormat('yyyy-MM-dd').format(appointment['appointmentDate']);
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text('${appointment['patientName']}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Date: $formattedDate'),
//                         Text('Time: ${appointment['timeSlot']}'),
//                         Text('Status: ${appointment['status']}'),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TherapistAppointmentsScreen extends StatefulWidget {
  @override
  _TherapistAppointmentsScreenState createState() =>
      _TherapistAppointmentsScreenState();
}

class _TherapistAppointmentsScreenState
    extends State<TherapistAppointmentsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> pendingAppointments = [];
  List<Map<String, dynamic>> upcomingAppointments = [];
  List<Map<String, dynamic>> declinedAppointments = [];

  String selectedCategory = 'Pending';

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await _firestore
          .collection('appointments')
          .where('therapistId', isEqualTo: user.uid)
          .get();

      setState(() {
        pendingAppointments = [];
        upcomingAppointments = [];
        declinedAppointments = [];

        snapshot.docs.forEach((doc) {
          final appointment = {
            'appointmentId': doc.id,
            'patientId': doc['patientId'],
            'patientName': doc['patientName'],
            'appointmentDate': doc['appointmentDate'].toDate(),
            'timeSlot': doc['timeSlot'],
            'status': doc['status'],
          };

          if (doc['status'] == 'pending') {
            pendingAppointments.add(appointment);
          } else if (doc['status'] == 'approved') {
            upcomingAppointments.add(appointment);
          } else if (doc['status'] == 'declined') {
            declinedAppointments.add(appointment);
          }
        });
      });
    }
  }

  Widget _buildAppointmentList(List<Map<String, dynamic>> appointments) {
    return appointments.isEmpty
        ? Center(child: Text('No appointments available in this category'))
        : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${appointment['patientName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${appointment['appointmentDate']}'),
                      Text('Time: ${appointment['timeSlot']}'),
                      Text('Status: ${appointment['status']}'),
                    ],
                  ),
                  trailing: selectedCategory == 'Pending'
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => _approveAppointment(
                                  appointment['appointmentId']),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel),
                              onPressed: () => _declineAppointment(
                                  appointment['appointmentId']),
                            ),
                          ],
                        )
                      : selectedCategory == 'Upcoming'
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () => _rescheduleAppointment(
                                      appointment['appointmentId']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.done),
                                  onPressed: () => _markAppointmentComplete(
                                      appointment['appointmentId']),
                                ),
                              ],
                            )
                          : null,
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedAppointments;
    if (selectedCategory == 'Pending') {
      selectedAppointments = pendingAppointments;
    } else if (selectedCategory == 'Upcoming') {
      selectedAppointments = upcomingAppointments;
    } else {
      selectedAppointments = declinedAppointments;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments"),
        backgroundColor: Color(0xFFBDDDFC),
      ),
      body: Column(
        children: [
          // Category buttons
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Pending';
                    });
                  },
                  child: Text("Pending"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Pending'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Upcoming';
                    });
                  },
                  child: Text("Upcoming"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Upcoming'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedCategory = 'Declined';
                    });
                  },
                  child: Text("Declined"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == 'Declined'
                        ? Colors.blue
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Display the selected category appointments
          Expanded(
            child: _buildAppointmentList(selectedAppointments),
          ),
        ],
      ),
    );
  }

  // Approve Appointment
void _approveAppointment(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'approved',
    });
    setState(() {
      pendingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment approved successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to approve appointment: $e')),
    );
  }
}

// Decline Appointment
void _declineAppointment(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'declined',
    });
    setState(() {
      pendingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment declined successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to decline appointment: $e')),
    );
  }
}

// Reschedule Appointment with Editable Date and Time
void _rescheduleAppointment(String appointmentId) async {
  try {
    // Select new date
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ); // Return if no date is selected

    // Select new time
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (newTime == null) return; // Return if no time is selected

    // Combine date and time into a single DateTime object
    if (newDate == null) return; // Return if no date is selected

    DateTime newDateTime = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      newTime.hour,
      newTime.minute,
    );

    // Update Firestore with new date and time
    await _firestore.collection('appointments').doc(appointmentId).update({
      'appointmentDate': newDateTime,
      'status': 'rescheduled',
    });

    setState(() {
      upcomingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment rescheduled to $newDateTime')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to reschedule appointment: $e')),
    );
  }
}

// Mark Appointment Complete
void _markAppointmentComplete(String appointmentId) async {
  try {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'status': 'completed',
    });
    setState(() {
      upcomingAppointments.removeWhere(
          (appointment) => appointment['appointmentId'] == appointmentId);
      _fetchAppointments(); // Refresh the appointments
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment marked as completed')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to mark appointment as completed: $e')),
    );
  }
}

}
