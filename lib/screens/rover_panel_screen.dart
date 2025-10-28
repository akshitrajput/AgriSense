// lib/screens/rover_panel_screen.dart
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/services/mqtt_service.dart'; // Import the service
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class RoverPanelScreen extends StatefulWidget {
  const RoverPanelScreen({super.key});

  @override
  State<RoverPanelScreen> createState() => _RoverPanelScreenState();
}

class _RoverPanelScreenState extends State<RoverPanelScreen> {
  // Dummy data for visual indicators
  // final double _tankCapacity = 0.75; // REMOVED
  final double _powerCharge = 0.90; // 90%

  @override
  void initState() {
    super.initState();
    context.read<MQTTService>().connect();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final farmDataProvider = context.watch<FarmDataProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: "Rover Control Panel"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderStatus(),
            const SizedBox(height: 24),
            _buildSmartControlsCard(localizations, farmDataProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderStatus() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // --- Sprinkler Indicator REMOVED ---
            _buildCircularStatusIndicator(
              icon: Icons.battery_charging_full,
              label: "Battery",
              value: _powerCharge,
              color: Colors.green.shade500,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularStatusIndicator({
    required IconData icon,
    required String label,
    required double value,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 8,
                backgroundColor: AppTheme.borderColor,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(child: Icon(icon, color: color, size: 32)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
        ),
        const SizedBox(height: 4),
        Text(
          '${(value * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSmartControlsCard(
      AppLocalizations localizations,
      FarmDataProvider provider,
      ) {
    final mqttService = context.read<MQTTService>();

    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.smartControls,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildControlToggle(
              icon: Icons.smart_toy_outlined,
              label: localizations.autonomousRover,
              value: provider.isRoverActive,
              onChanged: (newValue) {
                mqttService.publish(newValue ? "start_bot" : "stop_bot");
              },
            ),

            // --- Sprinkler Toggle and Divider REMOVED ---

            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.subTextColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    provider.lastStatusMessage,
                    style: TextStyle(fontSize: 14, color: AppTheme.subTextColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildControlToggle({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
          inactiveThumbColor: AppTheme.subTextColor,
          inactiveTrackColor: AppTheme.borderColor,
        ),
      ],
    );
  }
}