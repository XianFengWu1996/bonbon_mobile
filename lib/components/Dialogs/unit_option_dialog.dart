import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/model/error_model.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/sanitizers.dart';

class UnitOptionDialog extends StatefulWidget {
  final UnitOption? unitOption;
  final List<UnitOption>? unitOptionList;
  final Function? onPressed;

  const UnitOptionDialog({
    Key? key,
    this.unitOption,
    this.unitOptionList,
    this.onPressed,
  }) : super(key: key);

  @override
  _UnitOptionDialogState createState() => _UnitOptionDialogState();
}

class _UnitOptionDialogState extends State<UnitOptionDialog> {
  final TextEditingController _unit = TextEditingController();
  final TextEditingController _price = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(widget.unitOption != null){
      _unit.text = widget.unitOption!.unit;
      _price.text = widget.unitOption!.price.toString();
    }
  }

  void onPressed (MenuModel menuModel){
    try{
      if(_unit.text.isEmpty){
        throw CustomException(message: 'Unit can not be empty');
      }

      if(_price.text.isEmpty){
        throw CustomException(message: 'Price can not be empty');
      }

      if(widget.unitOption == null){
        for (var element in menuModel.addOption) {
          if(element.unit == _unit.text){
            throw CustomException(message: 'Unit Duplicated');
          }
        }

        for (var element in widget.unitOptionList!) {
          if(element.unit == _unit.text){
            throw CustomException(message: 'Unit Duplicated');
          }
        }
        // null unitOption = adding a new option
        menuModel.addToAddOption(UnitOption(
          id:const Uuid().v1(),
          unit: _unit.text,
          price: toDouble(_price.text),
        ));
      } else {
        // non null unitOption = updating an option
        menuModel.addToUpdateOption(UnitOption(
            id: widget.unitOption!.id,
            unit: _unit.text,
            price: toDouble(_price.text)
        ));
      }

      Navigator.pop(context);
    } on CustomException catch(e){
      showErrorToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    MenuModel menuModel = Provider.of<MenuModel>(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('UNITS', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 20,),
            AuthInput(icon: FontAwesomeIcons.sign, label: 'Unit', controller: _unit),
            AuthInput(icon: FontAwesomeIcons.dollarSign, label: 'Price', controller: _price),
            ColorButton(onPressed: (){
              if(widget.onPressed != null){
                widget.onPressed!(_unit.text, _price.text);
              } else {
                onPressed(menuModel);
              }
            }, label: Text(
                widget.unitOption == null ? 'ADD' : 'UPDATE'
            )),
          ],
        ),
      ),
    );
  }
}