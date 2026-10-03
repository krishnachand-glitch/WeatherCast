import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weathercast_pro/core/utils/weather_utils.dart';
import 'package:weathercast_pro/features/home/painters/weather_bg_painter.dart';
import 'package:weathercast_pro/features/home/widgets/air_quality_card.dart';
import 'package:weathercast_pro/features/home/widgets/daily_forecast_list.dart';
import 'package:weathercast_pro/features/home/widgets/hourly_forecast_strip.dart';
import 'package:weathercast_pro/features/home/widgets/rain_timeline.dart';
import 'package:weathercast_pro/features/home/widgets/sun_tracker.dart';
import 'package:weathercast_pro/features/home/widgets/weather_details_grid.dart';
import 'package:weathercast_pro/features/home/widgets/weather_hero.dart';
import 'package:weathercast_pro/features/home/widgets/weather_insights_card.dart';
import 'package:weathercast_pro/features/map/weather_map_screen.dart';
import 'package:weathercast_pro/features/favorites/favorites_screen.dart';
import 'package:weathercast_pro/features/settings/settings_screen.dart';
import 'package:weathercast_pro/features/search/search_screen.dart';
import 'package:weathercast_pro/features/alerts/alerts_screen.dart';
import 'package:weathercast_pro/providers/location_provider.dart';
import 'package:weathercast_pro/providers/settings_provider.dart';
import 'package:weathercast_pro/providers/weather_provider.dart';
import 'package:weathercast_pro/providers/air_quality_provider.dart';
import 'package:weathercast_pro/providers/shared_providers.dart';
import 'package:weathercast_pro/widgets/shimmer_loading.dart';
import 'package:weathercast_pro/widgets/glass_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherMapScreen()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.watch(weatherProvider);
    final locationState = ref.watch(locationProvider);
    final settings = ref.watch(settingsProvider);
    final airQuality = ref.watch(airQualityProvider);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _buildBottomNavBar(),
      body: weatherState.when(
        loading: () => const ShimmerLoading(),
        error: (error, stack) => _buildErrorState(error),
        data: (weatherData) {
          final location = locationState.selectedLocation;
          if (location == null) return const ShimmerLoading();

          final currentWeather = weatherData.current;
          final todayDaily = weatherData.daily.first;
          final bool isDay = WeatherUtils.isDay(
            todayDaily.sunrise,
            todayDaily.sunset,
            DateTime.now(),
          );
          final gradientColors = WeatherUtils.getBackgroundGradient(
            currentWeather.weatherCode,
            isDay,
          );

          return Stack(
            children: [
              WeatherBackgroundWidget(
                weatherCode: currentWeather.weatherCode,
                isDay: isDay,
                gradientColors: gradientColors,
              ),
              RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(weatherProvider);
                  ref.invalidate(airQualityProvider);
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              _buildTopBar(locationState.cityName, locationState.country),
                              const SizedBox(height: 16),
                              WeatherHero(
                                currentWeather: currentWeather,
                                dailyWeather: todayDaily,
                                cityName: locationState.cityName,
                                tempUnit: settings.temperatureUnit,
                              ),
                              const SizedBox(height: 24),
                              WeatherDetailsGrid(
                                currentWeather: currentWeather,
                                todayDaily: todayDaily,
                              ),
                              const SizedBox(height: 24),
                              HourlyForecastStrip(
                                hourlyList: weatherData.hourly,
                                tempUnit: settings.temperatureUnit,
                                isDay: isDay,
                              ),
                              const SizedBox(height: 24),
                              DailyForecastList(
                                dailyList: weatherData.daily,
                                tempUnit: settings.temperatureUnit,
                              ),
                              const SizedBox(height: 24),
                              WeatherInsightsCard(
                                weatherData: weatherData,
                                airQualityData: airQuality.valueOrNull,
                              ),
                              const SizedBox(height: 24),
                              const AirQualityCard(),
                              const SizedBox(height: 24),
                              SunTracker(
                                sunrise: todayDaily.sunrise,
                                sunset: todayDaily.sunset,
                              ),
                              const SizedBox(height: 24),
                              RainTimeline(
                                hourlyList: weatherData.hourly.take(24).toList(),
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopBar(String cityName, String? country) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (country != null)
                        Text(
                          country,
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AlertsScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF0F0F23)],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GlassCard(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
                ),
                const SizedBox(height: 24),
                Text(
                  'Unable to load weather',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => ref.invalidate(weatherProvider),
                    icon: const Icon(Icons.refresh, size: 20),
                    label: Text(
                      'Try Again',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF16213E).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4FC3F7),
          unselectedItemColor: Colors.white38,
          selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}
