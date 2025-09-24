// **STEP 1: Add required imports for map functionality**
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:agrisense/providers/farm_data_provider.dart';
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
  final double _tankCapacity = 0.75; // 75%
  final double _powerCharge = 0.90; // 90%

  // **STEP 2: Define Rover's location coordinates**
  final LatLng _roverLocation = const LatLng(12.8406, 80.1534); // VIT Chennai

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final farmDataProvider = context.watch<FarmDataProvider>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(title: "Rover Control Panel"),
      // **STEP 3: Removed the Stack widget as the FAB is no longer needed**
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeaderStatus(),
            const SizedBox(height: 24),
            _buildSmartControlsCard(localizations, farmDataProvider),
            const SizedBox(height: 24),
            // **STEP 4: Added the new map view card here**
            _buildMapView(),
          ],
        ),
      ),
    );
  }

  // **STEP 5: New widget to build the map view card**
  Widget _buildMapView() {
    return Card(
      elevation: 4,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior:
          Clip.antiAlias, // Ensures the map respects the card's rounded corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Text(
              "Current Location",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 220,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _roverLocation,
                initialZoom: 16.0,
                // Disable map interaction to keep it as a static view
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.agrisense',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _roverLocation,
                      width: 80,
                      height: 80,
                      child: Icon(
                        Icons.location_on,
                        size: 45,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
            _buildCircularStatusIndicator(
              icon: Icons.opacity,
              label: "Sprinkler",
              value: _tankCapacity,
              color: Colors.blue.shade400,
            ),
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
                provider.updateRoverState(newValue);
              },
            ),
            const Divider(height: 24),
            _buildControlToggle(
              icon: Icons.water_drop_outlined,
              label: localizations.sprinklerSystem,
              value: provider.isSprinklerActive,
              onChanged: (newValue) {
                provider.updateSprinklerState(newValue);
              },
            ),
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
