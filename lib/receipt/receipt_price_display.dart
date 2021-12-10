import 'package:flutter/material.dart';

class ReceiptPriceDisplay extends StatelessWidget {
  final String label;
  final String price;

  const ReceiptPriceDisplay({
    Key? key,
    required this.label,
    required this.price,
  }) : super(key: key);

  final TextStyle _priceTextStyle = const TextStyle(
      fontSize: 16, fontWeight:
      FontWeight.w500,
      letterSpacing: 1.0
  );
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(label, style: _priceTextStyle),
        Text(price, style: _priceTextStyle,),
      ],
    );
  }
}
