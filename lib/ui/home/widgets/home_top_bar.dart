import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/avatar.dart';
import 'package:after_project/ui/core/ui/gradient_text.dart';
import 'package:after_project/utils/greeting.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String nomeUsuario;
  final String? fotoPerfilUrl;
  final VoidCallback onAvatarTap;

  static const double _contentHeight = 56;
  static const double _verticalPadding = 10;
  static const double _horizontalPadding = 30;

  const HomeTopBar({super.key, required this.nomeUsuario, required this.fotoPerfilUrl, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top + _verticalPadding;

    return Container(
      padding: EdgeInsets.fromLTRB(_horizontalPadding, statusBarHeight, _horizontalPadding, _verticalPadding),
      height: kToolbarHeight + statusBarHeight + _contentHeight,
      color: AppColors.appBarBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                greetingForHour(DateTime.now().hour),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              GradientText(
                text: nomeUsuario,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.white,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.usernameGradA, AppColors.usernameGradB],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: AppAvatar(
                  imageUrl: fotoPerfilUrl,
                  letter: nomeUsuario.isNotEmpty ? nomeUsuario[0].toUpperCase() : 'U',
                  size: 45,
                  fontSize: 20,
                  borderRadius: 5,
                  border: Border.all(
                      color: AppColors.fotoBorder,
                      width: 1,
                      strokeAlign: BorderSide.strokeAlignCenter
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    final statusBarHeight = ui.PlatformDispatcher.instance.views.first.padding.top /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;

    return Size.fromHeight(statusBarHeight + _contentHeight + _verticalPadding);
  }
}