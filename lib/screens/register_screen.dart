import 'package:booko/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:booko/screens/dashboard_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? selectedGender;

  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  // Error flags
  bool nameError = false;
  bool emailError = false;
  bool mobileError = false;
  bool dobError = false;
  bool genderError = false;
  bool passwordError = false;
  bool confirmPasswordError = false;

  // Error messages
  String emailErrorMsg = "";
  String mobileErrorMsg = "";
  String passwordErrorMsg = "";
  String confirmPasswordMsg = "";

  void validateForm() {
    setState(() {
      // Reset all errors first
      nameError = emailError = mobileError = dobError = genderError =
          passwordError = confirmPasswordError = false;

      emailErrorMsg = mobileErrorMsg = passwordErrorMsg = confirmPasswordMsg =
          "";

      String name = nameController.text.trim();
      String email = emailController.text.trim();
      String mobile = mobileController.text.trim();
      String dob = dobController.text.trim();
      String pass = passwordController.text.trim();
      String confirmPass = confirmPasswordController.text.trim();

      // Name validation
      if (name.isEmpty) {
        nameError = true;
      }

      // Email validation (simple)
      if (!email.contains("@")) {
        emailError = true;
        emailErrorMsg = "Please enter a valid email address.";
      }

      // Mobile validation
      if (mobile.length != 10) {
        mobileError = true;
        mobileErrorMsg = "Phone number must be 10 digits.";
      }

      // DOB validation
      if (dob.isEmpty) {
        dobError = true;
      }

      // Gender validation
      if (selectedGender == null) {
        genderError = true;
      }

      // Password validation
      if (pass.length < 6) {
        passwordError = true;
        passwordErrorMsg = "Password must be at least 6 characters.";
      }

      // Confirm password validation
      if (confirmPass != pass) {
        confirmPasswordError = true;
        confirmPasswordMsg = "Passwords do not match.";
      }

      // If all validations pass, navigate to Dashboard
      if (!nameError &&
          !emailError &&
          !mobileError &&
          !dobError &&
          !genderError &&
          !passwordError &&
          !confirmPasswordError) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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

              // NAME
              const Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Please enter your full name.",
                  border: inputBorder(nameError),
                  enabledBorder: inputBorder(nameError),
                  focusedBorder: inputBorder(nameError),
                ),
              ),
              if (nameError)
                const Text(
                  "Required.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              // EMAIL
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

              // MOBILE
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

              // DOB
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

              // GENDER
              const Text(
                "Gender",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: genderError ? Colors.red : const Color(0xffD1D1D6),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: const Text("Select Gender"),
                    value: selectedGender,
                    items: ["Male", "Female", "Other"]
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                        genderError = false;
                      });
                    },
                  ),
                ),
              ),
              if (genderError)
                const Text(
                  "Please select gender.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              const SizedBox(height: 20),

              // PASSWORD
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

              // CONFIRM PASSWORD
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

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003366),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: validateForm,
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
