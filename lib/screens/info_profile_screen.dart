import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
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

class InfoProfileScreen extends StatefulWidget {
  const InfoProfileScreen({super.key});
  @override
  State<InfoProfileScreen> createState() => _InfoProfileScreenState();
}

class _InfoProfileScreenState extends State<InfoProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _languageSearchController = TextEditingController();

  // CHANGE: Updated the list to include all languages
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
    _nameController.dispose();
    _languageSearchController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(farmerName: _nameController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.waving_hand_outlined, size: 60, color: AppTheme.primaryColor),
                  const SizedBox(height: 24),
                  Text(
                    localizations.welcomeToAgriSense,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations.letsGetYouStarted,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: AppTheme.subTextColor),
                  ),
                  const SizedBox(height: 32),
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
                            Text(localizations.yourName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            _buildTextFormField(localizations),
                            const SizedBox(height: 24),
                            Text(localizations.selectYourLanguage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            _buildLanguageDropdown(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitProfile,
                    child: Text(localizations.continueButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(AppLocalizations localizations) {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        hintText: localizations.yourName,
        prefixIcon: const Icon(Icons.person_outline, color: AppTheme.subTextColor),
      ),
      validator: (value) => value!.trim().isEmpty ? 'Please enter your name' : null,
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
            });
            languageProvider.changeLanguage(Locale(language.code));
          }
        },
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
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