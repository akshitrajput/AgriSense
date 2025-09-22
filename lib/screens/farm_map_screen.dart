import 'dart:math';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class Crop {
  final int id;
  bool isHealthy;
  String details;

  Crop({required this.id, this.isHealthy = true, required this.details});
}

class FarmMapScreen extends StatefulWidget {
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
  final TransformationController _transformationController = TransformationController();
  String _cropDisplayName = 'N/A';

  @override
  void initState() {
    super.initState();
    // Initialize data after the first frame to safely access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFarmData();
    });
  }

  void _initializeFarmData() {
    final farmData = context.read<FarmDataProvider>().farmData;
    final localizations = AppLocalizations.of(context)!;

    // Get the translated crop name from the provider data
    final String? cropKey = farmData['cropTypeKey'];
    if (cropKey != null) {
      final Map<String, String> translatedCrops = {
        'wheat': localizations.cropWheat,
        'maize': localizations.cropMaize,
        'corn': localizations.cropCorn,
        'tomato': localizations.cropTomato,
        'potato': localizations.cropPotato,
      };
      _cropDisplayName = translatedCrops[cropKey] ?? 'N/A';
    }

    setState(() {
      _farmData = List.generate(
        widget.rows,
            (rowIndex) => List.generate(widget.plantsPerRow, (plantIndex) {
          int id = rowIndex * widget.plantsPerRow + plantIndex;
          return Crop(
            id: id,
            details: 'Crop $id - Row: ${rowIndex + 1}, Plant: ${plantIndex + 1}\n'
                'Type: $_cropDisplayName\n' // Use dynamic crop name
                'Last Inspected: 2025-09-22\n'
                'Soil Moisture: 65%\n'
                'Pest Status: None detected',
          );
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Show a loading indicator until farm data is initialized
    if (_farmData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.farmMapView,
        hasBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
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
      clipBehavior: Clip.antiAlias,
      shadowColor: AppTheme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderColor, width: 1),
      ),
      child: _buildFarmGrid(),
    );
  }

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

                // Get today's date and format it
                final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

                // Update the details string with the new health status and today's date
                crop.details = 'Crop ${crop.id} - Row: ${rowIndex(crop.id)} Plant: ${plantIndex(crop.id)}\n'
                    'Type: $_cropDisplayName\n'
                    'Last Inspected: $formattedDate\n' // Use current date
                    'Soil Moisture: 62%\n'
                    'Pest Status: ${crop.isHealthy ? 'None detected' : 'Disease suspected!'}';
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

  // Helper functions to calculate row and plant index from ID
  int rowIndex(int id) => id ~/ widget.plantsPerRow + 1;
  int plantIndex(int id) => id % widget.plantsPerRow + 1;

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

