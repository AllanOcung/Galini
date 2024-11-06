import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("All Clients"),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
                    labelText: "Search Clients...",
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
                child: ListView.builder(
                  itemCount: 15, // Replace with actual user count
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("images/doctor1.jpg"),
                      ),
                      title: const Text("User Name"),
                      subtitle: const Text("user@example.com"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Handle delete user
                        },
                      ),
                      onTap: () {
                        // Option to view user profile
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
}
