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

  // --- Controllers for all form fields ---
  final TextEditingController _languageSearchController = TextEditingController();
  final TextEditingController _cropSearchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _breadthController = TextEditingController();
  final TextEditingController _rowsController = TextEditingController();
  final TextEditingController _plantsPerRowController = TextEditingController(); // From Code 2

  // --- State for Dropdowns ---
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
  String? _selectedCrop;

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
    // Dispose all controllers
    _languageSearchController.dispose();
    _cropSearchController.dispose();
    _nameController.dispose();
    _lengthController.dispose();
    _breadthController.dispose();
    _rowsController.dispose();
    _plantsPerRowController.dispose();
    super.dispose();
  }
  
  // --- Dataflow logic from Code 2 ---
  void _createFarmProfile() {
    if (_formKey.currentState!.validate()) {
      final farmData = {
        'name': _nameController.text,
        'cropType': _selectedCrop,
        'farmLength': double.tryParse(_lengthController.text) ?? 0.0,
        'farmBreadth': double.tryParse(_breadthController.text) ?? 0.0,
        'rows': int.tryParse(_rowsController.text) ?? 0,
        'plantsPerRow': int.tryParse(_plantsPerRowController.text) ?? 0,
        'selectedLanguage': _selectedLanguage?.name,
      };

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // Pass the collected data to the Dashboard
          builder: (context) => DashboardScreen(farmData: farmData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context)!;
        final List<String> translatedCrops = [
          localizations.cropWheat,
          localizations.cropMaize,
          localizations.cropCorn,
          localizations.cropTomato,
          localizations.cropPotato,
        ];

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // --- UI from Code 1 ---
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
                    onPressed: _createFarmProfile, // Use dataflow logic from Code 2
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(localizations.createProfile), // Use text from Code 1
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

  Widget _buildForm(AppLocalizations localizations, List<String> translatedCrops) {
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
          // --- "Plants per Row" field from Code 2 ---
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

  // --- Searchable Crop Dropdown from Code 1 ---
  Widget _buildCropDropdown(AppLocalizations localizations, List<String> cropList) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(localizations.selectCropType, style: TextStyle(fontSize: 14, color: Theme.of(context).hintColor)),
        items: cropList.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item, style: const TextStyle(fontSize: 14)))).toList(),
        value: _selectedCrop,
        onChanged: (String? value) => setState(() => _selectedCrop = value),
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
          searchMatchFn: (item, searchValue) => item.value.toString().toLowerCase().contains(searchValue.toLowerCase()),
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) _cropSearchController.clear();
        },
      ),
    );
  }

  // --- Searchable Language Dropdown from Code 1 ---
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
              _selectedCrop = null;
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