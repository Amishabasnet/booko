import 'package:booko/features/auth/presentation/pages/login_screen.dart';
import 'package:booko/features/auth/presentation/state/auth_state.dart';
import 'package:booko/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedGender;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  bool fullNameError = false;
  bool emailError = false;
  bool mobileError = false;
  bool dobError = false;
  bool genderError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;

  String emailErrorMsg = "";
  String mobileErrorMsg = "";
  String passwordErrorMsg = "";
  String confirmPasswordMsg = "";

  // ================= VALIDATION =================

  bool validateForm() {
    setState(() {
      fullNameError = emailError = mobileError = dobError = genderError =
          passwordError = confirmPasswordError = false;

      emailErrorMsg = mobileErrorMsg = passwordErrorMsg = confirmPasswordMsg =
          "";

      if (fullNameController.text.trim().isEmpty) {
        fullNameError = true;
      }

      if (!emailController.text.contains("@")) {
        emailError = true;
        emailErrorMsg = "Enter a valid email address";
      }

      if (mobileController.text.length != 10) {
        mobileError = true;
        mobileErrorMsg = "Phone number must be 10 digits";
      }

      if (dobController.text.isEmpty) {
        dobError = true;
      }

      if (selectedGender == null) {
        genderError = true;
      }

      if (passwordController.text.length < 6) {
        passwordError = true;
        passwordErrorMsg = "Password must be at least 6 characters";
      }

      if (confirmPasswordController.text != passwordController.text) {
        confirmPasswordError = true;
        confirmPasswordMsg = "Passwords do not match";
      }
    });

    return !(fullNameError ||
        emailError ||
        mobileError ||
        dobError ||
        genderError ||
        passwordError ||
        confirmPasswordError);
  }

  // ================= SIGN UP =================

  Future<void> signUp() async {
    if (!validateForm()) return;

    await ref
        .read(authViewmodelProvider.notifier)
        .register(
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: mobileController.text.trim(),
          dob: dobController.text.trim(),
          gender: selectedGender!,
          password: passwordController.text.trim(),
          username: '',
        );
  }

  // ================= DOB PICKER =================

  Future<void> pickDOB() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() => dobError = false);
    }
  }

  InputBorder inputBorder(bool error) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: error ? Colors.red : const Color(0xffD1D1D6),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }

      if (next.status == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? "Registration failed")),
        );
      }
    });

    final isLoading =
        ref.watch(authViewmodelProvider).status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  BackButton(),
                  SizedBox(width: 10),
                  Text(
                    "Booko",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Create an Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // ================= FIELDS =================
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  border: inputBorder(fullNameError),
                ),
              ),
              if (fullNameError)
                const Text(
                  "Required",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: inputBorder(emailError),
                ),
              ),
              if (emailError)
                Text(
                  emailErrorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  border: inputBorder(mobileError),
                ),
              ),
              if (mobileError)
                Text(
                  mobileErrorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              TextField(
                controller: dobController,
                readOnly: true,
                onTap: pickDOB,
                decoration: InputDecoration(
                  hintText: "Date of Birth",
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: inputBorder(dobError),
                ),
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedGender,
                hint: const Text("Select Gender"),
                items: ["Male", "Female", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedGender = v),
                decoration: InputDecoration(border: inputBorder(genderError)),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => passwordVisible = !passwordVisible),
                  ),
                  border: inputBorder(passwordError),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: confirmPasswordController,
                obscureText: !confirmPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => confirmPasswordVisible = !confirmPasswordVisible,
                    ),
                  ),
                  border: inputBorder(confirmPasswordError),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003366),
                    shape: const StadiumBorder(),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up", style: TextStyle(fontSize: 16)),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
