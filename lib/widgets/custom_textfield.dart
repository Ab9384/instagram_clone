import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? autocorrect;
  final bool? autofocus;
  final bool? readOnly;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final String? initialValue;
  final EdgeInsetsGeometry? contentPadding;
  final bool? showCursor;
  final bool? enableSuggestions;
  final bool? autocorrectText;
  final bool? enableInteractiveSelection;
  final bool? filled;
  final Color? fillColor;

  const CustomTextField(
      {super.key,
      this.hintText,
      required this.controller,
      this.keyboardType,
      this.obscureText,
      this.autocorrect,
      this.autofocus,
      this.readOnly,
      this.enabled,
      this.maxLines,
      this.minLines,
      this.maxLength,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.textInputAction,
      this.focusNode,
      this.prefix,
      this.suffix,
      this.validator,
      this.initialValue,
      this.contentPadding,
      this.showCursor,
      this.enableSuggestions,
      this.autocorrectText,
      this.enableInteractiveSelection,
      this.filled,
      this.fillColor});

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      padding: const EdgeInsets.all(15.0),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      autocorrect: autocorrect ?? false,
      autofocus: autofocus ?? false,
      readOnly: readOnly ?? false,
      enabled: enabled ?? true,
      maxLength: maxLength,
      onChanged: onChanged,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
      onSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      focusNode: focusNode,
      prefix: prefix,
      suffix: suffix,
      placeholder: hintText,
      placeholderStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontSize: 14,
      ),
      decoration: BoxDecoration(
        color: fillColor ?? Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400, width: 1.2),
      ),
    );
  }
}
