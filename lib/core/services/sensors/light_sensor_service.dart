import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorService {
  Stream<int> get luxEvents => LightSensor.luxStream();
}

final lightSensorServiceProvider = Provider((ref) => LightSensorService());

final lightSensorStreamProvider = StreamProvider<int>((ref) {
  final service = ref.watch(lightSensorServiceProvider);
  return service.luxEvents;
});
