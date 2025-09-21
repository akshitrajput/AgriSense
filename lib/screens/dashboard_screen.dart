import 'package:agrisense/screens/farm_map_screen.dart';
import 'package:agrisense/screens/health_report_screen.dart';
import 'package:agrisense/screens/plant_scan_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  final Map<String, dynamic> farmData;

  const DashboardScreen({super.key, required this.farmData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isRoverActive = false;
  bool isSprinklerActive = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        // CHANGE: The title now shows a personalized greeting.
        title: '${localizations.welcomeMessage} ${widget.farmData['name']}!',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFarmSummaryCard(localizations),
            const SizedBox(height: 24),
            _buildSmartControlsCard(localizations),
            const SizedBox(height: 24),
            _buildNavigationButtons(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmSummaryCard(AppLocalizations localizations) {
    return Card(
      elevation: 2,
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor, width: 1),
      ),
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
              '${widget.farmData['cropType']}',
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.aspect_ratio_outlined,
              localizations.area,
              '${widget.farmData['farmLength']}m × ${widget.farmData['farmBreadth']}m',
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              Icons.format_list_numbered,
              localizations.rows,
              '${widget.farmData['rows']}',
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
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor, width: 1),
      ),
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

  Widget _buildNavigationButtons(AppLocalizations localizations) {
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
                  farmLength: widget.farmData['farmLength'],
                  farmWidth: widget.farmData['farmBreadth'],
                  rows: widget.farmData['rows'],
                  plantsPerRow: widget.farmData['plantsPerRow'],
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
            // This can be changed to navigate to your actual history screen later
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HealthReportScreen(),
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
          style: ElevatedButton.styleFrom(
            // CHANGE: The button color is now the theme's primaryColor.
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
