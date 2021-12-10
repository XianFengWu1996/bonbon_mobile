import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReceiptCustomerDialog extends StatefulWidget {

  const ReceiptCustomerDialog({
      Key? key,
  }) : super(key: key);

  @override
  _ReceiptCustomerDialogState createState() => _ReceiptCustomerDialogState();
}

class _ReceiptCustomerDialogState extends State<ReceiptCustomerDialog> {
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  String _selectedTime = '';
  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Text('客户信息', style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                  ),),
                ),
                AuthInput(
                    icon: FontAwesomeIcons.user,
                    label: 'Name',
                    controller:_name
                ),
                AuthInput(
                    icon: FontAwesomeIcons.phone,
                    label: 'Phone',
                    controller: _phone
                ),
                DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  dateMask: 'd MMM, yyyy',
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  icon: const Icon(Icons.event),
                  timePickerEntryModeInput: true,
                  dateLabelText: 'Date',
                  timeLabelText: 'Time',
                  onChanged: (val) {
                    setState(() {
                      _selectedTime = val;
                    });
                  }
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ColorButton(onPressed: (){
                    receiptModel.saveCustomerInfo(
                        name: _name.text,
                        phone: _phone.text,
                        pickupDate: _selectedTime,
                    );
                    Navigator.pop(context);
                  }, label: const Text('Save')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
