import 'package:agrisense/providers/language_provider.dart';
import 'package:agrisense/screens/main_screen.dart';
import 'package:agrisense/screens/onboarding_screen.dart';
import 'package:agrisense/theme/app_theme.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _languageSearchController = TextEditingController();

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
  bool _isLoading = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _languageSearchController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      // First, try to sign in. If this works, the user already exists.
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } on FirebaseAuthException {
      // If sign-in fails, assume it's a new user.
      // Pass all details to the next screen to create the account there.
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(
              farmerName: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                            _buildTextFormField(
                              controller: _nameController,
                              hintText: localizations.yourName,
                              icon: Icons.person_outline,
                              validator: (value) => value!.trim().isEmpty ? 'Please enter your name' : null,
                            ),
                            const SizedBox(height: 16),
                            Text(localizations.email, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            _buildTextFormField(
                              controller: _emailController,
                              hintText: 'you@example.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Please enter your email';
                                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Please enter a valid email address';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(localizations.password, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            _buildTextFormField(
                              controller: _passwordController,
                              hintText: 'Enter your password',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Please enter a password';
                                if (value.length < 6) return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
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
                    onPressed: _isLoading ? null : _submitProfile,
                    child: _isLoading
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                        : Text(localizations.continueButton),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppTheme.subTextColor),
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