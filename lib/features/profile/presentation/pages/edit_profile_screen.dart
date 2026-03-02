import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/profile_entity.dart';
import '../state/profile_controller.dart';
import '../widgets/profile_text_field.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _dobController = TextEditingController();

  DateTime? _dob;
  String _gender = 'Female';

  @override
  void initState() {
    super.initState();

    final st = ref.read(profileControllerProvider);
    final p = st.profile;

    if (p != null) {
      _fullName.text = p.fullName;
      _email.text = p.email;
      _phone.text = p.phone;
      _dob = p.dob;
      _gender = p.gender;
      _dobController.text = _formatDob(_dob);
    }
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _dobController.dispose();
    super.dispose();
  }

  String _formatDob(DateTime? date) {
    if (date == null) return '';
    final d = date.toLocal();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}-${two(d.month)}-${d.year}';
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 20, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: now,
      initialDate: initial,
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobController.text = _formatDob(_dob);
      });
    }
  }

  bool _validEmail(String v) => v.contains('@') && v.contains('.');

  Future<void> _save() async {
    final name = _fullName.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || _dob == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    if (!_validEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email.')),
      );
      return;
    }

    final profile = ProfileEntity(
      fullName: name,
      email: email,
      phone: phone,
      dob: _dob!,
      gender: _gender,
    );

    await ref.read(profileControllerProvider.notifier).save(profile);

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: const Color(0xff111a2c),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final isMobile = w < 600;
          final isTablet = w >= 600 && w < 1024;

          final pad = isMobile
              ? 16.0
              : isTablet
              ? 24.0
              : 32.0;
          final maxWidth = isMobile ? double.infinity : 820.0;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(pad, 16, pad, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff111a2c),
                      ),
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Full Name',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ProfileTextField(controller: _fullName, hint: 'Amisha'),
                    const SizedBox(height: 12),

                    const Text(
                      'Email Address',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ProfileTextField(
                      controller: _email,
                      hint: 'amisha@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Phone Number',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ProfileTextField(
                      controller: _phone,
                      hint: '9874563210',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Date of Birth',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    ProfileTextField(
                      controller: _dobController,
                      hint: '27-04-2005',
                      readOnly: true,
                      onTap: _pickDob,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Gender',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _gender,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xffd6d6d6),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _gender = v ?? 'Female'),
                    ),

                    const SizedBox(height: 18),
                    Center(
                      child: SizedBox(
                        width: 160,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1f7a2e),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Center(
                      child: TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(profileControllerProvider.notifier)
                              .delete();
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text(
                          'Delete your account',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
