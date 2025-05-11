import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../config/theme/theme.dart';
import '../../../../core/constants/colors.dart';

class SocialIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;

  const SocialIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (Theme.of(context).brightness == Brightness.dark
                ? AppColors.dark
                : const Color(0xFFF3F3F3)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: FaIcon(
          icon,
          size: 24,
          color: iconColor ?? AppTheme.surface(context),
        ),
      ),
    );
  }
}
