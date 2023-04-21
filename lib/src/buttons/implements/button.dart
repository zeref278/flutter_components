import 'package:flutter/material.dart';

class TNDButton extends StatelessWidget {
  const TNDButton({
    required this.text,
    required this.onPressed,
    required this.type,
    this.disable,
    super.key,
  });

  const factory TNDButton.primary({
    required String text,
    required VoidCallback onPressed,
    bool? disable,
    Key? key,
  }) = _TNDPrimaryButton;

  const factory TNDButton.secondary({
    required String text,
    required VoidCallback onPressed,
    bool? disable,
    Key? key,
  }) = _TNDSecondaryButton;

  final String text;
  final VoidCallback? onPressed;
  final bool? disable;
  final TNDButtonType type;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style(context),
      child: Text(text),
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
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class _TNDPrimaryButton extends TNDButton {
  const _TNDPrimaryButton({
    required super.text,
    required super.onPressed,
    super.disable,
    super.key,
  }) : super(type: TNDButtonType.primary);

  @override
  ButtonStyle style(BuildContext context) {
    final ButtonStyle superButtonStyle = super.style(context);
    return superButtonStyle.copyWith(
      backgroundColor: MaterialStatePropertyAll(
        Theme.of(context).primaryColor,
      ),
      foregroundColor: MaterialStatePropertyAll(
        Theme.of(context).textTheme.bodyMedium?.color,
      ),
    );
  }
}

class _TNDSecondaryButton extends TNDButton {
  const _TNDSecondaryButton({
    required super.text,
    required super.onPressed,
    super.disable,
    super.key,
  }) : super(type: TNDButtonType.primary);

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

enum TNDButtonType {
  primary,
  secondary,
  ghost,
  clear,
}
