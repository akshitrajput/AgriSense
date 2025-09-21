import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomNavButtons extends StatelessWidget {
  const BottomNavButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Pop until we reach the dashboard
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.dashboard_outlined),
            label: const Text('Dashboard'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: const BorderSide(color: AppTheme.borderColor),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}