import 'package:booko/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:booko/features/auth/presentation/pages/register_screen.dart';
import 'package:booko/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:booko/features/auth/presentation/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final emailErrorProvider = StateProvider<bool>((ref) => false);
final passwordErrorProvider = StateProvider<bool>((ref) => false);
final passwordVisibleProvider = StateProvider<bool>((ref) => false);
final emailErrorMsgProvider = StateProvider<String>((ref) => "");
final passwordErrorMsgProvider = StateProvider<String>((ref) => "");

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> validateAndLogin(BuildContext context, WidgetRef ref) async {
    // reset errors
    ref.read(emailErrorProvider.notifier).state = false;
    ref.read(passwordErrorProvider.notifier).state = false;
    ref.read(emailErrorMsgProvider.notifier).state = "";
    ref.read(passwordErrorMsgProvider.notifier).state = "";

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!email.contains("@")) {
      ref.read(emailErrorProvider.notifier).state = true;
      ref.read(emailErrorMsgProvider.notifier).state =
          "Please enter a valid email.";
      return;
    }
    if (password.isEmpty) {
      ref.read(passwordErrorProvider.notifier).state = true;
      ref.read(passwordErrorMsgProvider.notifier).state =
          "Please enter password.";
      return;
    }

    await ref
        .read(authViewmodelProvider.notifier)
        .login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailError = ref.watch(emailErrorProvider);
    final passwordError = ref.watch(passwordErrorProvider);
    final passwordVisible = ref.watch(passwordVisibleProvider);
    final authState = ref.watch(authViewmodelProvider);

    ref.listen<AuthState>(authViewmodelProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else if (next.status == AuthStatus.error && next.errorMessage != null) {
        ref.read(emailErrorProvider.notifier).state = true;
        ref.read(passwordErrorProvider.notifier).state = true;
        ref.read(emailErrorMsgProvider.notifier).state = next.errorMessage!;
        ref.read(passwordErrorMsgProvider.notifier).state = next.errorMessage!;
      }
    });

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
                    ref.watch(emailErrorMsgProvider),
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
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        ref.read(passwordVisibleProvider.notifier).state =
                            !passwordVisible,
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
                    ref.watch(passwordErrorMsgProvider),
                    style: const TextStyle(color: Colors.red, fontSize: 12),
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
                  onPressed: authState.status == AuthStatus.loading
                      ? null
                      : () async => validateAndLogin(context, ref),
                  child: authState.status == AuthStatus.loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
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
