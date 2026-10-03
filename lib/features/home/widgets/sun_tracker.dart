import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weathercast_pro/features/home/painters/sun_arc_painter.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class SunTracker extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;

  const SunTracker({
    Key? key,
    required this.sunrise,
    required this.sunset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    String statusText;
    if (now.isBefore(sunrise)) {
      final diff = sunrise.difference(now);
      statusText = 'Sunrise in ${diff.inHours}h ${diff.inMinutes % 60}m';
    } else if (now.isBefore(sunset)) {
      final diff = sunset.difference(now);
      statusText = 'Sunset in ${diff.inHours}h ${diff.inMinutes % 60}m';
    } else {
      statusText = 'Sun has set';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.wb_sunny, color: Colors.white70, size: 16),
            const SizedBox(width: 8),
            Text(
              '☀ SUN TRACKER',
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
          child: Column(
            children: [
              SizedBox(
                height: 150,
                width: double.infinity,
                child: CustomPaint(
                  painter: SunArcPainter(
                    sunrise: sunrise,
                    sunset: sunset,
                    currentTime: now,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.wb_twilight, color: Colors.orangeAccent),
                      Text(
                        DateFormat('h:mm a').format(sunrise),
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    statusText,
                    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(Icons.nights_stay, color: Colors.deepPurpleAccent),
                      Text(
                        DateFormat('h:mm a').format(sunset),
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
