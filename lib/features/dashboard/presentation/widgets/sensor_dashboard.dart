import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booko/core/services/sensors/accelerometer_service.dart';
import 'package:booko/core/services/sensors/light_sensor_service.dart';

class SensorDashboard extends ConsumerWidget {
  const SensorDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelerometerAsync = ref.watch(accelerometerStreamProvider);
    final lightAsync = ref.watch(lightSensorStreamProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff111a2c).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff111a2c).withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sensors, size: 20, color: Color(0xff003366)),
              const SizedBox(width: 8),
              Text(
                'Environmental Sensors',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color(0xff003366),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SensorCard(
                  title: 'Accelerometer',
                  icon: Icons.speed,
                  content: accelerometerAsync.when(
                    data: (event) => 'X: ${event.x.toStringAsFixed(2)}\n'
                        'Y: ${event.y.toStringAsFixed(2)}\n'
                        'Z: ${event.z.toStringAsFixed(2)}',
                    loading: () => 'Loading...',
                    error: (e, _) => 'Not supported',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SensorCard(
                  title: 'Ambient Light',
                  icon: Icons.light_mode,
                  content: lightAsync.when(
                    data: (lux) => '$lux Lux\n\n${_getLightAdvice(lux)}',
                    loading: () => 'Loading...',
                    error: (e, _) => 'Not supported',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getLightAdvice(int lux) {
    if (lux < 10) return 'Very Dark';
    if (lux < 50) return 'Dim Light';
    if (lux < 500) return 'Normal';
    return 'Bright';
  }
}

class _SensorCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;

  const _SensorCard({
    required this.title,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.indigo),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xff111a2c),
            ),
          ),
        ],
      ),
    );
  }
}
