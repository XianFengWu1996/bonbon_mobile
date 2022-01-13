import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final List<TextInputFormatter> inputFormatter;
  final EdgeInsets ? padding;
  final double? width;
  final double? height;

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
    this.inputFormatter = const [],
    this.padding,
    this.height,
    this.width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Container(
        height: height,
        width: width,
        margin: margin ?? const EdgeInsets.only(bottom: 20),
        child: TextFormField(
          keyboardType: keyboardType ?? TextInputType.text,
          autocorrect: false,
          obscureText: isPassword ?? false,
          textCapitalization: textCap ?? TextCapitalization.none,
          controller: controller,
          inputFormatters: inputFormatter,
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
      ),
    );
  }
}
