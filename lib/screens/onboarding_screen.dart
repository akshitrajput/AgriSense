import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/services/local_storage_service.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final String farmerName;

  const OnboardingScreen({super.key, required this.farmerName});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cropSearchController = TextEditingController();
  final _lengthController = TextEditingController();
  final _breadthController = TextEditingController();
  final _rowsController = TextEditingController();
  final _plantsPerRowController = TextEditingController();

  String? _selectedCropKey;
  Future<void>? _savingFuture;

  void _createProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingFuture = _saveDataAndNavigate();
      });
    }
  }

  Future<void> _saveDataAndNavigate() async {
    final farmDataProvider = context.read<FarmDataProvider>();
    final farmData = {
      'name': widget.farmerName,
      'cropTypeKey': _selectedCropKey,
      'farmLength': double.tryParse(_lengthController.text) ?? 0.0,
      'farmBreadth': double.tryParse(_breadthController.text) ?? 0.0,
      'rows': int.tryParse(_rowsController.text) ?? 0,
      'plantsPerRow': int.tryParse(_plantsPerRowController.text) ?? 0,
    };

    await farmDataProvider.updateFarmData(farmData);
    await LocalStorageService.setOnboardingComplete(true);
  }

  @override
  void dispose() {
    _cropSearchController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If the saving process hasn't started, show the form.
    // Otherwise, show the loading screen with the FutureBuilder.
    return _savingFuture == null ? _buildFormScreen() : _buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    return FutureBuilder<void>(
      future: _savingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Saving Your Farm Profile...'),
                ],
              ),
            ),
          );
        }

        // After the future completes, navigate.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  (route) => false,
            );
          }
        });

        // Return an empty container while navigating.
        return Container();
      },
    );
  }

  Widget _buildFormScreen() {
    final localizations = AppLocalizations.of(context)!;
    final Map<String, String> translatedCrops = {
      'wheat': localizations.cropWheat,
      'maize': localizations.cropMaize,
      'corn': localizations.cropCorn,
      'tomato': localizations.cropTomato,
      'potato': localizations.cropPotato,
    };

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.agriculture_outlined, size: 60, color: AppTheme.primaryColor),
                const SizedBox(height: 16),
                Text(localizations.welcomeFarmer(widget.farmerName), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                const SizedBox(height: 8),
                Text(localizations.onboardingFarmDetails, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor)),
                const SizedBox(height: 32),
                _buildSectionTitle(localizations.farmDimensions),
                const SizedBox(height: 16),
                _buildDimensionFields(localizations),
                const SizedBox(height: 24),
                _buildSectionTitle(localizations.plantationDetails),
                const SizedBox(height: 16),
                _buildPlantationFields(localizations),
                const SizedBox(height: 16),
                _buildCropDropdown(localizations, translatedCrops),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _createProfile,
                  child: Text(localizations.createFarmProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- All other UI helper methods remain unchanged ---
  Widget _buildSectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.textColor));
  Widget _buildDimensionFields(AppLocalizations localizations) => Row(children: [
    Expanded(child: _buildTextFormField(controller: _lengthController, hintText: localizations.length, icon: Icons.straighten_outlined)),
    const SizedBox(width: 16),
    Expanded(child: _buildTextFormField(controller: _breadthController, hintText: localizations.breadth, icon: Icons.swap_horiz_outlined)),
  ]);
  Widget _buildPlantationFields(AppLocalizations localizations) => Row(children: [
    Expanded(child: _buildTextFormField(controller: _rowsController, hintText: localizations.numberOfRows, icon: Icons.format_list_numbered)),
    const SizedBox(width: 16),
    Expanded(child: _buildTextFormField(controller: _plantsPerRowController, hintText: localizations.plantsPerRow, icon: Icons.grass_outlined)),
  ]);
  Widget _buildTextFormField({required TextEditingController controller, required String hintText, required IconData icon}) => TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(hintText: hintText, prefixIcon: Icon(icon, color: AppTheme.subTextColor)),
    validator: (v) => v!.isEmpty ? 'This field is required' : null,
  );
  Widget _buildCropDropdown(AppLocalizations localizations, Map<String, String> translatedCrops) => DropdownButtonHideUnderline(
    child: DropdownButton2<String>(
      isExpanded: true,
      hint: Text(localizations.selectCropType, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
      items: translatedCrops.entries.map((e) => DropdownMenuItem<String>(value: e.key, child: Text(e.value))).toList(),
      value: _selectedCropKey,
      onChanged: (v) => setState(() => _selectedCropKey = v),
      buttonStyleData: ButtonStyleData(height: 55, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor))),
      dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
      menuItemStyleData: const MenuItemStyleData(height: 40),
      dropdownSearchData: DropdownSearchData(
        searchController: _cropSearchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
          child: TextFormField(
            expands: true,
            maxLines: null,
            controller: _cropSearchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              hintText: 'Search for a crop...',
              hintStyle: const TextStyle(fontSize: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        searchMatchFn: (item, searchValue) => (item.child as Text).data.toString().toLowerCase().contains(searchValue.toLowerCase()),
      ),
      onMenuStateChange: (isOpen) {
        if (!isOpen) _cropSearchController.clear();
      },
    ),
  );
}