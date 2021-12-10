import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isPassword;
  final TextCapitalization? textCap;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  final EdgeInsets? margin;

  const AuthInput({
    Key? key,
    required this.icon,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.isPassword,
    this.textCap,
    this.validator,
    this.suffixIcon,
    this.onChanged,
    this.margin,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        keyboardType: keyboardType ?? TextInputType.text,
        autocorrect: false,
        obscureText: isPassword ?? false,
        textCapitalization: textCap ?? TextCapitalization.none,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 18,),
          suffixIcon: suffixIcon,
          label: Text(label),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}
