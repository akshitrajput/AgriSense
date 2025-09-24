import 'package:agrisense/models/daily_forecast.dart';
import 'package:agrisense/models/farm_data.dart';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/farm_map_screen.dart';
import 'package:agrisense/screens/history_screen.dart';
import 'package:agrisense/screens/plant_scan_screen.dart';
import 'package:agrisense/screens/settings_screen.dart';
import 'package:agrisense/services/weather_service.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

// NOTE: The fl_chart import has been removed as it's no longer needed.

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<DailyForecast>> _forecastFuture;

  @override
  void initState() {
    super.initState();
    _forecastFuture = WeatherService.fetchWeatherForecast();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final farmData = context.watch<FarmDataProvider>().farmData;

    if (context.watch<FarmDataProvider>().isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: CustomAppBar(
        title: '${localizations.welcomeMessage} ${farmData.name}',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings_outlined, size: 28.0),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWeatherForecastCard(),
            const SizedBox(height: 24),
            // REMOVED: The call to _buildHealthStatusCard(localizations)
            _buildActionButtons(localizations, farmData),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherForecastCard() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Weather Forecast",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<DailyForecast>>(
              future: _forecastFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child:
                      CircularProgressIndicator(color: AppTheme.primaryColor),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: AppTheme.affectedColor),
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 120,
                    child: Center(
                      child: Text('No forecast data available.'),
                    ),
                  );
                }
                final forecasts = snapshot.data!;
                return SizedBox(
                  height: 120,
                  child: Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: forecasts
                            .map((forecast) => _buildDailyForecastItem(forecast))
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecastItem(DailyForecast forecast) {
    final String iconUrl = 'https:${forecast.weatherIconCode}';
    return Container(
      width: 85,
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            AppTheme.primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEE').format(forecast.dateTime),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Image.network(
            iconUrl,
            width: 45,
            height: 45,
            errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.cloud_off, size: 40, color: AppTheme.subTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            '${forecast.temp.round()}°C',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // REMOVED: The entire _buildHealthStatusCard widget and its helper methods
  // (bottomTitleWidgets and leftTitleWidgets) are now gone.

  Widget _buildActionButtons(AppLocalizations localizations, FarmData farmData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 16.0),
          child: Text(
            localizations.toolsAndAnalytics,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textColor,
            ),
          ),
        ),
        Card(
          elevation: 4,
          shadowColor: AppTheme.primaryColor.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildActionButtonRow(
                  icon: Icons.map_outlined,
                  label: localizations.viewFarmMap,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FarmMapScreen(
                          farmLength: farmData.farmLength,
                          farmWidth: farmData.farmBreadth,
                          rows: farmData.rows,
                          plantsPerRow: farmData.plantsPerRow,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 24),
                _buildActionButtonRow(
                  icon: Icons.article_outlined,
                  label: localizations.viewPreviousReports,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HistoryScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlantScanScreen()),
            );
          },
          icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
          label: Text(localizations.scanNewPlant,
              style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            elevation: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonRow(
      {required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: AppTheme.subTextColor, size: 16),
          ],
        ),
      ),
    );
  }
}