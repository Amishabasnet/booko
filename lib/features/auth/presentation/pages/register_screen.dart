import 'package:booko/core/utils/snackbar_utils.dart';
import 'package:booko/core/widgets/gradient_button.dart';
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

  void validateForm() {
    setState(() {
      fullNameError = emailError = mobileError = dobError = genderError =
          passwordError = confirmPasswordError = false;

      emailErrorMsg = mobileErrorMsg = passwordErrorMsg = confirmPasswordMsg =
          "";

      String fullName = fullNameController.text.trim();
      String email = emailController.text.trim();
      String mobile = mobileController.text.trim();
      String dob = dobController.text.trim();
      String pass = passwordController.text.trim();
      String confirmPass = confirmPasswordController.text.trim();

      if (fullName.isEmpty) {
        fullNameError = true;
      }

      if (!email.contains("@")) {
        emailError = true;
        emailErrorMsg = "Please enter a valid email address.";
      }

      if (mobile.length != 10) {
        mobileError = true;
        mobileErrorMsg = "Phone number must be 10 digits.";
      }

      if (dob.isEmpty) {
        dobError = true;
      }

      if (selectedGender == null) {
        genderError = true;
      }

      if (pass.length < 6) {
        passwordError = true;
        passwordErrorMsg = "Password must be at least 6 characters.";
      }

      if (confirmPass != pass) {
        confirmPasswordError = true;
        confirmPasswordMsg = "Passwords do not match.";
      }

      if (!fullNameError &&
          !emailError &&
          !mobileError &&
          !dobError &&
          !genderError &&
          !passwordError &&
          !confirmPasswordError) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  Future<void> pickDOB() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dobController.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        dobError = false;
      });
    }
  }

  Future<void> signUp() async {
    validateForm();

    if (fullNameError ||
        emailError ||
        mobileError ||
        dobError ||
        genderError ||
        passwordError ||
        confirmPasswordError) {
      return;
    }

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

  InputBorder inputBorder(bool error) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: error ? Colors.red : const Color(0xffD1D1D6),
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewmodelProvider);

    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.registered) {
        SnackbarUtils.showSuccess(
          context,
          'Registration successful! Please login.',
        );
        Navigator.of(context).pop();
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        SnackbarUtils.showError(context, next.errorMessage!);
      }
    });

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
                  BackButton(color: Colors.black87),
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
              const SizedBox(height: 4),
              const Text(
                "Fill in your details or register.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              const Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(
                  hintText: "Please enter your full name.",
                  border: inputBorder(fullNameError),
                  enabledBorder: inputBorder(fullNameError),
                  focusedBorder: inputBorder(fullNameError),
                ),
              ),
              if (fullNameError)
                const Text(
                  "Required.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Email Address",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email address",
                  border: inputBorder(emailError),
                  enabledBorder: inputBorder(emailError),
                  focusedBorder: inputBorder(emailError),
                ),
              ),
              if (emailError)
                Text(
                  emailErrorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Mobile",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Phone number",
                  border: inputBorder(mobileError),
                  enabledBorder: inputBorder(mobileError),
                  focusedBorder: inputBorder(mobileError),
                ),
              ),
              if (mobileError)
                Text(
                  mobileErrorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Date of Birth",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: dobController,
                readOnly: true,
                onTap: pickDOB,
                decoration: InputDecoration(
                  hintText: "DD/MM/YYYY",
                  suffixIcon: const Icon(Icons.calendar_today),
                  border: inputBorder(dobError),
                  enabledBorder: inputBorder(dobError),
                  focusedBorder: inputBorder(dobError),
                ),
              ),
              if (dobError)
                const Text(
                  "Please select your birth date.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Gender",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedGender,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                hint: const Text("Select Gender"),
                decoration: InputDecoration(
                  hintText: "Select Gender",
                  border: inputBorder(genderError),
                  enabledBorder: inputBorder(genderError),
                  focusedBorder: inputBorder(genderError),
                  errorBorder: inputBorder(true),
                  focusedErrorBorder: inputBorder(true),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                  DropdownMenuItem(value: "Other", child: Text("Other")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                    genderError = false;
                  });
                },
              ),

              if (genderError)
                const Text(
                  "Please select gender.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  border: inputBorder(passwordError),
                  enabledBorder: inputBorder(passwordError),
                  focusedBorder: inputBorder(passwordError),
                ),
              ),
              if (passwordError)
                Text(
                  passwordErrorMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              const Text(
                "Confirm Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
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
                    onPressed: () {
                      setState(() {
                        confirmPasswordVisible = !confirmPasswordVisible;
                      });
                    },
                  ),
                  border: inputBorder(confirmPasswordError),
                  enabledBorder: inputBorder(confirmPasswordError),
                  focusedBorder: inputBorder(confirmPasswordError),
                ),
              ),
              if (confirmPasswordError)
                Text(
                  confirmPasswordMsg,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 30),

              // SizedBox(
              //   width: double.infinity,
              //   height: 50,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xff003366),
              //       shape: const StadiumBorder(),
              //     ),
              //     onPressed: validateForm,
              //     child: const Text(
              //       "Sign Up",
              //       style: TextStyle(color: Colors.white, fontSize: 16),
              //     ),
              //   ),
              // ),
              GradientButton(
                text: 'Create Account',
                onPressed: validateForm,
                isLoading: authState.status == AuthStatus.loading,
              ),
              const SizedBox(height: 8),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff003366),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
