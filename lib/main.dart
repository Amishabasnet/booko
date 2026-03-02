import 'package:booko/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

// -------------------- SEARCH --------------------
import 'package:booko/features/search/data/datasources/search_local_datasource_impl.dart';
import 'package:booko/features/search/data/datasources/search_remote_darasource.dart';
import 'package:booko/features/search/data/models/search_hive_model.dart';
import 'package:booko/features/search/data/repositories/search_repository_impl.dart';
import 'package:booko/features/search/domain/usecases/search_movies.dart';
import 'package:booko/features/search/presentation/providers/search_provider.dart';

// -------------------- PROFILE --------------------
import 'package:booko/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:booko/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:booko/features/profile/data/models/profile_hive_model.dart';

/// SharedPreferences provider (you are overriding this)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSourceImpl>((
  ref,
) {
  throw UnimplementedError(
    'profileLocalDataSourceProvider must be overridden in main()',
  );
});

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSourceImpl>((
  ref,
) {
  throw UnimplementedError(
    'profileRemoteDataSourceProvider must be overridden in main()',
  );
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final sharedPrefs = await SharedPreferences.getInstance();

  // -------------------- HIVE INIT --------------------
  await Hive.initFlutter();

  // Search Hive
  Hive.registerAdapter(SearchHiveModelAdapter());
  final moviesBox = await Hive.openBox<SearchHiveModel>('movies_box');

  // Profile Hive
  Hive.registerAdapter(ProfileHiveModelAdapter());
  final profileBox = await Hive.openBox<ProfileHiveModel>('profileBox');

  // -------------------- SEARCH WIRES --------------------
  final searchLocal = SearchLocalDataSourceImpl(moviesBox);
  await searchLocal.seedIfEmpty();

  final searchRemote = SearchRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: 'https://your-api.com', // TODO: replace
  );

  final searchRepo = SearchRepositoryImpl(
    local: searchLocal,
    remote: searchRemote,
  );

  final searchUsecase = SearchMovies(searchRepo);

  // -------------------- PROFILE WIRES --------------------
  final profileLocal = ProfileLocalDataSourceImpl(profileBox);

  final profileRemote = ProfileRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: 'https://your-api.com', // TODO: replace
    tokenProvider: () async => sharedPrefs.getString('token'),
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),

        // Search usecase override
        searchMoviesUsecaseProvider.overrideWithValue(searchUsecase),

        // Profile datasource overrides (fixes your errors)
        profileLocalDataSourceProvider.overrideWithValue(profileLocal),
        profileRemoteDataSourceProvider.overrideWithValue(profileRemote),
      ],
      child: const App(),
    ),
  );
}
