import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weathercast_pro/providers/settings_provider.dart';
import 'package:weathercast_pro/providers/theme_provider.dart';
import 'package:weathercast_pro/core/services/storage_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('UNITS'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.thermostat),
                  title: const Text('Temperature Unit'),
                  trailing: SegmentedButton<TemperatureUnit>(
                    segments: const [
                      ButtonSegment(value: TemperatureUnit.celsius, label: Text('°C')),
                      ButtonSegment(value: TemperatureUnit.fahrenheit, label: Text('°F')),
                      ButtonSegment(value: TemperatureUnit.kelvin, label: Text('K')),
                    ],
                    selected: {settingsState.temperatureUnit},
                    onSelectionChanged: (set) {
                      ref.read(settingsProvider.notifier).setTemperatureUnit(set.first);
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.air),
                  title: const Text('Wind Speed Unit'),
                  subtitle: SegmentedButton<WindUnit>(
                    segments: const [
                      ButtonSegment(value: WindUnit.kmh, label: Text('km/h')),
                      ButtonSegment(value: WindUnit.mph, label: Text('mph')),
                      ButtonSegment(value: WindUnit.ms, label: Text('m/s')),
                      ButtonSegment(value: WindUnit.knots, label: Text('kt')),
                    ],
                    selected: {settingsState.windUnit},
                    onSelectionChanged: (set) {
                      ref.read(settingsProvider.notifier).setWindUnit(set.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('APPEARANCE'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme Mode'),
              trailing: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.light, label: Icon(Icons.light_mode)),
                  ButtonSegment(value: ThemeMode.dark, label: Icon(Icons.dark_mode)),
                  ButtonSegment(value: ThemeMode.system, label: Icon(Icons.brightness_auto)),
                ],
                selected: {themeMode},
                onSelectionChanged: (set) {
                  ref.read(themeProvider.notifier).setThemeMode(set.first);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('ABOUT'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('WeatherCast Pro'),
                  subtitle: Text('Version 1.0.0\nForecasting Tomorrow, Today.'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Data Source'),
                  subtitle: const Text('Powered by Open-Meteo'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () async {
                    final url = Uri.parse('https://open-meteo.com/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('PRIVACY'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const Text(
                      '• Your location is used only for weather forecasts\n'
                      '• No personal data is collected or shared\n'
                      '• All data is stored locally on your device',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader('FEEDBACK'),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate App'),
                  onTap: () {
                    // Placeholder for rating logic
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share App'),
                  onTap: () {
                    // Placeholder for sharing logic
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
