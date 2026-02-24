import 'package:booko/features/profile/presentation/state/profile_provider.dart';
import 'package:booko/features/profile/presentation/state/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileData? profile;

  const EditProfileScreen({super.key, this.profile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile?.name ?? '');
    _emailController = TextEditingController(text: widget.profile?.email ?? '');
    _phoneController = TextEditingController(
      text: widget.profile?.phoneNumber ?? '',
    );
    _dobController = TextEditingController(
      text: widget.profile?.dob != null ? _formatDob(widget.profile!.dob) : '',
    );
    _genderController = TextEditingController(
      text: widget.profile?.gender ?? 'Female',
    );
  }

  String _formatDob(DateTime dob) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dob);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveProfile),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Email is required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Phone number is required' : null,
              ),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Date of Birth is required' : null,
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) =>
                    value?.isEmpty == true ? 'Gender is required' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      final profileData = ProfileData(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        dob: DateTime.parse(_dobController.text),
        gender: _genderController.text,
        imagePath: null, // You can add logic for image handling later
      );

      ref.read(profileProvider.notifier).saveProfile(profileData);
      Navigator.pop(context); // Navigate back after saving
    }
  }
}
