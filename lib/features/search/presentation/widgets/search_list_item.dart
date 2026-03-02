import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({super.key, required this.movie});
  final Movie movie;

  bool _isNetwork(String path) => path.startsWith('http');

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final posterW = w < 380 ? 56.0 : 76.0;
    final posterH = posterW * 1.45;

    final genresText = movie.genres.isEmpty ? '—' : movie.genres.join(' • ');

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: movie.posterUrl.isEmpty
                  ? _fallback(posterW, posterH)
                  : _isNetwork(movie.posterUrl)
                  ? Image.network(
                      movie.posterUrl,
                      width: posterW,
                      height: posterH,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(posterW, posterH),
                    )
                  : Image.asset(
                      movie.posterUrl,
                      width: posterW,
                      height: posterH,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallback(posterW, posterH),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${movie.language} • $genresText',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback(double w, double h) {
    return Container(
      width: w,
      height: h,
      alignment: Alignment.center,
      color: Colors.grey.shade300,
      child: const Icon(Icons.movie),
    );
  }
}
