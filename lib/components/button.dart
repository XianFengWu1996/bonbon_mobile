
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

class ColorButtonWithLoading extends StatelessWidget {
  final void Function(Function, Function, ButtonState) onPressed;
  final String label;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final EdgeInsetsGeometry? padding;


  const ColorButtonWithLoading({
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
    return ArgonButton(
      onTap: (start, end, state){
        onPressed(start, end, state);
      },
      child: const Text('Login', style: TextStyle(
        color: Colors.white
      )),
      height: 50,
      width: 150,
      borderRadius: 5,
      color: color ?? Colors.black,
      loader: Container(
        padding: const EdgeInsets.all(10),
        child: const SpinKitRing(
          color: Colors.white,
          // size: loaderWidth ,
        ),
      ),
    );
  }
}

