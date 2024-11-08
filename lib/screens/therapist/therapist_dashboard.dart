import 'package:flutter/material.dart';

class TherapistDashboard extends StatelessWidget {
  const TherapistDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 103, 164, 245),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome, [Your Name]',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'What do you need today?',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Category Tabs
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryTab(title: 'Therapist', isSelected: true),
                      CategoryTab(title: 'Family Therapist', isSelected: false),
                      CategoryTab(title: 'Life Coach', isSelected: false),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Next Appointment Card
                  _nextAppointmentCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'Specialist',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _specialistList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nextAppointmentCard() {
    return Card(
      color: const Color.fromARGB(255, 103, 164, 245),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/doctor.png'), // Placeholder image
              radius: 30,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Therapy',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  'Dr. Gibson Montgomery',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  '17 June, 13:00 - 14:30',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _specialistList() {
    return Column(
      children: [
        _specialistItem('Dr. Ursula Gurtmeister', 'Family Therapist'),
        _specialistItem('Dr. Cecil Hiplington', 'Therapist'),
      ],
    );
  }

  Widget _specialistItem(String name, String profession) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/doctor.png'), // Placeholder image
      ),
      title: Text(name),
      subtitle: Text(profession),
      onTap: () {
        // Navigate to specialist profile or details
      },
    );
  }
}

class CategoryTab extends StatelessWidget {
  final String title;
  final bool isSelected;

  const CategoryTab({required this.title, this.isSelected = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color.fromARGB(255, 103, 164, 245) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color.fromARGB(255, 103, 164, 245),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Color.fromARGB(255, 103, 164, 245),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}






















// import 'package:flutter/material.dart';

// class TherapistDashboard extends StatelessWidget {
//   const TherapistDashboard({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Therapist Dashboard'),
//         backgroundColor: const Color.fromARGB(255, 103, 164, 245),
//       ),
//       body: GridView.count(
//         padding: const EdgeInsets.all(16),
//         crossAxisCount: 2,
//         children: [
//           _dashboardItem(
//             context,
//             title: 'Profile Management',
//             icon: Icons.person,
//             onTap: () {
//               // Navigate to profile management screen
//             },
//           ),
//           _dashboardItem(
//             context,
//             title: 'Appointment Management',
//             icon: Icons.calendar_today,
//             onTap: () {
//               // Navigate to appointment management screen
//             },
//           ),
//           _dashboardItem(
//             context,
//             title: 'Patient Profiles',
//             icon: Icons.people,
//             onTap: () {
//               // Navigate to patient profiles screen
//             },
//           ),
//           _dashboardItem(
//             context,
//             title: 'Resource Sharing',
//             icon: Icons.book,
//             onTap: () {
//               // Navigate to resource sharing screen
//             },
//           ),
//           _dashboardItem(
//             context,
//             title: 'Feedback & Reviews',
//             icon: Icons.star,
//             onTap: () {
//               // Navigate to feedback and reviews screen
//             },
//           ),
//           _dashboardItem(
//             context,
//             title: 'Notifications',
//             icon: Icons.notifications,
//             onTap: () {
//               // Navigate to notifications screen
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _dashboardItem(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
//     return Card(
//       elevation: 5,
//       child: InkWell(
//         onTap: onTap,
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(icon, size: 50, color: const Color.fromARGB(255, 103, 164, 245)),
//               const SizedBox(height: 10),
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
