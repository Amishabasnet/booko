import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _dob = TextEditingController();

  String _gender = "gender";

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF6F7FB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  Future<void> _pickDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2005, 4, 27),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _dob.text =
          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0F2B5B);
    const red = Color(0xFFE53935);
    const green = Color(0xFF2E7D32);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primary,
        centerTitle: true,
        title: const Text("Booko"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // optional edit action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// PROFILE HEADER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFE0E0E0),
                    child: Icon(Icons.person, color: primary),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WELCOME BACK!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _fullName.text.toUpperCase(),
                        style: const TextStyle(
                          color: red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// FORM
            TextField(
              controller: _fullName,
              decoration: _decoration("Full Name"),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoration("Email Address"),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: _decoration("Phone Number"),
            ),
            const SizedBox(height: 14),

            TextField(
              controller: _dob,
              readOnly: true,
              onTap: _pickDob,
              decoration: _decoration(
                "Date of Birth",
              ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
            ),
            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              value: _gender,
              decoration: _decoration("Gender"),
              items: const [
                DropdownMenuItem(value: "Female", child: Text("Female")),
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              onChanged: (v) => setState(() => _gender = v!),
            ),

            const SizedBox(height: 28),

            /// SAVE BUTTON
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// DELETE ACCOUNT
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.delete, color: red),
              label: const Text(
                "Delete your account",
                style: TextStyle(color: red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
