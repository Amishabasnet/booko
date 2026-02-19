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

/// provider
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
      profile: profile,
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

  Future<void> saveProfile(ProfileData data) async {
    state = state.copyWith(profile: data);

    try {
      await _box.put(_profileKey, _toModel(data));
    } catch (_) {}
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
}

/// ----------------------------------
/// Screen
/// ----------------------------------
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  void _openEditProfile() {
    final current = ref.read(profileProvider).profile;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(initialProfile: current),
      ),
    );
  }

  Future<void> _showImagePickerSheet() async {
    final st = ref.read(profileProvider);
    if (st.profile == null) return;

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

  Widget _avatar(ProfileData? profile) {
    final ImageProvider imageProvider =
        (profile?.imagePath != null && profile!.imagePath!.isNotEmpty)
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
            onTap: profile == null ? _openEditProfile : _showImagePickerSheet,
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

  String _formatDob(DateTime dob) {
    final d = dob.day.toString().padLeft(2, '0');
    final m = dob.month.toString().padLeft(2, '0');
    final y = dob.year.toString();
    return '$d/$m/$y';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final profile = state.profile;
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
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _avatar(profile),
                  const SizedBox(height: 12),
                  if (profile == null) ...[
                    const Text(
                      'Complete your profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add your details to continue.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                  ] else ...[
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.email,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      profile.phoneNumber,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'DOB: ${_formatDob(profile.dob)}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gender: ${profile.gender}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 20),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                      ),
                      onPressed: _openEditProfile,
                      child: Text(
                        profile == null ? 'Add Profile' : 'Edit Profile',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
