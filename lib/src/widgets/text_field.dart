import 'package:flutter/material.dart';

class MayaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle? style;
  final IconData? leadingIcon;
  final bool obscureText;

  const MayaTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.style,
    this.leadingIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: style ?? Theme.of(context).textTheme.bodyMedium,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: leadingIcon != null ? Icon(leadingIcon) : null,
      ),
    );
  }
}
