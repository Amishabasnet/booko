import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, String> movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final title = movie['title'] ?? 'Movie';
    final image = movie['image'];
    final language = movie['language'] ?? '-';
    final duration = movie['duration'] ?? '-';
    final description = movie['description'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xff003366),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: image == null || image.isEmpty
                  ? Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.movie_outlined, size: 48),
                    )
                  : Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.black12,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              _ChipInfo(text: language, icon: Icons.language_outlined),
              const SizedBox(width: 10),
              _ChipInfo(text: duration, icon: Icons.schedule_outlined),
            ],
          ),

          const SizedBox(height: 14),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade800, height: 1.35),
          ),

          const SizedBox(height: 22),

          SizedBox(
            height: 48,
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xff003366),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book now feature coming soon')),
                );
              },
              child: const Text(
                'Book Now',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final String text;
  final IconData icon;

  const _ChipInfo({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
