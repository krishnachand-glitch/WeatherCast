# WeatherCast Pro

Premium Weather Intelligence Platform.

## Features
- Comprehensive weather forecasting (Current, Hourly, Daily)
- Air Quality Index & Detailed Pollutants
- UV Index Tracking & Sun Safety
- Smart Weather Alerts & Warnings
- Multiple Location Management (Favorites)
- Elegant Glassmorphic UI with Dynamic Backgrounds
- Light/Dark/System Theme Support

## Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Networking**: Dio
- **Local Storage**: Hive
- **Maps**: Flutter Map & LatLng2
- **Charting**: Fl_Chart
- **APIs**: Open-Meteo (Weather, Air Quality, Geocoding) - No API Key Required!

## Setup Instructions

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```
4. Build APK (Android):
   ```bash
   flutter build apk
   ```

## Architecture
This app follows a feature-driven, layered architecture:
- `core/`: Shared constants, utilities, and services.
- `data/`: Data models and repositories.
- `ui/`: Screens and reusable widgets.

## License
MIT License.
