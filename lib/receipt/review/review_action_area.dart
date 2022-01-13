import 'package:bonbon_mobile/components/button.dart';
import 'package:flutter/material.dart';

class ReviewActionArea extends StatelessWidget {
  final void Function()? previewOnPress;
  final void Function()? saveOnPress;
  final String saveButtonText;

  const ReviewActionArea({
    Key? key,
    required this.previewOnPress,
    required this.saveOnPress,
    required this.saveButtonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ColorButton(onPressed: previewOnPress, label: const Text('Preview'), color: Colors.blueAccent,),
        ColorButton(onPressed: saveOnPress, label: Text(saveButtonText)),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
