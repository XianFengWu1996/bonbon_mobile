
import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  final void Function()? onPressed;
  final Widget label;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final EdgeInsetsGeometry? padding;


  const ColorButton({
    Key? key,
    required this.onPressed,
    required this.label,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: label,
      style: ButtonStyle(
          textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(
                fontWeight: fontWeight ??  FontWeight.w600,
                fontSize: fontSize ?? 17,
              )
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 50)),
          backgroundColor: MaterialStateProperty.all<Color>(color ?? Colors.black)
    ),);
  }
}
