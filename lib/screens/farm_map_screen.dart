import 'dart:math';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';

// Data model for a single crop
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
  // --- State for the Grid View ---
  late List<List<Crop>> _farmData;
  final TransformationController _transformationController = TransformationController();

  // --- State for the new Map View ---
  bool _showGridView = false; // Start with the real map view first
  bool _isLoadingLocation = true;
  LatLng? _currentLocation;
  String _locationError = '';

  @override
  void initState() {
    super.initState();
    _initializeFarmData();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(mounted) setState(() => _locationError = 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(mounted) setState(() => _locationError = 'Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if(mounted) setState(() => _locationError = 'Location permissions are permanently denied.');
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if(mounted) setState(() => _locationError = 'Failed to get user location.');
    }
  }

  void _initializeFarmData() {
    _farmData = List.generate(
      widget.rows,
          (rowIndex) => List.generate(
        widget.plantsPerRow,
            (plantIndex) {
          int id = rowIndex * widget.plantsPerRow + plantIndex;
          return Crop(
            id: id,
            details: 'Crop $id - Row: ${rowIndex + 1}, Plant: ${plantIndex + 1}\n'
                'Type: Wheat\n'
                'Last Inspected: 2025-09-25\n'
                'Soil Moisture: 65%\n'
                'Pest Status: None detected',
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.farmMapView,
        hasBackButton: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showGridView = !_showGridView;
              });
            },
            icon: Icon(
              _showGridView ? Icons.map_outlined : Icons.grid_view_outlined,
              size: 28,
            ),
            tooltip: _showGridView ? 'Show Real Map' : 'Show Grid View',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: _isLoadingLocation
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                  : _locationError.isNotEmpty
                  ? Center(child: Text(_locationError, style: const TextStyle(color: AppTheme.affectedColor, fontSize: 16), textAlign: TextAlign.center,))
                  : _showGridView
                  ? _buildMapCard() // Your interactive grid view
                  : _buildFlutterMap(), // The real-world map
            ),
            const SizedBox(height: 20),
            _buildLegend(localizations),
          ],
        ),
      ),
    );
  }

  Widget _buildFlutterMap() {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation ?? const LatLng(13.0827, 80.2707),
          initialZoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.agrisense',
          ),
          MarkerLayer(
            markers: [
              if (_currentLocation != null)
                Marker(
                  point: _currentLocation!,
                  width: 80,
                  height: 80,
                  child: const Icon(
                    Icons.location_on,
                    size: 45,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ],
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
                  onCropTap: (crop) => _showCropDetails(crop),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCropDetails(Crop crop) {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('${localizations.cropDetailsTitle} - ID: ${crop.id}'),
        content: Text(crop.details),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                crop.isHealthy = !crop.isHealthy;
              });
              Navigator.of(dialogContext).pop();
            },
            child: Text(crop.isHealthy ? localizations.markAffected : localizations.markHealthy),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(localizations.close),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(AppLocalizations localizations) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendItem(color: AppTheme.healthyColor, label: localizations.healthyPlants),
        const SizedBox(width: 24),
        _LegendItem(color: AppTheme.affectedColor, label: localizations.affectedPlants),
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
                color: crop.isHealthy ? AppTheme.healthyColor : AppTheme.affectedColor,
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