import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/data/models/weather_data.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class RainTimeline extends StatelessWidget {
  final List<HourlyWeather> hourlyList; // expecting next 24 hours

  const RainTimeline({
    Key? key,
    required this.hourlyList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool expectedRain = hourlyList.any((h) => h.precipitationProbability > 50);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.water_drop, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              '🌧 RAIN FORECAST',
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
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: expectedRain
              ? _buildRainTimeline()
              : _buildNoRain(),
        ),
      ],
    );
  }

  Widget _buildNoRain() {
    return Row(
      children: [
        const Icon(Icons.wb_sunny_outlined, color: Colors.yellowAccent, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'No rain expected in the next 24 hours',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildRainTimeline() {
    final rainHours = hourlyList.where((h) => h.precipitationProbability > 50).toList();
    final firstRain = rainHours.first.time;
    final lastRain = rainHours.last.time;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rain expected between ${DateFormat('h:mm a').format(firstRain)} and ${DateFormat('h:mm a').format(lastRain)}',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: hourlyList.map((hour) {
              final isRainy = hour.precipitationProbability > 50;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  decoration: BoxDecoration(
                    color: isRainy ? Colors.lightBlueAccent : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Now', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
            Text('+6h', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
            Text('+12h', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
            Text('+18h', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
            Text('+24h', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
