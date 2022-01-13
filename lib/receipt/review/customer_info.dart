import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:validators/sanitizers.dart';

class CustomerInfo extends StatefulWidget {
  final String name;
  final String phone;
  final String date;
  final String receiptName;

  const CustomerInfo({
    Key? key,
    required this.name, required this.phone, required this.date, required this.receiptName
  }) : super(key: key);

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _receiptName = TextEditingController();

  String _selectedTime = '';
  bool isDelivery = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _name.text = widget.name;
    _phone.text = widget.phone;
    _selectedTime = widget.date;
    _receiptName.text = widget.receiptName;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AuthInput(
              icon: FontAwesomeIcons.receipt,
              label: 'Receipt Name',
              controller: _receiptName,
              onChanged: (value){
                receiptModel.saveCustomerInfo(type: 'receipt_name', data: value);
              },
            ),

            const Text('客户信息', style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
            ),),
            const SizedBox(height: 10,),
            AuthInput(
              icon: FontAwesomeIcons.user,
              label: '姓名',
              controller:_name,
              onChanged: (v) {
                receiptModel.saveCustomerInfo(type: 'name', data: v);
              },
              margin: const EdgeInsets.only(bottom: 0),
            ),
            AuthInput(
              icon: FontAwesomeIcons.phone,
              label: '电话',
              controller: _phone,
              keyboardType: TextInputType.number,
              inputFormatter: [
                LengthLimitingTextInputFormatter(10)
              ],
              onChanged: (v) {
                receiptModel.saveCustomerInfo(type: 'phone', data: v);
              },
            ),
            Text('取货时间:  $_selectedTime'),
            const SizedBox(height: 10,),
            ColorButton(onPressed: () async {
              DateTime? time = await DatePicker.showDateTimePicker(context, minTime: DateTime.now());

              if(time != null){
                setState(() {
                  _selectedTime = formatDate( time,
                      [yyyy, '-', mm, '-', dd, ' ',HH, ':', nn]);
                  receiptModel.saveCustomerInfo(type: 'date', data: _selectedTime);
                });
              }
            }, label: Text(_selectedTime.isEmpty ? '选择日期' : '重新选择日期')),
            const SizedBox(height: 15,),
            receiptModel.address.isEmpty ? Container() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('地址: ${receiptModel.address}'),
                Text('运费: \$${receiptModel.deliveryFee.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              children: [
                TextButton(onPressed: (){
                  showDialog(context: context, builder: (context){
                    return const AddressDialog();
                  });
                }, child: Text('${receiptModel.address.isEmpty ? '添加' : '修改'}送货信息')),
                const SizedBox(width: 10,),
                receiptModel.address.isEmpty ? Container() : TextButton(onPressed: (){
                  receiptModel.removeDelivery();
                }, child: const Text('取消配送')),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ));
  }
}

class AddressDialog extends StatefulWidget {
  const AddressDialog({Key? key}) : super(key: key);

  @override
  _AddressDialogState createState() => _AddressDialogState();
}

class _AddressDialogState extends State<AddressDialog> {
  final TextEditingController _address = TextEditingController();
  final TextEditingController _deliveryFee = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ReceiptModel receiptModel = Provider.of<ReceiptModel>(context, listen: false);

      _address.text = receiptModel.address;
      _deliveryFee.text = receiptModel.deliveryFee.toString();
    });


  }
  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${receiptModel.address.isEmpty ? '添加' : '更改'}地址', style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            AuthInput(
              icon: FontAwesomeIcons.home,
              label: '地址',
              controller: _address,
              margin: const EdgeInsets.only(bottom: 5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AuthInput(
                  icon: FontAwesomeIcons.dollarSign,
                  label: '运费',
                  keyboardType: TextInputType.number,
                  controller: _deliveryFee,
                  width: 150,
                ),
              ],
            ),
            ColorButton(onPressed: (){
              receiptModel.saveDeliveryInfo(_address.text, toDouble(_deliveryFee.text));
              Navigator.pop(context);
            }, label: Text(receiptModel.address.isEmpty ? '添加' : '更改')),
          ],
        ),
      ),
    );
  }
}
