import 'package:flutter/material.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.controller,
    required this.hint,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
  })  : _keyboardType = keyboardType,
        _readOnly = readOnly,
        _onTap = onTap;

  final TextEditingController controller;
  final String hint;
  final TextInputType? _keyboardType;
  final bool _readOnly;
  final VoidCallback? _onTap;

  InputDecoration _decor() => InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xffd6d6d6)),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: hint,
      );

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: _keyboardType,
      readOnly: _readOnly,
      onTap: _onTap,
      decoration: _decor(),
    );
  }
}