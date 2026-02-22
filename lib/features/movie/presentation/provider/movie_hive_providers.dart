import 'package:booko/features/movie/data/models/showtime_hive_model.dart';
import 'package:booko/features/search/data/models/movie_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const movieBoxName = 'movieBox';
const showtimeBoxName = 'showtimeBox';

final movieHiveInitProvider = FutureProvider<void>((ref) async {
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(MovieHiveModelAdapter());
  }
  if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(ShowtimeHiveModelAdapter());
  }

  if (!Hive.isBoxOpen(movieBoxName)) {
    await Hive.openBox<MovieHiveModel>(movieBoxName);
  }
  if (!Hive.isBoxOpen(showtimeBoxName)) {
    await Hive.openBox<ShowtimeHiveModel>(showtimeBoxName);
  }
});

final movieBoxProvider = Provider<Box<MovieHiveModel>>((ref) {
  ref.watch(movieHiveInitProvider);
  return Hive.box<MovieHiveModel>(movieBoxName);
});

final showtimeBoxProvider = Provider<Box<ShowtimeHiveModel>>((ref) {
  ref.watch(movieHiveInitProvider);
  return Hive.box<ShowtimeHiveModel>(showtimeBoxName);
});
