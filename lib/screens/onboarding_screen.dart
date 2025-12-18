import 'package:booko/screens/login_screen.dart';
import 'package:booko/widgets/onboard_item.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding2.jpg",
      "title": "Welcome to BOOKO",
      "subtitle": "Your smart movie ticketing partner!",
    },
    {
      "image": "assets/images/onboarding1.jpg",
      "title": "Book Your Favorite Movies",
      "subtitle": "Choose movies, pick seats and pay instantly.",
    },
    {
      "image": "assets/images/onboarding3.jpg",
      "title": "Fast & Easy Experience",
      "subtitle": "Enjoy a seamless movie booking journey.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return OnboardItem(
                  image: pages[index]["image"]!,
                  title: pages[index]["title"]!,
                  subtitle: pages[index]["subtitle"]!,
                );
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentIndex == index ? 30 : 10,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xff003366)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff003366),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentIndex == pages.length - 1 ? "Get Started" : "Next",
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                onPressed: () {
                  if (currentIndex != pages.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
