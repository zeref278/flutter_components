import 'package:flutter/material.dart';

/// Theme extension
class FCThemeExtension extends ThemeExtension<FCThemeExtension> {
  FCThemeExtension({
    this.primary,
  });

  final Color? primary;

  @override
  ThemeExtension<FCThemeExtension> copyWith() {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  ThemeExtension<FCThemeExtension> lerp(
      covariant ThemeExtension<FCThemeExtension>? other, double t) {
    // TODO: implement lerp
    throw UnimplementedError();
  }
}
