import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Function? onChanged;
  final TextStyle? style;

  const PasswordField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.onChanged,
    this.style,
  }) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
        ),
      ),
      obscureText: obscureText,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!();
        }
      },
    );
  }
}
