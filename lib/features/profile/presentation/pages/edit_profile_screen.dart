import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'profile_screen.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final ProfileData? initialProfile;

  const EditProfileScreen({super.key, required this.initialProfile});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  DateTime? _dob;
  String? _gender;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile;

    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _emailCtrl = TextEditingController(text: p?.email ?? '');
    _phoneCtrl = TextEditingController(text: p?.phoneNumber ?? '');

    _dob = p?.dob;
    _gender = (p?.gender.isNotEmpty ?? false) ? p!.gender : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String _formatDob(DateTime dob) {
    final d = dob.day.toString().padLeft(2, '0');
    final m = dob.month.toString().padLeft(2, '0');
    final y = dob.year.toString();
    return '$d/$m/$y';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Select Date of Birth',
    );

    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

  Future<void> _save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Date of Birth')),
      );
      return;
    }

    if (_gender == null || _gender!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final old = widget.initialProfile;

      final data = ProfileData(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
        dob: _dob!,
        gender: _gender!,
        imagePath: old?.imagePath, // keep existing image path
      );

      await ref.read(profileProvider.notifier).saveProfile(data);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save profile: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialProfile == null ? 'Create Profile' : 'Edit Profile',
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Name is required';
                  if (value.length < 2) return 'Enter a valid name';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Email is required';
                  final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
                  if (!ok) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final value = (v ?? '').trim();
                  if (value.isEmpty) return 'Phone number is required';
                  if (value.length < 7) return 'Enter a valid phone number';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              InkWell(
                onTap: _pickDob,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dob == null ? 'Select DOB' : _formatDob(_dob!),
                    style: TextStyle(
                      color: _dob == null ? Colors.grey.shade600 : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.wc_outlined),
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                  DropdownMenuItem(
                    value: 'Prefer not to say',
                    child: Text('Prefer not to say'),
                  ),
                ],
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Gender is required' : null,
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          widget.initialProfile == null
                              ? 'Create Profile'
                              : 'Save Changes',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
