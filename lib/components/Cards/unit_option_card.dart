import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UnitOptionCard extends StatelessWidget {
  final UnitOption unit;
  final IconData? actionButtonIcon;
  final void Function()? onPressed;

  const UnitOptionCard({
    Key? key,
    required this.unit,
    this.actionButtonIcon,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title:Text('Unit: ${unit.unit}'),
        subtitle: Text('Price: \$${unit.price.toStringAsFixed(2)}'),
        trailing: IconButton(
          icon: Icon(actionButtonIcon ?? FontAwesomeIcons.times, color: Colors.red,),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
