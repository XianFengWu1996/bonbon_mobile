import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ReceiptDropdown extends StatelessWidget {
  final double width;
  final String? value;
  final List<String>? dropdownList;
  final void Function(String?)? onChanged;

  const ReceiptDropdown({
    Key? key,
    this.width = 100,
    this.value,
    required this.dropdownList,
    required this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
            color: Colors.red, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButton<String>(
        icon: const Icon(FontAwesomeIcons.caretDown),
        iconSize: 24,
        elevation: 16,
        isExpanded: true,
        underline: Container(),
        value: value,
        onChanged: onChanged,
        items: dropdownList!.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toSet().toList(),
      ),
    );
  }
}
