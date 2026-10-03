import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F23) : Colors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 150, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                    Container(width: 24, height: 24, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 40),
                const ShimmerWeatherHero(),
                const SizedBox(height: 40),
                const ShimmerDetailsGrid(),
                const SizedBox(height: 32),
                Container(width: 150, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 16),
                const ShimmerHourlyStrip(),
                const SizedBox(height: 32),
                Container(width: 150, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10))),
                const SizedBox(height: 16),
                Container(height: 400, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerWeatherHero extends StatelessWidget {
  const ShimmerWeatherHero({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: Container(width: 120, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
        const SizedBox(height: 16),
        Center(child: Container(width: 180, height: 100, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
        const SizedBox(height: 16),
        Center(child: Container(width: 140, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)))),
      ],
    );
  }
}

class ShimmerDetailsGrid extends StatelessWidget {
  const ShimmerDetailsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
      children: List.generate(6, (index) => Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      )),
    );
  }
}

class ShimmerHourlyStrip extends StatelessWidget {
  const ShimmerHourlyStrip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            width: 75,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
