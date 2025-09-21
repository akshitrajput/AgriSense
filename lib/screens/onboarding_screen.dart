// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:agrisense/screens/dashboard_screen.dart';
import 'package:agrisense/theme/app_theme.dart'; // FIXED: Added import for AppTheme

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCrop;
  final List<String> _cropTypes = ['Wheat', 'Maize', 'Corn', 'Tomato', 'Potato'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Make sure you have this logo in your assets folder
              // Image.asset('assets/images/agrisense_logo.png', height: 40),
              const Text("AgriSense", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
              const SizedBox(height: 24),
              const Text(
                "Cultivating Your Profile\nLet's begin your harvest.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tell us about your farm.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppTheme.subTextColor),
              ),
              const SizedBox(height: 32),
              // Make sure you have this illustration in your assets folder
              // Image.asset('assets/images/leaf_illustration.png', height: 100),
              const Icon(Icons.eco, size: 100, color: AppTheme.accentColor),
              const SizedBox(height: 32),
              _buildForm(),
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
                label: const Text('Create Farm Profile'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextFormField(
            hintText: 'Your Name',
            icon: Icons.person_outline,
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          _buildDropdown(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextFormField(
                  hintText: 'Length (m)',
                  icon: Icons.straighten_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter length' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextFormField(
                  hintText: 'Breadth (m)',
                  icon: Icons.swap_horiz_outlined,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Enter breadth' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            hintText: 'Number of Rows',
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

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCrop,
      isExpanded: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.eco_outlined, color: AppTheme.subTextColor),
      ),
      hint: const Text('Select Crop Type'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCrop = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a crop' : null,
      items: _cropTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}