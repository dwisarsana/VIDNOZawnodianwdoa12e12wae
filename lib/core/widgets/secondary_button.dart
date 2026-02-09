import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'glass_button.dart';

class SecondaryButton extends GlassButton {
  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.icon,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isPrimary: false,
      width: width,
      height: height,
      // Overriding style via GlassButton's implementation logic
      // In GlassButton, if isPrimary is false, it uses glassTintMed and border
      // This matches the "Secondary" requirement: less emphasized.
    );
  }
}
