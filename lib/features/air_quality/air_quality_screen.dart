import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weathercast_pro/providers/air_quality_provider.dart';
import 'package:weathercast_pro/core/utils/aqi_utils.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';
import 'package:weathercast_pro/widgets/gradient_scaffold.dart';
import 'package:weathercast_pro/widgets/shimmer_loading.dart';

class AirQualityScreen extends ConsumerWidget {
  const AirQualityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqState = ref.watch(airQualityProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Air Quality'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: aqState.when(
        data: (aqData) {
          final current = aqData.current;
          final aqiColor = AqiUtils.getAqiColor(current.europeanAqi);
          final aqiLabel = AqiUtils.getAqiLabel(current.europeanAqi);
          final aqiMessage = AqiUtils.getAqiMessage(current.europeanAqi);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // AQI Gauge
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: current.europeanAqi / 100,
                        strokeWidth: 16,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(aqiColor),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${current.europeanAqi}',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: aqiColor,
                          ),
                        ),
                        Text(
                          aqiLabel,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Recommendations
                GlassCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.health_and_safety, color: aqiColor, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            aqiMessage,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Pollutants Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildPollutantCard('PM2.5', current.pm2_5, 25, 'µg/m³'),
                    _buildPollutantCard('PM10', current.pm10, 50, 'µg/m³'),
                    _buildPollutantCard('Ozone (O₃)', current.ozone, 100, 'µg/m³'),
                    _buildPollutantCard('NO₂', current.nitrogenDioxide, 40, 'µg/m³'),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: ShimmerLoading()),
        error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildPollutantCard(String name, double value, double limit, String unit) {
    final double percent = (value / limit).clamp(0.0, 1.0);
    final Color barColor = percent < 0.5 ? Colors.green : (percent < 0.8 ? Colors.orange : Colors.red);
    
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(1)} $unit',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
