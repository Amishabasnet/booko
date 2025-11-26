import 'package:flutter/material.dart';
import 'package:booko/screens/register_screen.dart';
import 'package:booko/screens/forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool emailError = false;
  bool passwordError = false;

  String emailErrorMsg = "";
  String passwordErrorMsg = "";

  void validate() {
    setState(() {
      emailError = false;
      passwordError = false;
      emailErrorMsg = "";
      passwordErrorMsg = "";

      String email = emailController.text.trim();
      String pass = passwordController.text.trim();

      if (email != "example@gmail.com") {
        emailError = true;
        emailErrorMsg = "No account found with this email. Please sign up.";
      }

      if (pass != "123456") {
        passwordError = true;
        passwordErrorMsg = "Incorrect Password.";
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
              Text(
                "Booko",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 40),

              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back, you have been missed.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              // Email label
              Text(
                "Email Address",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              // Email TextField
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 20),

              // Password label
              Text(
                "Password",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              // Password TextField
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  suffixIcon: Icon(Icons.visibility_outlined),
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
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 6),

              // Forget Password Button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ForgetPasswordScreen()),
                    );
                  },
                  child: Text(
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

              // Sign In button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    backgroundColor: Color(0xff003366),
                  ),
                  onPressed: validate,
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Navigation
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        );
                      },
                      child: Text(
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
