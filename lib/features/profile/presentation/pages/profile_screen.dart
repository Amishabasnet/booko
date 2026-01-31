import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'edit_profile_screen.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier();
});

class ProfileState {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String? imagePath;

  const ProfileState({
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    this.imagePath,
  });

  ProfileState copyWith({
    String? name,
    String? username,
    String? email,
    String? phone,
    String? imagePath,
  }) {
    return ProfileState(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier()
    : super(
        const ProfileState(
          name: 'hvkdfkj',
          username: '@dbvmd',
          email: 'jhbk@gmail.com',
          phone: '9874563210',
          imagePath: null,
        ),
      );

  void updateProfile(ProfileState newState) => state = newState;

  void updateImage(String? path) => state = state.copyWith(imagePath: path);
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  Future<void> _showImagePickerSheet() async {
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await _picker.pickImage(
                    source: ImageSource.camera,
                  );
                  if (img != null && mounted) {
                    ref.read(profileProvider.notifier).updateImage(img.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(ctx);
                  final XFile? img = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (img != null && mounted) {
                    ref.read(profileProvider.notifier).updateImage(img.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  ref.read(profileProvider.notifier).updateImage(null);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _avatar(ProfileState profile) {
    final ImageProvider imageProvider =
        (profile.imagePath != null && profile.imagePath!.isNotEmpty)
        ? FileImage(File(profile.imagePath!))
        : const NetworkImage(
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400',
          );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(radius: 42, backgroundImage: imageProvider),
        Positioned(
          right: -2,
          bottom: -2,
          child: InkWell(
            onTap: _showImagePickerSheet,
            borderRadius: BorderRadius.circular(999),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.photo_camera_outlined, size: 18),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _openEditProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _avatar(profile),
            const SizedBox(height: 12),

            Text(
              profile.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),

            Text(
              profile.username,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                onPressed: _openEditProfile,
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
