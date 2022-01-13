
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateUnitCard extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? toUndo;
  final void Function()? toRemove;
  final bool toBeUpdate;
  final UnitOption unit;
  final UnitOption updateUnit;


  const UpdateUnitCard({
    Key? key,
    required this.onTap,
    required this.toUndo,
    required this.toRemove,
    this.toBeUpdate = false,
    required this.unit,
    required this.updateUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title:Text.rich(TextSpan(
            children: [
              const TextSpan(text: 'Unit:  '),
              TextSpan(text: unit.unit, style: TextStyle(
                  decoration: toBeUpdate ? TextDecoration.lineThrough : TextDecoration.none
              )),
              updateUnit.unit.isEmpty ? const TextSpan() : TextSpan(text: '  ${updateUnit.unit}'),
            ]
        )),
        subtitle: Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Price: '),
                TextSpan(text:  '\$${unit.price}', style: TextStyle(
                    decoration: toBeUpdate ? TextDecoration.lineThrough : TextDecoration.none
                )),
                updateUnit.price == 0 ? const TextSpan() : TextSpan(text: '  \$${updateUnit.price}'),
              ]
        )),
        trailing: toBeUpdate
            ? TextButton(onPressed: toUndo, child: const Text('Undo'))
            : IconButton(
              icon: const Icon(FontAwesomeIcons.trash, color: Colors.red,),
              onPressed: toRemove,
            ),
      ),
    );
  }
}
