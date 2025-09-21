import 'package:agrisense/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;
  final Widget? leading; // CHANGE: Added a leading widget property
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.hasBackButton = false,
    this.leading, // CHANGE: Added to constructor
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.textColor,
          fontSize: 18,
        ),
      ),
      // CHANGE: Use the custom leading widget if provided, otherwise default to the back button logic
      leading: leading ?? (hasBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}