import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backIcon;
  final bool actions;
  final IconData iconActions;
  final VoidCallback? onActionPressed;

  const AppTopBar({super.key, required this.title, this.backIcon = false, this.actions = false, this.iconActions = Icons.edit, this.onActionPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBarBackground,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: backIcon == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back_outlined, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
          )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      actions: actions ? [
        IconButton(
          icon: Icon(iconActions, color: Colors.white),
          onPressed: onActionPressed,
        )
      ] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}