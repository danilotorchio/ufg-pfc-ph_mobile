import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final String? initialValue;
  final bool enabled;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  final List<TextInputFormatter>? inputFormatters;

  const AppInput({
    super.key,
    required this.label,
    required this.placeholder,
    this.initialValue,
    this.enabled = true,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4.0),
        TextFormField(
          initialValue: initialValue,
          enabled: enabled,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textCapitalization: textCapitalization,
          maxLength: maxLength,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            counterText: '',
            prefixIcon: prefixIcon,
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 36.0,
              minHeight: 36.0,
              maxWidth: 40.0,
              minWidth: 40.0,
            ),
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              maxHeight: 36.0,
              minHeight: 36.0,
              maxWidth: 40.0,
              minWidth: 40.0,
            ),
            contentPadding: const EdgeInsets.all(12.0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF707070).withOpacity(0.2),
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
              ),
            ),
          ),
          onChanged: onChanged,
          validator: validator,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }
}
