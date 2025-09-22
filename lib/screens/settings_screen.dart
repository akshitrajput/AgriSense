import 'package:agrisense/l10n/app_localizations.dart';
import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/info_profile_screen.dart';
import 'package:agrisense/services/local_storage_service.dart';
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
  late TextEditingController _nameController;
  late TextEditingController _lengthController;
  late TextEditingController _breadthController;
  late TextEditingController _rowsController;
  late TextEditingController _plantsPerRowController;
  final _languageSearchController = TextEditingController();
  final _cropSearchController = TextEditingController();

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
    final farmData = context.read<FarmDataProvider>().farmData;
    final langProvider = context.read<LanguageProvider>();
    _nameController = TextEditingController(text: farmData['name'] ?? '');
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
      'wheat': localizations.cropWheat, 'maize': localizations.cropMaize, 'corn': localizations.cropCorn,
      'tomato': localizations.cropTomato, 'potato': localizations.cropPotato,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    _languageSearchController.dispose();
    _cropSearchController.dispose();
    super.dispose();
  }

  void _saveFarmChanges() async {
    if (_formKey.currentState!.validate()) {
      final farmDataProvider = context.read<FarmDataProvider>();
      final localizations = AppLocalizations.of(context)!;
      final newFarmData = Map<String, dynamic>.from(farmDataProvider.farmData);

      newFarmData['name'] = _nameController.text;
      newFarmData['cropTypeKey'] = _selectedCropKey;
      newFarmData['farmLength'] = double.tryParse(_lengthController.text) ?? 0.0;
      newFarmData['farmBreadth'] = double.tryParse(_breadthController.text) ?? 0.0;
      newFarmData['rows'] = int.tryParse(_rowsController.text) ?? 0;
      newFarmData['plantsPerRow'] = int.tryParse(_plantsPerRowController.text) ?? 0;

      await farmDataProvider.updateFarmData(newFarmData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.detailsUpdatedMessage),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _logout() async {
    // Use the centralized service to clear all app data
    await LocalStorageService.clearAllData();

    // Also clear the data from the provider in memory
    context.read<FarmDataProvider>().clearData();

    if (!mounted) return;

    // Navigate to the very first screen for new users, clearing all other screens
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const InfoProfileScreen()),
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(localizations.farmDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _nameController, label: localizations.yourName),
            const SizedBox(height: 16),
            _buildCropDropdown(localizations),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildTextFormField(controller: _lengthController, label: localizations.length)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextFormField(controller: _breadthController, label: localizations.breadth)),
            ]),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildTextFormField(controller: _rowsController, label: localizations.numberOfRows)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextFormField(controller: _plantsPerRowController, label: localizations.plantsPerRow)),
            ]),
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
          ]),
        ),
      ),
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label}) {
    return TextFormField(
      controller: controller,
      keyboardType: label == AppLocalizations.of(context)!.yourName ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? 'This field cannot be empty' : null,
    );
  }

  Widget _buildCropDropdown(AppLocalizations localizations) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(localizations.selectCropType),
        items: _translatedCrops.entries.map((e) => DropdownMenuItem<String>(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 14)))).toList(),
        value: _selectedCropKey,
        onChanged: (v) => setState(() => _selectedCropKey = v),
        buttonStyleData: ButtonStyleData(height: 55, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor))),
        dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
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
    final languageProvider = context.read<LanguageProvider>();
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        isExpanded: true,
        hint: Text(localizations.selectLanguage),
        items: _languages.map((l) => DropdownMenuItem<Language>(value: l, child: Text(l.name, style: const TextStyle(fontSize: 14)))).toList(),
        value: _selectedLanguage,
        onChanged: (l) {
          if (l != null) {
            setState(() {
              _selectedLanguage = l;
              _selectedCropKey = null;
            });
            languageProvider.changeLanguage(Locale(l.code));
          }
        },
        buttonStyleData: ButtonStyleData(height: 55, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.borderColor))),
        dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(borderRadius: BorderRadius.circular(12))),
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

class Language {
  final String code;
  final String name;
  Language(this.code, this.name);
  @override
  String toString() => name;
}

