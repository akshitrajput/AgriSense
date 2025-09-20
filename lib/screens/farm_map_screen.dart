import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/bottom_nav_buttons.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FarmMapScreen extends StatelessWidget {
  const FarmMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Farm Map View', hasBackButton: true),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            _buildMapCard(),
            const SizedBox(height: 20),
            _buildLegend(),
            const Spacer(),
            const BottomNavButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDimensionLabel(label: 'Length: 100m', isHorizontal: true),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDimensionLabel(label: 'Width: 50m', isHorizontal: false),
                const SizedBox(width: 8),
                Expanded(child: _buildFarmGrid()),
                const SizedBox(width: 8),
                _buildDimensionLabel(label: 'Width: 50m', isHorizontal: false),
              ],
            ),
            const SizedBox(height: 8),
            _buildDimensionLabel(label: 'Length: 100m', isHorizontal: true),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmGrid() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.borderColor.withOpacity(0.5), style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(
          6,
          (rowIndex) => _FarmRow(
            plantCount: 15,
            isAffected: rowIndex >= 4, // Make last two rows affected
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionLabel({required String label, bool isHorizontal = true}) {
    Widget text = Text(label, style: const TextStyle(color: AppTheme.subTextColor, fontSize: 12));
    if (isHorizontal) {
      return text;
    } else {
      return RotatedBox(quarterTurns: -1, child: text);
    }
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppTheme.healthyColor, label: 'Healthy Plants'),
        SizedBox(width: 24),
        _LegendItem(color: AppTheme.affectedColor, label: 'Affected Plants'),
      ],
    );
  }
}

class _FarmRow extends StatelessWidget {
  final int plantCount;
  final bool isAffected;

  const _FarmRow({required this.plantCount, this.isAffected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isAffected ? AppTheme.affectedColor.withOpacity(0.2) : AppTheme.healthyColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          plantCount,
          (index) => Icon(
            Icons.eco,
            size: 14,
            color: isAffected ? AppTheme.affectedColor : AppTheme.healthyColor,
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 8, backgroundColor: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: AppTheme.subTextColor)),
      ],
    );
  }
}