import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Offer Model
class Offer {
  final String title;
  final String description;
  final IconData icon;
  final String discount;

  Offer({
    required this.title,
    required this.description,
    required this.icon,
    required this.discount,
  });
}

// Provider for offers
final offersProvider = Provider<List<Offer>>((ref) {
  return [
    Offer(
      title: "50% Off on Movies",
      description: "Get 50% discount on all movie tickets this weekend!",
      icon: Icons.movie,
      discount: "50% OFF",
    ),
    Offer(
      title: "Buy 1 Get 1 Free",
      description: "On selected snacks and drinks at our cinema.",
      icon: Icons.local_drink,
      discount: "B1G1",
    ),
    Offer(
      title: "Student Special",
      description: "Students get 30% off on weekdays.",
      icon: Icons.school,
      discount: "30% OFF",
    ),
  ];
});

class OfferScreen extends ConsumerWidget {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Exclusive Offers"),
        backgroundColor: Color(0xff003366),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 158, 193, 228),
                    child: Icon(offer.icon, size: 30, color: Color(0xff003366)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          offer.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          offer.description,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: handle claim offer
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Offer '${offer.title}' claimed!"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff003366),
                    ),
                    child: Text(offer.discount),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
