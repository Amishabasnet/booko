import 'dart:io';

import 'package:booko/features/profile/presentation/state/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileData? initialProfile;

  const EditProfileScreen({super.key, required this.initialProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _dobCtrl;
  String _gender = 'Other';

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _phoneCtrl = TextEditingController(text: p?.phoneNumber ?? '');
    _dobCtrl = TextEditingController(
      text: (p == null) ? '' : _formatDob(p.dob),
    );
    _gender = p?.gender ?? 'Other';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  String _formatDob(DateTime dob) {
    final d = dob.day.toString().padLeft(2, '0');
    final m = dob.month.toString().padLeft(2, '0');
    final y = dob.year.toString();
    return '$d-$m-$y';
  }

  Future<void> _pickDob() async {
    final initial = widget.initialProfile?.dob ?? DateTime(2000, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    _dobCtrl.text = _formatDob(picked);
    setState(() {});
  }

  ImageProvider _imageProvider(ProfileData? profile) {
    if (profile?.imagePath != null && profile!.imagePath!.isNotEmpty) {
      return FileImage(File(profile.imagePath!));
    }
    return const AssetImage('assets/images/default_avatar.png');
    // Or:
    // return const NetworkImage('https://i.pravatar.cc/200');
  }

  Future<void> _pickPhoto(ProfileData? profile) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                  final img = await _picker.pickImage(
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
                  final img = await _picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (img != null && mounted) {
                    await ref
                        .read(profileProvider.notifier)
                        .updateImage(img.path);
                  }
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save() async {
    final currentImage = ref.read(profileProvider).profile?.imagePath;

    // parse DOB
    DateTime dob = widget.initialProfile?.dob ?? DateTime(2000, 1, 1);
    if (_dobCtrl.text.trim().isNotEmpty) {
      final parts = _dobCtrl.text.trim().split('-');
      if (parts.length == 3) {
        final dd = int.tryParse(parts[0]);
        final mm = int.tryParse(parts[1]);
        final yy = int.tryParse(parts[2]);
        if (dd != null && mm != null && yy != null) {
          dob = DateTime(yy, mm, dd);
        }
      }
    }

    final updated = ProfileData(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      dob: dob,
      gender: _gender,
      imagePath: currentImage,
    );

    await ref.read(profileProvider.notifier).saveProfile(updated);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final st = ref.watch(profileProvider);
    final profile = st.profile;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Save',
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        children: [
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: _imageProvider(profile),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: InkWell(
                    onTap: () => _pickPhoto(profile),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          _LabelField(label: 'Name', controller: _nameCtrl, hint: 'Enter name'),
          const SizedBox(height: 14),

          _LabelField(
            label: 'Email address',
            controller: _emailCtrl,
            hint: 'Enter email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          _LabelField(
            label: 'Phone number',
            controller: _phoneCtrl,
            hint: 'Enter phone number',
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),

          _LabelField(
            label: 'Date of Birth',
            controller: _dobCtrl,
            hint: 'DD-MM-YYYY',
            readOnly: true,
            suffix: IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              onPressed: _pickDob,
            ),
          ),
          const SizedBox(height: 14),

          Text(
            'Gender',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.transparent),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _gender,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (v) {
                  if (v == null) return;
                  setState(() => _gender = v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Widget? suffix;

  const _LabelField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.readOnly = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
