import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/movie.dart';

abstract class SearchRemoteDataSource {
  Future<List<Movie>> searchRemote(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl({required this.client, required this.baseUrl});

  final http.Client client;
  final String baseUrl; // e.g. https://your-api.com

  @override
  Future<List<Movie>> searchRemote(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];

    // ✅ Adjust endpoint if needed
    final uri = Uri.parse('$baseUrl/search?q=${Uri.encodeComponent(q)}');
    final res = await client.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Remote search failed: ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);

    // supports:
    // { "results": [ ... ] } OR [ ... ] OR { "data": [ ... ] }
    final List<dynamic> list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['results'] is List) {
        list = decoded['results'] as List<dynamic>;
      } else if (decoded['data'] is List) {
        list = decoded['data'] as List<dynamic>;
      } else {
        list = const [];
      }
    } else {
      list = const [];
    }

    return list.whereType<Map<String, dynamic>>().map(_movieFromJson).toList();
  }

  Movie _movieFromJson(Map<String, dynamic> json) {
    // Handle different backend field names safely
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final title = (json['title'] ?? json['name'] ?? '').toString();
    final language = (json['language'] ?? '').toString();

    final genresRaw = json['genres'];
    final genres = (genresRaw is List)
        ? genresRaw.map((e) => e.toString()).toList()
        : <String>[];

    final posterUrl = (json['posterUrl'] ?? json['poster'] ?? '').toString();

    return Movie(
      id: id,
      title: title,
      language: language,
      genres: genres,
      posterUrl: posterUrl,
    );
  }
}
