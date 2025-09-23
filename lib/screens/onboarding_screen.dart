import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
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
  final TextEditingController _cropSearchController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _breadthController = TextEditingController();
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _plantsPerRowController = TextEditingController();

  String? _selectedCropKey;

  @override
  void dispose() {
    _cropSearchController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    super.dispose();
  }

  Future<void> _createFarmProfile() async {
    if (_formKey.currentState!.validate()) {
      final farmDataProvider = Provider.of<FarmDataProvider>(
        context,
        listen: false,
      );

      final Map<String, dynamic> farmData = {
        'name': widget.farmerName,
        'cropTypeKey': _selectedCropKey,
        'farmLength': double.tryParse(_lengthController.text) ?? 0.0,
        'farmBreadth': double.tryParse(_breadthController.text) ?? 0.0,
        'rows': int.tryParse(_rowsController.text) ?? 0,
        'plantsPerRow': int.tryParse(_plantsPerRowController.text) ?? 0,
      };

      await farmDataProvider.updateFarmData(farmData);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.agriculture_outlined,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.welcomeFarmer(widget.farmerName),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.onboardingFarmDetails,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.subTextColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // CHANGE: The form fields are now grouped inside a Card for a consistent UI
                  Card(
                    elevation: 2,
                    shadowColor: AppTheme.primaryColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppTheme.borderColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildDimensionFields(localizations),
                            const SizedBox(height: 16),
                            _buildPlantationFields(localizations),
                            const SizedBox(height: 16),
                            _buildCropDropdown(localizations, translatedCrops),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _createFarmProfile,
                    child: Text(localizations.createFarmProfile),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionFields(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField(
            controller: _lengthController,
            hintText: localizations.length,
            icon: Icons.straighten_outlined,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextFormField(
            controller: _breadthController,
            hintText: localizations.breadth,
            icon: Icons.swap_horiz_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildPlantationFields(AppLocalizations localizations) {
    return Row(
      children: [
        Expanded(
          child: _buildTextFormField(
            controller: _rowsController,
            hintText: localizations.numberOfRows,
            icon: Icons.format_list_numbered,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTextFormField(
            controller: _plantsPerRowController,
            hintText: localizations.plantsPerRow,
            icon: Icons.grass_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.subTextColor),
      ),
      validator: (value) =>
          value!.trim().isEmpty ? 'This field is required' : null,
    );
  }

  Widget _buildCropDropdown(
    AppLocalizations localizations,
    Map<String, String> translatedCrops,
  ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          localizations.selectCropType,
          style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor),
        ),
        items: translatedCrops.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        value: _selectedCropKey,
        onChanged: (String? value) {
          setState(() {
            _selectedCropKey = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        ),
        menuItemStyleData: const MenuItemStyleData(height: 40),
        dropdownSearchData: DropdownSearchData(
          searchController: _cropSearchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 4,
              right: 8,
              left: 8,
            ),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: _cropSearchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                hintText: 'Search for a crop...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            final textChild = item.child as Text;
            return textChild.data.toString().toLowerCase().contains(
              searchValue.toLowerCase(),
            );
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) _cropSearchController.clear();
        },
      ),
    );
  }
}
