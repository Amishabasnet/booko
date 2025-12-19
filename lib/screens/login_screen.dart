import 'package:flutter/material.dart';
import 'package:booko/screens/register_screen.dart';
import 'package:booko/screens/forget_password_screen.dart';
import 'package:booko/bottomNavScreen/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;
  bool passwordVisible = false;

  String emailErrorMsg = "";
  String passwordErrorMsg = "";

  void validate() {
    setState(() {
      // emailError = false;
      // passwordError = false;
      // emailErrorMsg = "";
      // passwordErrorMsg = "";

      String email = emailController.text.trim();
      String pass = passwordController.text.trim();

      // if (email != "example@gmail.com") {
      //   emailError = true;
      //   emailErrorMsg = "No account found with this email. Please sign up.";
      // }

      // if (pass != "123456") {
      //   passwordError = true;
      //   passwordErrorMsg = "Incorrect Password.";
      // }

      // // Navigate to Dashboard if no errors
      // if (!emailError && !passwordError) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const DashboardScreen()),
      //   );
      // }
      if (email == "amishabasnet@gmail.com" && pass == "987456") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Booko",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Welcome back, you have been missed.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              const Text(
                "Email Address",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailError ? Colors.red : Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: emailError ? Colors.red : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),

              if (emailError)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    emailErrorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 20),

              const Text(
                "Password",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: passwordError ? Colors.red : Colors.blue,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: passwordError ? Colors.red : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),

              if (passwordError)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    passwordErrorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 6),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgetPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color(0xff003366),
                  ),
                  onPressed: validate,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
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
