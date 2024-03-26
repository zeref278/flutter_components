import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_components/src/spacing/spacing.dart';

class FCTextField extends StatefulWidget {
  const FCTextField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.fieldSize = FCFieldSize.medium,
    this.state,
    this.onSubmitted,
    this.label,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines,
    this.minLines,
    this.textAlign,
    this.prefix,
    this.suffix,
    this.disable = false,
    this.readOnly = false,
    this.onTap,
    this.onTapOutside,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.textInputAction,
    this.validator,
    this.errorMessage,
    this.warningMessage,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final FCFieldState? state;
  final FCFieldSize fieldSize;
  final ValueChanged<String>? onSubmitted;
  final String? label;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final bool disable;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;
  final bool obscureText;
  final String obscuringCharacter;
  final TextInputAction? textInputAction;
  final FutureOr<FCFieldState> Function(String)? validator;
  final String? errorMessage;
  final String? warningMessage;

  @override
  State<FCTextField> createState() => _FCTextFieldState();
}

class _FCTextFieldState extends State<FCTextField> {
  Color? _borderColor;
  bool _isHasListener = false;
  late ThemeData _theme;
  late FCFieldState _state;

  void _setFocusListener() {
    if (!_isHasListener) {
      _isHasListener = true;
      widget.focusNode.addListener(_setBorderColor);
    }
  }

  void _setBorderColor() {
    final hasFocused =
        widget.focusNode.hasFocus || widget.focusNode.hasPrimaryFocus;
    if (hasFocused && _state == FCFieldState.none) {
      setState(() {
        _borderColor = _theme.primaryColor;
      });
    } else {
      setState(() {
        _borderColor = _state.color(_theme);
      });
    }
  }

  @override
  void initState() {
    _state = widget.state ?? FCFieldState.none;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _theme = Theme.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_setBorderColor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isHasListener) {
      _borderColor = _state.color(_theme);
    }
    _setFocusListener();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        _buildField(context),
        if (_state != FCFieldState.none)
          FCValidatorMessage(
            state: _state,
            errorMsg: widget.errorMessage,
            warningMsg: widget.warningMessage,
          ),
      ],
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _borderColor ?? Color(0xFF004269).withOpacity(0.28),
        ),
      );

  @override
  void didUpdateWidget(covariant FCTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state != oldWidget.state) {
      setState(() {
        _state = widget.state ?? FCFieldState.none;
        _setBorderColor();
      });
    }
  }

  Widget _buildField(BuildContext context) {
    final border = _border;
    return TextFormField(
      key: widget.key,
      enabled: !widget.disable,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onChanged: (value) async {
        widget.onChanged.call(value);

        if (widget.validator != null) {
          final newStatus = await widget.validator!(value);
          if (newStatus != _state) {
            setState(() {
              _state = newStatus;
              _setBorderColor();
            });
          }
        }
      },
      onFieldSubmitted: widget.onSubmitted,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textAlign: widget.textAlign ?? TextAlign.start,
      style: _theme.textTheme.bodyMedium?.copyWith(),
      cursorWidth: 1,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: border,
        focusedBorder: border,
        focusedErrorBorder: border,
        border: border,
        disabledBorder: border.copyWith(
          borderSide: border.borderSide.copyWith(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: widget.disable
            ? const Color(0xFF004269).withOpacity(0.07)
            : Colors.transparent,
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: widget.fieldSize.verticalPadding,
        ),
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
        counterText: '',
        counterStyle: const TextStyle(height: 0),
      ),
      onTap: widget.onTap,
      onTapOutside: (_) {
        (widget.onTapOutside ??
                () {
                  FocusScope.of(context).unfocus();
                })
            .call();
      },
    );
  }
}

enum FCFieldState {
  error,
  warning,
  none,
}

extension FCFieldStateExtension on FCFieldState {
  Color? color(ThemeData theme) {
    switch (this) {
      case FCFieldState.error:
        return theme.colorScheme.error;
      case FCFieldState.warning:
        return Colors.amber;
      case FCFieldState.none:
        return Color(0xFF004269).withOpacity(0.28);
    }
  }
}

enum FCFieldSize {
  medium,
  small,
  extraSmall,
}

extension FCFieldSizeExtension on FCFieldSize {
  double get verticalPadding {
    switch (this) {
      case FCFieldSize.medium:
        return 16;
      case FCFieldSize.small:
        return 12;
      case FCFieldSize.extraSmall:
        return 4;
    }
  }
}

class FCValidatorMessage extends StatelessWidget {
  const FCValidatorMessage({
    required this.state,
    this.successMsg,
    this.errorMsg,
    this.warningMsg,
    this.padding,
    super.key,
  });

  final FCFieldState state;

  /// Message displayed when validator return success
  final String? successMsg;

  /// Error displayed when validator return error
  final String? errorMsg;

  /// Message displayed when validator return warning
  final String? warningMsg;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final Widget msg;

    switch (state) {
      case FCFieldState.error:
        msg = Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.error,
                  size: 18,
                ),
              ),
              const WidgetSpan(child: FCSpacing.horizontalSpacing6),
              TextSpan(
                text: errorMsg ?? 'Error value',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        );
        break;
      case FCFieldState.warning:
        msg = Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.amber,
                  size: 18,
                ),
              ),
              const WidgetSpan(child: FCSpacing.horizontalSpacing6),
              TextSpan(
                text: warningMsg ?? 'Warning value',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.amber,
                ),
              ),
            ],
          ),
        );
        break;
      default:
        msg = const SizedBox();
    }

    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 4),
      child: msg,
    );
  }
}
