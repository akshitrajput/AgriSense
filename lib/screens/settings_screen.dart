import 'package:agrisense/l10n/app_localizations.dart';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:agrisense/widgets/custom_app_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _lengthController;
  late TextEditingController _breadthController;
  late TextEditingController _rowsController;
  late TextEditingController _plantsPerRowController;
  final TextEditingController _languageSearchController = TextEditingController();
  final TextEditingController _cropSearchController = TextEditingController();

  String? _selectedCropKey;
  Map<String, String> _translatedCrops = {};

  Language? _selectedLanguage;
  final List<Language> _languages = [
    Language('en', 'English'),
    Language('hi', 'हिन्दी (Hindi)'),
    Language('ta', 'தமிழ் (Tamil)'),
  ];

  @override
  void initState() {
    super.initState();
    final farmData = Provider.of<FarmDataProvider>(context, listen: false).farmData;
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    _lengthController = TextEditingController(text: farmData['farmLength']?.toString() ?? '');
    _breadthController = TextEditingController(text: farmData['farmBreadth']?.toString() ?? '');
    _rowsController = TextEditingController(text: farmData['rows']?.toString() ?? '');
    _plantsPerRowController = TextEditingController(text: farmData['plantsPerRow']?.toString() ?? '');
    _selectedCropKey = farmData['cropTypeKey'];
    
    _selectedLanguage = _languages.firstWhere((lang) => lang.code == langProvider.appLocale.languageCode, orElse: () => _languages.first);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context)!;
    
    _translatedCrops = {
      'wheat': localizations.cropWheat,
      'maize': localizations.cropMaize,
      'corn': localizations.cropCorn,
      'tomato': localizations.cropTomato,
      'potato': localizations.cropPotato,
    };
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    _languageSearchController.dispose();
    _cropSearchController.dispose();
    super.dispose();
  }

  void _saveFarmChanges() {
    if (_formKey.currentState!.validate()) {
      final farmDataProvider = Provider.of<FarmDataProvider>(context, listen: false);
      final localizations = AppLocalizations.of(context)!;
      final newFarmData = Map<String, dynamic>.from(farmDataProvider.farmData);

      newFarmData['cropTypeKey'] = _selectedCropKey;
      newFarmData['farmLength'] = double.tryParse(_lengthController.text) ?? 0.0;
      newFarmData['farmBreadth'] = double.tryParse(_breadthController.text) ?? 0.0;
      newFarmData['rows'] = int.tryParse(_rowsController.text) ?? 0;
      newFarmData['plantsPerRow'] = int.tryParse(_plantsPerRowController.text) ?? 0;

      farmDataProvider.updateFarmData(newFarmData);

      // --- CHANGE: Improved SnackBar implementation ---
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(child: Text(localizations.detailsUpdatedMessage)),
            ],
          ),
          backgroundColor: AppTheme.primaryColor, // Use primary color
          behavior: SnackBarBehavior.floating, // Make it float
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      Navigator.of(context).pop();
    }
  }
  
  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: localizations.settings, hasBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(localizations.farmDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildCropDropdown(localizations),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextFormField(controller: _lengthController, label: localizations.length)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField(controller: _breadthController, label: localizations.breadth)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildTextFormField(controller: _rowsController, label: localizations.numberOfRows)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextFormField(controller: _plantsPerRowController, label: localizations.plantsPerRow)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveFarmChanges, child: Text(localizations.saveFarmChanges)),
              const Divider(height: 48),

              Text(localizations.language, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildLanguageDropdown(localizations),
              const Divider(height: 48),

              OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: Text(localizations.logOut),
                style: OutlinedButton.styleFrom(foregroundColor: AppTheme.affectedColor, side: const BorderSide(color: AppTheme.affectedColor)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
    );
  }

  Widget _buildCropDropdown(AppLocalizations localizations) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(localizations.selectCropType, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        items: _translatedCrops.entries.map((entry) {
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
          height: 50,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor)),
        ),
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
          searchMatchFn: (item, searchValue) {
            final textChild = item.child as Text;
            return textChild.data.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) _cropSearchController.clear();
        },
      ),
    );
  }

  Widget _buildLanguageDropdown(AppLocalizations localizations) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        isExpanded: true,
        hint: Text(localizations.selectLanguage, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        items: _languages.map((Language item) => DropdownMenuItem<Language>(value: item, child: Text(item.name, style: const TextStyle(fontSize: 14)))).toList(),
        value: _selectedLanguage,
        onChanged: (Language? language) {
          if (language != null) {
            setState(() {
              _selectedLanguage = language;
            });
            languageProvider.changeLanguage(Locale(language.code));
          }
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor)),
        ),
        dropdownStyleData: DropdownStyleData(maxHeight: 200, decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
        menuItemStyleData: const MenuItemStyleData(height: 40),
        dropdownSearchData: DropdownSearchData(
          searchController: _languageSearchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            height: 50,
            padding: const EdgeInsets.only(top: 8, bottom: 4, right: 8, left: 8),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: _languageSearchController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                hintText: 'Search for a language...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) => item.value.toString().toLowerCase().contains(searchValue.toLowerCase()),
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) _languageSearchController.clear();
        },
      ),
    );
  }
}

// Re-using the Language class from onboarding
class Language {
  final String code;
  final String name;
  Language(this.code, this.name);
  @override
  String toString() => name;
}