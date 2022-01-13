import 'package:flutter/material.dart';

class ReceiptInput extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final String label;

  const ReceiptInput({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.label = '数量',
  }) : super(key: key);

  final OutlineInputBorder _border = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1,
    ),
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .2,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          isDense: true,
          label: Text(label),
          enabledBorder: _border,
          focusedBorder: _border
          ),
        ),
    );
  }
}
