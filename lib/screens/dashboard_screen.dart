import 'package:agrisense/screens/farm_map_screen.dart';
import 'package:agrisense/screens/plant_scan_screen.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:agrisense/theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false;
  bool isRoverActive = false;
  bool isSprinklerActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your Farm Overview',
        actions: [
          Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_rounded, color: AppTheme.subTextColor),
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
                // Add theme switching logic here
              });
            },
            activeColor: AppTheme.primaryColor,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildFarmSummaryCard(),
            const SizedBox(height: 24),
            _buildSmartControlsCard(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlantScanScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Start Plant Health Scan'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
             const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FarmMapScreen()),
                );
              },
              icon: const Icon(Icons.map_outlined, color: AppTheme.primaryColor),
              label: const Text('View Farm Map', style: TextStyle(color: AppTheme.primaryColor)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: AppTheme.primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFarmSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Farm Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildSummaryRow(Icons.eco_outlined, 'Crop:', 'Wheat'),
            const SizedBox(height: 12),
            _buildSummaryRow(Icons.aspect_ratio_outlined, 'Area:', '1000m × 500m'),
            const SizedBox(height: 12),
            _buildSummaryRow(Icons.format_list_numbered, 'Rows:', '400'),
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
        Text(title, style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor)),
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

  Widget _buildSmartControlsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Smart Controls', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildControlRow(
              icon: Icons.precision_manufacturing_outlined,
              label: 'Autonomous Rover',
              isActive: isRoverActive,
              onToggle: () => setState(() => isRoverActive = !isRoverActive),
            ),
            const Divider(height: 24),
            _buildControlRow(
              icon: Icons.water_drop_outlined,
              label: 'Sprinkler System',
              isActive: isSprinklerActive,
              onToggle: () => setState(() => isSprinklerActive = !isSprinklerActive),
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
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 16),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const Spacer(),
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.accentColor : AppTheme.affectedColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isActive ? 'ON' : 'OFF',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}