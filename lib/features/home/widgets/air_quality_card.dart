import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast_pro/core/utils/aqi_utils.dart';
import 'package:weathercast_pro/providers/air_quality_provider.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class AirQualityCard extends ConsumerWidget {
  const AirQualityCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aqiState = ref.watch(airQualityProvider);

    return aqiState.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (airQuality) {
        if (airQuality == null) return const SizedBox.shrink();

        final currentAqi = airQuality.current.europeanAqi;
        final aqiColor = AqiUtils.getAqiColor(currentAqi);
        final aqiLevel = AqiUtils.getAqiLevel(currentAqi);
        final aqiDesc = AqiUtils.getAqiDescription(currentAqi);
        final aqiPercent = AqiUtils.getAqiPercentage(currentAqi);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.air, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(
                  '🌬 AIR QUALITY',
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Navigate to AirQualityScreen
              },
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentAqi.toString(),
                              style: GoogleFonts.poppins(
                                color: aqiColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              aqiLevel,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.health_and_safety, color: aqiColor, size: 40),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.green,
                            Colors.yellow,
                            Colors.orange,
                            Colors.red,
                            Colors.purple,
                            Colors.brown,
                          ],
                          stops: [0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: (aqiPercent * 100).toInt(),
                            child: const SizedBox(),
                          ),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black26, width: 2),
                            ),
                          ),
                          Expanded(
                            flex: 100 - (aqiPercent * 100).toInt(),
                            child: const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      aqiDesc,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
