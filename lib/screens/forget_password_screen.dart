import 'package:flutter/material.dart';
import 'package:booko/screens/otp_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back + Booko
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back, size: 26),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Booko",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 30),

              Text(
                "Forget Password",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                "Select which methods you'd like to reset.",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              SizedBox(height: 25),

              Text(
                "Email Address",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 6),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff002D62),
                    shape: StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OtpScreen()),
                    );
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
