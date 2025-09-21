import 'dart:math';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// --- From Code 2: Data model for a single crop ---
class Crop {
  final int id;
  bool isHealthy;
  String details;

  Crop({required this.id, this.isHealthy = true, required this.details});
}

// --- Merged: Now a StatefulWidget to handle the interactive state ---
class FarmMapScreen extends StatefulWidget {
  // --- From Code 2: Accepts dynamic farm data ---
  final double farmLength;
  final double farmWidth;
  final int rows;
  final int plantsPerRow;

  const FarmMapScreen({
    super.key,
    required this.farmLength,
    required this.farmWidth,
    required this.rows,
    required this.plantsPerRow,
  });

  @override
  _FarmMapScreenState createState() => _FarmMapScreenState();
}

class _FarmMapScreenState extends State<FarmMapScreen> {
  late List<List<Crop>> _farmData;
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    _initializeFarmData();
  }

  // --- From Code 2: Logic to create the farm grid data ---
  void _initializeFarmData() {
    _farmData = List.generate(
      widget.rows,
      (rowIndex) => List.generate(widget.plantsPerRow, (plantIndex) {
        int id = rowIndex * widget.plantsPerRow + plantIndex;
        return Crop(
          id: id,
          details:
              'Crop $id - Row: ${rowIndex + 1}, Plant: ${plantIndex + 1}\n'
              'Type: Wheat\n'
              'Last Inspected: 2025-09-21\n'
              'Soil Moisture: 65%\n'
              'Pest Status: None detected',
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.farmMapView,
        hasBackButton: true,
      ),
      // --- From Code 1: The background UI structure ---
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            // The card now contains the interactive map
            Expanded(child: _buildMapCard()),
            const SizedBox(height: 20),
            _buildLegend(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildMapCard() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias, // Important for InteractiveViewer
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor, width: 1),
      ),
      // --- From Code 2: The interactive grid is now the child of the card ---
      child: _buildFarmGrid(),
    );
  }

  // --- From Code 2: The InteractiveViewer for zoom/pan functionality ---
  Widget _buildFarmGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double baseCropSize = 14.0;
        double contentWidth = widget.plantsPerRow * (baseCropSize + 4);
        double contentHeight = widget.rows * (baseCropSize + 4);

        double scaleX = constraints.maxWidth / contentWidth;
        double scaleY = constraints.maxHeight / contentHeight;
        double minScale = min(min(scaleX, scaleY), 1.0);

        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: minScale,
          maxScale: 5.0,
          constrained: false,
          boundaryMargin: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: contentWidth,
            height: contentHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.rows,
                (rowIndex) => _FarmRow(
                  crops: _farmData[rowIndex],
                  onCropTap: (crop) => _showCropDetails(context, crop),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- From Code 2: The pop-up dialog, now localized ---
  void _showCropDetails(BuildContext context, Crop crop) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${localizations.cropDetailsTitle} - ID: ${crop.id}'),
        content: Text(crop.details),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                crop.isHealthy = !crop.isHealthy;
                // You can update other details here as well
              });
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              crop.isHealthy
                  ? localizations.markAffected
                  : localizations.markHealthy,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  // --- From Code 1: The legend UI ---
  Widget _buildLegend(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(
          color: AppTheme.healthyColor,
          label: localizations.healthyPlants,
        ),
        const SizedBox(width: 24),
        _LegendItem(
          color: AppTheme.affectedColor,
          label: localizations.affectedPlants,
        ),
      ],
    );
  }
}

// --- From Code 2: The interactive row with tap handling ---
class _FarmRow extends StatelessWidget {
  final List<Crop> crops;
  final ValueChanged<Crop> onCropTap;

  const _FarmRow({required this.crops, required this.onCropTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: crops.map((crop) {
          return GestureDetector(
            onTap: () => onCropTap(crop),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                Icons.eco,
                size: 14,
                color: crop.isHealthy
                    ? AppTheme.healthyColor
                    : AppTheme.affectedColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- From Code 1: The legend item UI style ---
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
