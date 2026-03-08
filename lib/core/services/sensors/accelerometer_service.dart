import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  Stream<AccelerometerEvent> get accelerometerEvents => accelerometerEventStream();
}

final accelerometerServiceProvider = Provider((ref) => AccelerometerService());

final accelerometerStreamProvider = StreamProvider<AccelerometerEvent>((ref) {
  final service = ref.watch(accelerometerServiceProvider);
  return service.accelerometerEvents;
});
