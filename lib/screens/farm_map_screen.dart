import 'dart:math';
import 'package:agrisense/screens/plant_scan_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';

// Data model for a single crop (for the grid view)
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
  final TransformationController _transformationController =
  TransformationController();
  // **FIX:** Add a flag to initialize the grid view's position only once.
  bool _isGridInitialized = false;

  // --- State for the Map View ---
  bool _showGridView = false; // Start with the real map view
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
      if (mounted) {
        setState(() => _locationError = 'Location services are disabled.');
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() => _locationError = 'Location permissions are denied.');
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        setState(() =>
        _locationError = 'Location permissions are permanently denied.');
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (mounted) {
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _locationError = 'Failed to get user location.');
      }
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
            details:
            'Crop $id - Row: ${rowIndex + 1}, Plant: ${plantIndex + 1}\n'
                'Type: Wheat\n'
                'Last Inspected: 2025-09-26\n'
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
        title: "Farm Map",
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
                  ? const Center(
                  child: CircularProgressIndicator(
                      color: AppTheme.primaryColor))
                  : _locationError.isNotEmpty
                  ? Center(
                  child: Text(_locationError,
                      style: const TextStyle(
                          color: AppTheme.affectedColor,
                          fontSize: 16),
                      textAlign: TextAlign.center))
                  : _showGridView
                  ? _buildMapCard() // The interactive grid view
                  : _buildFlutterMap(), // The real-world map with the rectangle
            ),
            if (_showGridView) // Only show legend for the grid view
              ...[
                const SizedBox(height: 20),
                _buildLegend(localizations),
              ]
          ],
        ),
      ),
    );
  }

  Widget _buildFlutterMap() {
    const double metersToLatLon = 0.000009;
    double latOffset;
    double lngOffset;

    if (widget.farmWidth > widget.farmLength) {
      latOffset = (widget.farmLength / 2) * metersToLatLon;
      lngOffset = (widget.farmWidth / 2) * metersToLatLon;
    } else {
      latOffset = (widget.farmLength / 2) * metersToLatLon;
      lngOffset = (widget.farmWidth / 2) * metersToLatLon;
    }

    final List<LatLng> polygonPoints = [
      LatLng(_currentLocation!.latitude + latOffset,
          _currentLocation!.longitude - lngOffset),
      LatLng(_currentLocation!.latitude + latOffset,
          _currentLocation!.longitude + lngOffset),
      LatLng(_currentLocation!.latitude - latOffset,
          _currentLocation!.longitude + lngOffset),
      LatLng(_currentLocation!.latitude - latOffset,
          _currentLocation!.longitude - lngOffset),
    ];

    final List<CircleMarker> heatmapCircles = [
      CircleMarker(
        point: LatLng(_currentLocation!.latitude + latOffset * 0.5,
            _currentLocation!.longitude - lngOffset * 0.5),
        radius: 15, useRadiusInMeter: true,
        color: AppTheme.affectedColor.withOpacity(0.3),
        borderColor: AppTheme.affectedColor.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
      CircleMarker(
        point: LatLng(_currentLocation!.latitude - latOffset * 0.3,
            _currentLocation!.longitude + lngOffset * 0.6),
        radius: 20, useRadiusInMeter: true,
        color: AppTheme.affectedColor.withOpacity(0.3),
        borderColor: AppTheme.affectedColor.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
      CircleMarker(
        point: LatLng(_currentLocation!.latitude,
            _currentLocation!.longitude + lngOffset * 0.2),
        radius: 12, useRadiusInMeter: true,
        color: AppTheme.affectedColor.withOpacity(0.3),
        borderColor: AppTheme.affectedColor.withOpacity(0.7),
        borderStrokeWidth: 2,
      ),
    ];

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation!,
          initialZoom: 17.0,
          maxZoom: 19.0,
          minZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.agrisense',
          ),
          PolygonLayer(
            polygons: [
              Polygon(
                points: polygonPoints,
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderColor: AppTheme.primaryColor,
                borderStrokeWidth: 3,
              ),
            ],
          ),
          CircleLayer(circles: heatmapCircles),
          MarkerLayer(
            markers: [
              Marker(
                point: _currentLocation!,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.my_location,
                  size: 30,
                  color: AppTheme.primaryColor,
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

  // **FIX:** This widget is now updated to correctly center the grid on first load.
  Widget _buildFarmGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double baseCropSize = 14.0;
        double contentWidth = widget.plantsPerRow * (baseCropSize + 4);
        double contentHeight = widget.rows * (baseCropSize + 4);

        // This block runs only once to set the initial centered position.
        if (!_isGridInitialized) {
          final double dx = (constraints.maxWidth - contentWidth) / 2;
          final double dy = (constraints.maxHeight - contentHeight) / 2;

          // Use a post-frame callback to safely update the controller after the build.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // Set the initial transformation to center the grid.
              final initialMatrix = Matrix4.identity()..translate(max(0, dx), max(0, dy));
              _transformationController.value = initialMatrix;
              setState(() {
                _isGridInitialized = true;
              });
            }
          });
        }

        double scaleX = constraints.maxWidth / contentWidth;
        double scaleY = constraints.maxHeight / contentHeight;
        double minScale = min(min(scaleX, scaleY), 1.0);

        return InteractiveViewer(
          transformationController: _transformationController,
          minScale: minScale > 0 ? minScale : 0.1, // Ensure minScale is positive
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
                  rowIndex: rowIndex,
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
            child: Text(crop.isHealthy
                ? localizations.markAffected
                : localizations.markHealthy),
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
        _LegendItem(
            color: AppTheme.healthyColor, label: localizations.healthyPlants),
        const SizedBox(width: 24),
        _LegendItem(
            color: AppTheme.affectedColor,
            label: localizations.affectedPlants),
      ],
    );
  }
}

class _FarmRow extends StatelessWidget {
  final List<Crop> crops;
  final int rowIndex;

  // **FIX:** Removed unused 'onCropTap' and simplified the constructor.
  const _FarmRow({required this.crops, required this.rowIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: crops.asMap().entries.map((entry) {
          int colIndex = entry.key;
          Crop crop = entry.value;
          return GestureDetector(
            onTap: () {
              // This navigation logic is now the primary action.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlantScanScreen(row: rowIndex + 1, col: colIndex + 1),
                ),
              );
            },
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

