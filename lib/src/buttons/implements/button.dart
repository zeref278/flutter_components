import 'package:flutter/material.dart';
import 'package:flutter_components/src/spacing/spacing.dart';

class FCButton extends StatelessWidget {
  /// Private constructor
  const FCButton._({
    required this.text,
    required this.buttonSize,
    this.onPressed,
    this.prefix,
    this.suffix,
    this.borderColor,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  /// Button primary type
  const factory FCButton.primary({
    required String text,
    FCButtonSize buttonSize,
    VoidCallback? onPressed,
    Widget? prefix,
    Widget? suffix,
    Key? key,
  }) = _FCPrimaryButton;

  /// Button secondary type
  const factory FCButton.secondary({
    required String text,
    FCButtonSize buttonSize,
    VoidCallback? onPressed,
    Widget? prefix,
    Widget? suffix,
    Key? key,
  }) = _FCSecondaryButton;

  /// Button ghost type
  const factory FCButton.text({
    required String text,
    FCButtonSize buttonSize,
    VoidCallback? onPressed,
    Widget? prefix,
    Widget? suffix,
    Key? key,
  }) = _FCTextButton;

  /// Custom button
  const factory FCButton.custom({
    required String text,
    FCButtonSize buttonSize,
    VoidCallback? onPressed,
    Widget? prefix,
    Widget? suffix,
    Color? borderColor,
    Color? backgroundColor,
    Color? foregroundColor,
    Key? key,
  }) = _FCCustomButton;

  /// Text display
  final String text;

  /// Button pressed callback
  final VoidCallback? onPressed;

  final FCButtonSize buttonSize;

  /// Prefix of button
  final Widget? prefix;

  /// Suffix of button
  final Widget? suffix;

  /// Border color customization
  final Color? borderColor;

  /// Background color customization
  final Color? backgroundColor;

  /// Foreground color customization
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final bool hasPrefix = prefix != null;
    final bool hasSuffix = suffix != null;
    return ElevatedButton(
      onPressed: onPressed,
      style: style(context).copyWith(
        minimumSize: MaterialStateProperty.all(
          Size(0, buttonSize.height),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasPrefix) prefix!,
          if (hasPrefix) FCSpacing.horizontalSpacing8,
          Text(
            text,
          ),
          if (hasSuffix) FCSpacing.horizontalSpacing8,
          if (hasSuffix) suffix!,
        ],
      ),
    );
  }

  ButtonStyle style(BuildContext context) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: 16,
        ),
      ),
      elevation: MaterialStateProperty.all(0),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonSize.borderRadius),
        ),
      ),
      textStyle:
          MaterialStateProperty.all(Theme.of(context).textTheme.labelLarge),
    );
  }
}

class _FCPrimaryButton extends FCButton {
  const _FCPrimaryButton({
    required super.text,
    super.buttonSize = FCButtonSize.medium,
    super.onPressed,
    super.prefix,
    super.suffix,
    super.key,
  }) : super._();

  @override
  ButtonStyle style(BuildContext context) {
    final ButtonStyle superButtonStyle = super.style(context);
    return superButtonStyle.copyWith(
      backgroundColor: MaterialStatePropertyAll(
        Theme.of(context).primaryColor,
      ),
    );
  }
}

class _FCSecondaryButton extends FCButton {
  const _FCSecondaryButton({
    required super.text,
    super.buttonSize = FCButtonSize.medium,
    super.onPressed,
    super.prefix,
    super.suffix,
    super.key,
  }) : super._();

  @override
  ButtonStyle style(BuildContext context) {
    final ButtonStyle superButtonStyle = super.style(context);

    return superButtonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context).primaryColor,
      ),
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor.withOpacity(0.3);
          } else {
            return Colors.transparent;
          }
        },
      ),
      side: MaterialStatePropertyAll(
        BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class _FCTextButton extends FCButton {
  const _FCTextButton({
    required super.text,
    super.buttonSize = FCButtonSize.medium,
    super.onPressed,
    super.prefix,
    super.suffix,
    super.key,
  }) : super._();

  @override
  ButtonStyle style(BuildContext context) {
    final ButtonStyle superButtonStyle = super.style(context);

    return superButtonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.disabled)) {
            return Theme.of(context).disabledColor;
          } else if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor;
          }

          return Theme.of(context).primaryColor;
        },
      ),
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor.withOpacity(0.3);
          } else {
            return Colors.transparent;
          }
        },
      ),
    );
  }
}

class _FCCustomButton extends FCButton {
  const _FCCustomButton({
    required super.text,
    super.buttonSize = FCButtonSize.medium,
    super.onPressed,
    super.prefix,
    super.suffix,
    super.borderColor,
    super.backgroundColor,
    super.foregroundColor,
    super.key,
  }) : super._();

  @override
  ButtonStyle style(BuildContext context) {
    final ButtonStyle superButtonStyle = super.style(context);

    return superButtonStyle.copyWith(
      backgroundColor: const MaterialStatePropertyAll(
        Colors.transparent,
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context).primaryColor,
      ),
      overlayColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).primaryColor.withOpacity(0.3);
          } else {
            return Colors.transparent;
          }
        },
      ),
      side: MaterialStatePropertyAll(
        BorderSide(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

enum FCButtonSize {
  large,
  medium,
  small,
  compact,
}

extension FCButtonSizeExtension on FCButtonSize {
  double get borderRadius {
    switch (this) {
      case FCButtonSize.large:
        return 12;
      case FCButtonSize.medium:
        return 12;
      case FCButtonSize.small:
        return 8;
      case FCButtonSize.compact:
        return 8;
    }
  }

  double get height {
    switch (this) {
      case FCButtonSize.large:
        return 56;
      case FCButtonSize.medium:
        return 48;
      case FCButtonSize.small:
        return 40;
      case FCButtonSize.compact:
        return 35;
    }
  }
}
