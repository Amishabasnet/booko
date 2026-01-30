import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to Edit Profile Screen
              print("Edit profile tapped");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade300,
              child: const CircleAvatar(
                radius: 52,
                backgroundImage: AssetImage("assets/profile.jpg"),
                // Or NetworkImage("https://example.com/profile.jpg")
              ),
            ),

            const SizedBox(height: 16),

            // Name
            const Text(
              "Amisha",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // Email
            Text(
              "amisha@example.com",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            // Info Cards
            _infoTile(
              icon: Icons.phone,
              title: "Phone",
              value: "+977 98XXXXXXXX",
            ),

            _infoTile(
              icon: Icons.location_on,
              title: "Location",
              value: "Kathmandu, Nepal",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
