import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/profile_hive_model.dart';
import 'edit_profile_screen.dart';

const String _profileBoxName = 'profileBox';
const String _profileKey = 'profile';

// Provider
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier()..loadProfile();
});

class ProfileData {
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime dob;
  final String gender;
  final String? imagePath;

  const ProfileData({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.dob,
    required this.gender,
    this.imagePath,
  });

  ProfileData copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    DateTime? dob,
    String? gender,
    String? imagePath,
  }) {
    return ProfileData(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileState {
  final bool isLoading;
  final ProfileData? profile;

  const ProfileState({required this.isLoading, required this.profile});

  factory ProfileState.initial() =>
      const ProfileState(isLoading: true, profile: null);

  ProfileState copyWith({bool? isLoading, ProfileData? profile}) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState.initial());

  Box<ProfileHiveModel> get _box => Hive.box<ProfileHiveModel>(_profileBoxName);

  ProfileData _toData(ProfileHiveModel m) => ProfileData(
    name: m.name,
    email: m.email,
    phoneNumber: m.phoneNumber,
    dob: m.dob,
    gender: m.gender,
    imagePath: m.imagePath,
  );

  ProfileHiveModel _toModel(ProfileData d) => ProfileHiveModel(
    name: d.name,
    email: d.email,
    phoneNumber: d.phoneNumber,
    dob: d.dob,
    gender: d.gender,
    imagePath: d.imagePath,
  );

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true);
    try {
      final model = _box.get(_profileKey);
      state = ProfileState(
        isLoading: false,
        profile: model == null ? null : _toData(model),
      );
    } catch (_) {
      state = const ProfileState(isLoading: false, profile: null);
    }
  }

  Future<void> updateImage(String? path) async {
    final current = state.profile;
    if (current == null) return;

    final updated = current.copyWith(imagePath: path);
    state = state.copyWith(profile: updated);

    try {
      await _box.put(_profileKey, _toModel(updated));
    } catch (_) {}
  }

  Future<void> saveProfile(ProfileData data) async {}
}

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  void _openEditProfile(ProfileData? current) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialProfile: current),
      ),
    ).then((_) => ref.read(profileProvider.notifier).loadProfile());
  }

  ImageProvider _imageProvider(ProfileData? profile) {
    if (profile?.imagePath != null && profile!.imagePath!.isNotEmpty) {
      return FileImage(File(profile.imagePath!));
    }
    // If you don't have this asset, replace with NetworkImage('https://i.pravatar.cc/200')
    return const AssetImage('assets/images/default_avatar.png');
  }

  Future<void> _showImagePickerSheet(ProfileData? profile) async {
    if (profile == null) return;
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
                    await ref
                        .read(profileProvider.notifier)
                        .updateImage(img.path);
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
                    await ref
                        .read(profileProvider.notifier)
                        .updateImage(img.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () async {
                  Navigator.pop(ctx);
                  await ref.read(profileProvider.notifier).updateImage(null);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final st = ref.watch(profileProvider);
    final profile = st.profile;

    if (st.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF3F4F7),
        appBar: AppBar(
          backgroundColor: const Color(0xff1E2B4A),
          centerTitle: true,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
          ),
        ),
        body: Column(
          children: [
            // Header: avatar + welcome + edit icon
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: const Color(0xffF3F4F7),
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: profile == null
                        ? null
                        : _imageProvider(profile),
                    child: profile == null
                        ? const Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Colors.black54,
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WELCOME BACK',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (profile?.name.isNotEmpty == true)
                              ? profile!.name.toUpperCase()
                              : 'USER',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _openEditProfile(profile),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            const TabBar(
              indicatorColor: Color(0xff1E2B4A),
              labelColor: Color(0xff1E2B4A),
              unselectedLabelColor: Colors.black54,
              labelStyle: TextStyle(fontWeight: FontWeight.w800),
              tabs: [
                Tab(text: 'My Profile'),
                Tab(text: 'My Tickets'),
              ],
            ),

            Expanded(
              child: TabBarView(
                children: [
                  // ✅ Simple My Profile tab (as you requested)
                  const Center(
                    child: Text(
                      'No profile found',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  // Tickets tab
                  const Center(
                    child: Text(
                      'My Tickets (coming soon)',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),

            // Optional: quick change photo (only if profile exists)
            if (profile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextButton.icon(
                  onPressed: () => _showImagePickerSheet(profile),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Change photo'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
