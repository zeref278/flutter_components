import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    this.obscuringCharacter = '●',
    this.textInputAction,
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
    _setFocusListener();

    final OutlineInputBorder outlineBorder = _border;

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

        // if (widget.validator != null) {
        //   final newStatus = await widget.validator!(value);
        //   if (newStatus != _status) {
        //     setState(() {
        //       _status = newStatus;
        //       _setBorderColor();
        //     });
        //   }
        // }
      },
      onFieldSubmitted: widget.onSubmitted,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      textAlign: widget.textAlign ?? TextAlign.start,
      style: _theme.textTheme.bodyLarge?.copyWith(
          // color: widget.disable
          //     ? tdsColor!.neutral1300
          //     : tdsColor!.neutral1900,
          ),
      cursorWidth: 1,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        label: widget.label != null ? Text(widget.label!) : null,
        isDense: true,
        enabledBorder: outlineBorder,
        focusedBorder: outlineBorder,
        focusedErrorBorder: outlineBorder,
        border: outlineBorder,
        disabledBorder: outlineBorder.copyWith(
          borderSide: outlineBorder.borderSide.copyWith(
            color: Colors.transparent,
          ),
        ),
        filled: true,
        fillColor: widget.disable ? Color(0xFF004269).withOpacity(0.07) : Colors.transparent,
        hintText: widget.hint,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: widget.fieldSize.verticalPadding,
        ),
        prefixIcon: widget.prefix,
        suffixIcon: widget.suffix,
      ),
      onTap: widget.onTap,
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: _borderColor ?? Colors.green,
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
}

enum FCFieldState {
  error,
  warning,
  success,
  none,
}

extension FCFieldStateExtension on FCFieldState {
  Color? color(ThemeData theme) {
    switch (this) {
      case FCFieldState.error:
        return theme.colorScheme.error;
      case FCFieldState.warning:
        return theme.colorScheme.tertiary;
      case FCFieldState.success:
        return Colors.green;
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
