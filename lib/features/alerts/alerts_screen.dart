import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/data/models/weather_alert.dart';
import 'package:weathercast_pro/providers/weather_provider.dart';
import 'package:weathercast_pro/providers/air_quality_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';

class AlertsScreen extends ConsumerWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherState = ref.watch(weatherProvider);
    final airQualityState = ref.watch(airQualityProvider);

    List<WeatherAlert> alerts = [];
    if (weatherState.value != null && airQualityState.value != null) {
      alerts = WeatherAlert.generateAlerts(weatherState.value!, airQualityState.value!);
      alerts.sort((a, b) => b.severity.index.compareTo(a.severity.index));
    }

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Weather Alerts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 80, color: Colors.greenAccent),
                  const SizedBox(height: 16),
                  Text(
                    'No active weather alerts.\nConditions are safe.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GlassCard(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: _getSeverityColor(alert.severity), width: 6),
                          ),
                        ),
                        child: ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white70,
                          leading: Icon(alert.icon, color: _getSeverityColor(alert.severity), size: 32),
                          title: Text(
                            alert.title,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            alert.description,
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, color: Colors.white70, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Effective: ${alert.timeRange}',
                                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Safety Guidance',
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          alert.guidance,
                                          style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getSeverityColor(AlertSeverity severity) {
    switch (severity) {
      case AlertSeverity.low:
        return Colors.yellowAccent;
      case AlertSeverity.medium:
        return Colors.orangeAccent;
      case AlertSeverity.high:
        return Colors.redAccent;
      case AlertSeverity.extreme:
        return Colors.purpleAccent;
    }
  }
}
