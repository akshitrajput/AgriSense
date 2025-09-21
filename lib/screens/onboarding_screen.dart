import 'package:agrisense/providers/farm_data_provider.dart';
import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';

class Language {
  final String code;
  final String name;
  Language(this.code, this.name);
  @override
  String toString() => name;
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _languageSearchController = TextEditingController();
  final TextEditingController _cropSearchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _breadthController = TextEditingController();
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _plantsPerRowController = TextEditingController();

  final List<Language> _languages = [
    Language('en', 'English'),
    Language('hi', 'हिन्दी (Hindi)'),
    Language('ta', 'தமிழ் (Tamil)'),
    Language('bn', 'বাংলা (Bengali)'),
    Language('te', 'తెలుగు (Telugu)'),
    Language('mr', 'मराठी (Marathi)'),
    Language('ur', 'اردو (Urdu)'),
    Language('gu', 'ગુજરાતી (Gujarati)'),
    Language('kn', 'ಕನ್ನಡ (Kannada)'),
    Language('or', 'ଓଡ଼ିଆ (Odia)'),
    Language('ml', 'മലയാളം (Malayalam)'),
    Language('pa', 'ਪੰਜਾਬੀ (Punjabi)'),
    Language('as', 'অসমীয়া (Assamese)'),
  ];
  Language? _selectedLanguage;
  
  // Store the language-independent key for the crop
  String? _selectedCropKey;
  final List<String> _cropKeys = ['wheat', 'maize', 'corn', 'tomato', 'potato'];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LanguageProvider>(context, listen: false);
    final currentLangCode = provider.appLocale.languageCode;
    _selectedLanguage = _languages.firstWhere(
      (lang) => lang.code == currentLangCode,
      orElse: () => _languages.first,
    );
  }

  @override
  void dispose() {
    _languageSearchController.dispose();
    _cropSearchController.dispose();
    _nameController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    super.dispose();
  }

  void _createFarmProfile() {
    if (_formKey.currentState!.validate()) {
      final farmDataProvider = Provider.of<FarmDataProvider>(context, listen: false);
      final farmData = {
        'name': _nameController.text,
        'cropTypeKey': _selectedCropKey, // Save the neutral key
        'farmLength': double.tryParse(_lengthController.text) ?? 0.0,
        'farmBreadth': double.tryParse(_breadthController.text) ?? 0.0,
        'rows': int.tryParse(_rowsController.text) ?? 0,
        'plantsPerRow': int.tryParse(_plantsPerRowController.text) ?? 0,
      };

      farmDataProvider.updateFarmData(farmData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        
        // Create a map of keys to translated names for the dropdown
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  const Text('AgriSense', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 24),
                  Text(localizations.onboardingTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 8),
                  Text(localizations.onboardingSubtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor)),
                  const SizedBox(height: 32),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.eco_outlined, color: AppTheme.primaryColor, size: 50),
                  ),
                  const SizedBox(height: 32),
                  _buildForm(localizations, translatedCrops),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _createFarmProfile,
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(localizations.createProfile),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(AppLocalizations localizations, Map<String, String> translatedCrops) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildLanguageDropdown(),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _nameController,
            hintText: localizations.yourName,
            icon: Icons.person_outline,
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          _buildCropDropdown(localizations, translatedCrops),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  controller: _lengthController,
                  hintText: localizations.length,
                  icon: Icons.straighten_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter length' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextFormField(
                  controller: _breadthController,
                  hintText: localizations.breadth,
                  icon: Icons.swap_horiz_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter breadth' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _rowsController,
            hintText: localizations.numberOfRows,
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Enter number of rows' : null,
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _plantsPerRowController,
            hintText: localizations.plantsPerRow,
            icon: Icons.grass_outlined,
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Enter plants per row' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.subTextColor),
      ),
    );
  }

  Widget _buildCropDropdown(AppLocalizations localizations, Map<String, String> translatedCrops) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(localizations.selectCropType, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
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
            // Compare search value against the display text (child widget)
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

  Widget _buildLanguageDropdown() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        isExpanded: true,
        items: _languages.map((Language item) => DropdownMenuItem<Language>(value: item, child: Text(item.name, style: const TextStyle(fontSize: 14)))).toList(),
        value: _selectedLanguage,
        onChanged: (Language? language) {
          if (language != null) {
            setState(() {
              _selectedLanguage = language;
              _selectedCropKey = null; // Clear selected crop when language changes
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