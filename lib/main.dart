import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:booko/app.dart';
import 'package:booko/core/api/api_endpoints.dart';
import 'package:booko/core/services/hive/hive_service.dart';
import 'package:booko/core/providers/shared_prefs_provider.dart';

// Models & Hive
import 'package:booko/features/movie/data/models/ticket_hive_model.dart';
import 'package:booko/features/profile/data/models/profile_hive_model.dart';
import 'package:booko/features/profile/data/models/ticket_hive_model.dart';
import 'package:booko/features/search/data/models/search_hive_model.dart';

// Datasources
import 'package:booko/features/search/data/datasources/search_local_datasource_impl.dart';
import 'package:booko/features/search/data/datasources/search_remote_darasource.dart';
import 'package:booko/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:booko/features/profile/data/datasources/profile_remote_datasource.dart';

// Repositories & Usecases
import 'package:booko/features/search/data/repositories/search_repository_impl.dart';
import 'package:booko/features/search/domain/usecases/search_movies.dart';
import 'package:booko/features/search/presentation/providers/search_provider.dart';
import 'package:booko/features/profile/presentation/providers/profile_datasource_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SYSTEM UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // SHARED PREFERENCES
  final sharedPrefs = await SharedPreferences.getInstance();

  // HIVE INIT
  await Hive.initFlutter();

  // REGISTER ADAPTERS
  Hive.registerAdapter(SearchHiveModelAdapter());
  Hive.registerAdapter(ProfileHiveModelAdapter());
  Hive.registerAdapter(TicketModelAdapter());
  Hive.registerAdapter(TicketHiveModelAdapter());

  // OPEN BOXES
  final moviesBox = await Hive.openBox<SearchHiveModel>('movies_box');
  final profileBox = await Hive.openBox<ProfileHiveModel>('profileBox');

  // SEARCH DI
  final searchLocal = SearchLocalDataSourceImpl(moviesBox);
  await searchLocal.seedIfEmpty();

  final searchRemote = SearchRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: ApiEndpoints.baseUrl,
  );

  final searchRepo = SearchRepositoryImpl(
    local: searchLocal,
    remote: searchRemote,
  );

  final searchUsecase = SearchMovies(searchRepo);

  // PROFILE DI
  final profileLocal = ProfileLocalDataSourceImpl(profileBox);
  final profileRemote = ProfileRemoteDataSourceImpl(
    client: http.Client(),
    baseUrl: ApiEndpoints.baseUrl,
    tokenProvider: () async => sharedPrefs.getString('token'),
  );

  // AUTH & HIVE SERVICE
  final authHiveService = AuthHiveService();
  await authHiveService.init(); // initialize auth service

  // RUN APP
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        hiveServiceProvider.overrideWithValue(authHiveService),
        searchMoviesUsecaseProvider.overrideWithValue(searchUsecase),
        profileLocalDataSourceProvider.overrideWithValue(profileLocal),
        profileRemoteDataSourceProvider.overrideWithValue(profileRemote),
      ],
      child: const App(),
    ),
  );
}
