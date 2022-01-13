import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final String textToConfirm;
  final void Function()? onPressed;
  const DeleteConfirmationDialog({
    Key? key,
    required this.textToConfirm,
    required this.onPressed
  }) : super(key: key);

  @override
  _DeleteConfirmationDialogState createState() => _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  final TextEditingController _deleteConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text('Confirm to Delete', style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AuthInput(
                    icon: FontAwesomeIcons.trash,
                    label: 'Type "${widget.textToConfirm}" to confirm',
                    controller: _deleteConfirm,
                    onChanged: (value){
                      setState(() {});
                    },
                ),
                ColorButton(
                  onPressed: _deleteConfirm.text == widget.textToConfirm ? widget.onPressed : null,
                  label: const Text('Delete', style: TextStyle(color: Colors.white),),
                  color: _deleteConfirm.text == widget.textToConfirm ? Colors.red : Colors.red[200]
                ),
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Text('Cancel')),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
