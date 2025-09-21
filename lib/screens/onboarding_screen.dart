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
  final TextEditingController _cropSearchController = TextEditingController(); // Controller for crop search

  final List<Language> _languages = [
    Language('en', 'English'),
    Language('hi', 'हिन्दी (Hindi)'),
    Language('ta', 'தமிழ் (Tamil)'), // Added Tamil
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
  // Removed the hardcoded crop list

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
    _cropSearchController.dispose(); // Dispose the new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final localizations = AppLocalizations.of(context)!;

        // Dynamically create the list of translated crops
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
                  const Text(
                    'AgriSense',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations.onboardingTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.onboardingSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco_outlined,
                      color: AppTheme.primaryColor,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildForm(localizations, translatedCrops),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const DashboardScreen()),
                        );
                      }
                    },
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

  Widget _buildForm(AppLocalizations localizations, List<String> translatedCrops) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildLanguageDropdown(),
          const SizedBox(height: 16),
          _buildTextFormField(
            hintText: localizations.yourName,
            icon: Icons.person_outline,
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          _buildCropDropdown(localizations, translatedCrops), // Pass the translated list
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  hintText: localizations.length,
                  icon: Icons.straighten_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter length' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextFormField(
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
            hintText: localizations.numberOfRows,
            icon: Icons.format_list_numbered,
            keyboardType: TextInputType.number,
            validator: (value) => value!.isEmpty ? 'Enter number of rows' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.subTextColor),
      ),
    );
  }

  Widget _buildCropDropdown(AppLocalizations localizations, List<String> cropList) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          localizations.selectCropType,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: cropList.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        value: _selectedCrop,
        onChanged: (String? value) {
          setState(() {
            _selectedCrop = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _cropSearchController.clear();
          }
        },
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    return DropdownButtonHideUnderline(
      child: DropdownButton2<Language>(
        isExpanded: true,
        items: _languages.map((Language item) {
          return DropdownMenuItem<Language>(
            value: item,
            child: Text(
              item.name,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        value: _selectedLanguage,
        onChanged: (Language? language) {
          if (language != null) {
            setState(() {
              _selectedLanguage = language;
              // Clear selected crop when language changes, as the list items will change
              _selectedCrop = null;
            });
            languageProvider.changeLanguage(Locale(language.code));
          }
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderColor),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        onMenuStateChange: (isOpen) {
          if (!isOpen) {
            _languageSearchController.clear();
          }
        },
      ),
    );
  }
}