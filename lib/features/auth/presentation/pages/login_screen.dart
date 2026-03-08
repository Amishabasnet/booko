import 'package:booko/features/auth/presentation/pages/register_screen.dart';
import 'package:booko/features/auth/presentation/state/auth_state.dart';
import 'package:booko/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:booko/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool passwordVisible = false;
  bool emailError = false;
  bool passwordError = false;
  String emailErrorMsg = "";
  String passwordErrorMsg = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void resetErrors() {
    emailError = false;
    passwordError = false;
    emailErrorMsg = "";
    passwordErrorMsg = "";
  }

  Future<void> validateAndLogin() async {
    FocusScope.of(context).unfocus();

    setState(() {
      resetErrors();
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    bool hasError = false;

    if (email.isEmpty) {
      hasError = true;
      emailError = true;
      emailErrorMsg = "Please enter your email.";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      hasError = true;
      emailError = true;
      emailErrorMsg = "Please enter a valid email address.";
    }

    if (password.isEmpty) {
      hasError = true;
      passwordError = true;
      passwordErrorMsg = "Please enter your password.";
    }

    setState(() {});

    if (hasError) return;

    await ref
        .read(authViewmodelProvider.notifier)
        .login(email: email, password: password);
  }

  InputBorder inputBorder(bool error) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: error ? Colors.red : Colors.grey.shade300,
        width: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewmodelProvider);

    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (!mounted) return;

      if (next.status == AuthStatus.authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        });
      }

      if (next.status == AuthStatus.error && next.errorMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            emailError = true;
            passwordError = true;
            emailErrorMsg = next.errorMessage!;
            passwordErrorMsg = next.errorMessage!;
          });
        });
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Booko",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) {
                  if (emailError) {
                    setState(() {
                      emailError = false;
                      emailErrorMsg = "";
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "example@gmail.com",
                  border: inputBorder(emailError),
                  enabledBorder: inputBorder(emailError),
                  focusedBorder: inputBorder(emailError),
                  errorBorder: inputBorder(true),
                  focusedErrorBorder: inputBorder(true),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                ),
              ),
              if (emailError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    emailErrorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
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
                onChanged: (_) {
                  if (passwordError) {
                    setState(() {
                      passwordError = false;
                      passwordErrorMsg = "";
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  border: inputBorder(passwordError),
                  enabledBorder: inputBorder(passwordError),
                  focusedBorder: inputBorder(passwordError),
                  errorBorder: inputBorder(true),
                  focusedErrorBorder: inputBorder(true),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
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
                ),
              ),
              if (passwordError)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    passwordErrorMsg,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: authState.isLoading ? null : validateAndLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff003366),
                    shape: const StadiumBorder(),
                    disabledBackgroundColor: const Color(0xff003366),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
