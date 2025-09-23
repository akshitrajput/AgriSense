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

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isRoverActive = false;
  bool isSprinklerActive = false;
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

    return Scaffold(
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
            _buildFarmSummaryCard(localizations, farmData),
            const SizedBox(height: 24),
            _buildSmartControlsCard(localizations),
            const SizedBox(height: 24),
            _buildNavigationButtons(localizations, farmData),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherForecastCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "7-Day Forecast",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<DailyForecast>>(
              future: _forecastFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    heightFactor: 3,
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: AppTheme.affectedColor),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final forecasts = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: forecasts
                          .map((forecast) => _buildDailyForecastItem(forecast))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No forecast data available.'),
                  );
                }
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
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
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
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.cloud_off,
              color: AppTheme.subTextColor,
              size: 40,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${forecast.temp.round()}°C',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmSummaryCard(
    AppLocalizations localizations,
    FarmData farmData,
  ) {
    String cropDisplay = 'N/A';
    final String? cropKey = farmData.cropTypeKey;
    if (cropKey != null) {
      final Map<String, String> translatedCrops = {
        'wheat': localizations.cropWheat,
        'maize': localizations.cropMaize,
        'corn': localizations.cropCorn,
        'tomato': localizations.cropTomato,
        'potato': localizations.cropPotato,
      };
      cropDisplay = translatedCrops[cropKey] ?? 'N/A';
    }
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.farmSummary,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              Icons.eco_outlined,
              localizations.crop,
              cropDisplay,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.aspect_ratio_outlined,
              localizations.area,
              '${farmData.farmLength}m × ${farmData.farmBreadth}m',
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.format_list_numbered,
              localizations.rows,
              '${farmData.rows}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 20),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartControlsCard(AppLocalizations localizations) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.smartControls,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildControlRow(
              icon: Icons.precision_manufacturing_outlined,
              label: localizations.autonomousRover,
              isActive: isRoverActive,
              onToggle: () => setState(() => isRoverActive = !isRoverActive),
              localizations: localizations,
            ),
            const Divider(height: 24),
            _buildControlRow(
              icon: Icons.water_drop_outlined,
              label: localizations.sprinklerSystem,
              isActive: isSprinklerActive,
              onToggle: () =>
                  setState(() => isSprinklerActive = !isSprinklerActive),
              localizations: localizations,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlRow({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onToggle,
    required AppLocalizations localizations,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primaryColor : AppTheme.affectedColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isActive ? localizations.on : localizations.off,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(
    AppLocalizations localizations,
    FarmData farmData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.toolsAndAnalytics,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
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
          icon: const Icon(Icons.map_outlined),
          label: Text(localizations.viewFarmMap),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HistoryScreen(),
              ),
            );
          },
          icon: const Icon(Icons.article_outlined),
          label: Text(localizations.viewPreviousReports),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlantScanScreen()),
            );
          },
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(localizations.scanNewPlant),
        ),
      ],
    );
  }
}