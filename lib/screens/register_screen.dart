import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
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
    });
  }

  // Date Picker Function
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
        color: error ? Colors.red : Color(0xffD1D1D6),
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
                children: [
                  Icon(Icons.arrow_back, size: 26, color: Colors.black87),
                  const SizedBox(width: 10),
                  Text(
                    "Booko",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text(
                "Create an Account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Fill in your details or register.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 30),

              // NAME
              Text("Name", style: TextStyle(fontWeight: FontWeight.w600)),
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
                Text(
                  "Required.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // EMAIL
              Text(
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
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // MOBILE
              Text("Mobile", style: TextStyle(fontWeight: FontWeight.w600)),
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
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // DOB
              Text(
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
                  suffixIcon: Icon(Icons.calendar_today),
                  border: inputBorder(dobError),
                  enabledBorder: inputBorder(dobError),
                  focusedBorder: inputBorder(dobError),
                ),
              ),
              if (dobError)
                Text(
                  "Please select your birth date.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // GENDER DROPDOWN
              Text("Gender", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: genderError ? Colors.red : Color(0xffD1D1D6),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text("Select Gender"),
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
                Text(
                  "Please select gender.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // PASSWORD
              Text("Password", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  border: inputBorder(passwordError),
                  enabledBorder: inputBorder(passwordError),
                  focusedBorder: inputBorder(passwordError),
                ),
              ),
              if (passwordError)
                Text(
                  passwordErrorMsg,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 20),

              // CONFIRM PASSWORD
              Text(
                "Confirm Password",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  border: inputBorder(confirmPasswordError),
                  enabledBorder: inputBorder(confirmPasswordError),
                  focusedBorder: inputBorder(confirmPasswordError),
                ),
              ),
              if (confirmPasswordError)
                Text(
                  confirmPasswordMsg,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),

              const SizedBox(height: 30),

              // SIGN UP BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff003366),
                    shape: StadiumBorder(),
                  ),
                  onPressed: validateForm,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account?", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 4),
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
