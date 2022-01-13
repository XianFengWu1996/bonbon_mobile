import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:bonbon_mobile/components/Dialogs/unit_option_dialog.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/components/toast.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:validators/sanitizers.dart';

class AddOptionCard extends StatefulWidget {
  final Function onSave;
  const AddOptionCard({Key? key, required this.onSave }) : super(key: key);

  @override
  _AddOptionCardState createState() => _AddOptionCardState();
}

class _AddOptionCardState extends State<AddOptionCard> {
  final TextEditingController _flavor = TextEditingController();
  final List<UnitOption> _unitOptionList = [];
  @override
  Widget build(BuildContext context) {
    void onDelete(String id){
      setState(() {
        _unitOptionList.removeWhere((element) => element.id == id);
      });
    }

    void onPressed (unit, price) {
      for (var element in _unitOptionList) {
        if(element.unit == unit){
          showErrorToast('Duplicate unit not allow');
          return;
        }
      }

      setState(() {
        _unitOptionList.add(UnitOption(
          id: const Uuid().v1(),
          unit: unit,
          price: toDouble(price),
        ));
      });

      Navigator.pop(context);
    }

    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Card(
        child: Column(
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text('Add New Option', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
            ),
            // Input for Option Name
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: AuthInput(icon: FontAwesomeIcons.pencilAlt, label: 'Flavor', controller: _flavor),
            ),
            // Unit option list
            ListView.builder(
                shrinkWrap: true,
                itemCount: _unitOptionList.length,
                itemBuilder: (context, index){
                  UnitOption unit = _unitOptionList[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Card(
                      color: Colors.white60,
                      child: ListTile(
                        title: Text('Unit: ${unit.unit}'),
                        subtitle: Text('Price: ${unit.price.toStringAsFixed(2)}'),
                        trailing: IconButton(onPressed: (){
                          onDelete(unit.id);
                        }, icon: const Icon(FontAwesomeIcons.times)),
                      ),
                    ),
                  );
                }),
            // Add Unit Button
            OutlinedButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return UnitOptionDialog(
                    onPressed: onPressed,
                  );
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
              ),
              child: const Text("ADD UNIT", style: TextStyle(color: Colors.blue, fontSize: 18),),
            ),
            // Save Button
            Padding(
              padding: const EdgeInsets.only(bottom: 25, top: 10),
              child: ArgonButton(
                  height: 50,
                  width: 200,
                  borderRadius: 10,
                  color: Colors.black,
                  child: const Text('Save', style: TextStyle(color: Colors.white),),
                  onTap: (startLoading, stopLoading, btnState){
                    widget.onSave(startLoading, stopLoading, btnState, _flavor.text, _unitOptionList);
                  },
                  loader: Container(
                    padding: const EdgeInsets.all(10),
                    child: const SpinKitRing(
                      color: Colors.white,
                      // size: loaderWidth ,
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
