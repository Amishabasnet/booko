import 'dart:io';

import 'package:booko/features/profile/presentation/state/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final profile = state.profile;

    // ✅ Check if profile data is null or empty
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to edit profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 100), // Placeholder icon
              const SizedBox(height: 10),
              const Text('No profile found'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit profile screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EditProfileScreen()),
                  );
                },
                child: const Text('Create Profile'),
              ),
            ],
          ),
        ),
      );
    }

    // ✅ Render profile data when available
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar display, check if image path exists
            CircleAvatar(
              radius: 40,
              backgroundImage:
                  profile.imagePath != null && profile.imagePath!.isNotEmpty
                  ? FileImage(File(profile.imagePath!))
                  : const NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 20),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(profile.email),
            const SizedBox(height: 10),
            Text('Phone: ${profile.phoneNumber}'),
            const SizedBox(height: 10),
            Text('DOB: ${profile.dob.toLocal()}'),
            const SizedBox(height: 10),
            Text('Gender: ${profile.gender}'),
          ],
        ),
      ),
    );
  }
}
