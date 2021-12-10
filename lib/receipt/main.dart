import 'package:badges/badges.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/components/input.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/receipt_customer_dialog.dart';
import 'package:bonbon_mobile/receipt/receipt_dropdown.dart';
import 'package:bonbon_mobile/receipt/receipt_input.dart';
import 'package:bonbon_mobile/receipt/receipt_price_display.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:validators/sanitizers.dart';

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  @override
  Widget build(BuildContext context) {

    return Consumer<ReceiptModel>(builder: (context, receipt, child){
      return Scaffold(
        appBar: AppBar(
          title: const Text('Receipt'),
          actions: [
            TextButton(onPressed: (){
              receipt.clearReceiptCart();
            }, child: const Text('Clear', style: TextStyle(color: Colors.white),))
          ],
        ),

        floatingActionButton: SizedBox(
          height: 75,
          width: 75,
          child: FloatingActionButton(onPressed: (){
            Navigator.pushNamed(context, '/receipt/display');
          },
            child: Badge(
              badgeContent: Text(receipt.cartQuantity.toString(), style: const TextStyle(color: Colors.white),),
              badgeColor: Colors.lightBlue,
              child: const Icon(FontAwesomeIcons.receipt, size: 30,),
            ),
          ),
        ),
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView.builder(
              itemCount: item.length,
              itemBuilder: (BuildContext context, index){
                MenuItem menuItem = MenuItem().toObject(item[index]);
                List<String> _flavorList = [];
                List<String> _unitList = [];

                for (var element in menuItem.options) {
                  _flavorList.add(element.flavor!);

                  for (var element in element.option!) {
                    _unitList.add(element.unit.toString());
                  }
                }

                return MenuCard(
                  menuItem: menuItem,
                  flavorList: _flavorList.toSet().toList(),
                  unitList: _unitList.toSet().toList(),
                );
              }),
        ),
      );
    });


  }
}

class MenuCard extends StatefulWidget {
  final MenuItem menuItem;
  final List<String> flavorList;
  final List<String> unitList;

  const MenuCard({
    Key? key,
    required this.menuItem,
    required this.flavorList,
    required this.unitList,
  }) : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  final TextEditingController _amount = TextEditingController();
  String _flavorValue = '';
  num _flavorIndex = 0;
  num _optionValue = 0;
  num _optionIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _flavorValue = widget.flavorList[0];
    _optionValue = toInt(widget.unitList[0]);
  }

  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    double _width = MediaQuery.of(context).size.width;

    num _unitPrice = widget.menuItem.options[_flavorIndex as int].option![_optionIndex as int].price!;
    num _totalPrice =  ((widget.menuItem.options[_flavorIndex as int].option![_optionIndex as int].price! * toInt(_amount.text)));
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black38),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.menuItem.name!,
            style: const TextStyle(
                fontSize: 22.5, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReceiptDropdown(
                value: _flavorValue,
                width: _width * .35,
                dropdownList: widget.flavorList,
                onChanged: (value) {
                  setState(() {
                    _flavorValue = value!;
                    _flavorIndex = widget.menuItem.options.indexWhere(
                            (element) => element.flavor == value);
                  });
                },
              ),
              ReceiptDropdown(
                value: _optionValue.toString(),
                width: _width * .18,
                dropdownList: widget.unitList,
                onChanged: (value) {
                  setState(() {
                    _optionValue = toInt(value!);
                    _optionIndex = widget.menuItem.options[_flavorIndex as int].option!.indexWhere(
                            (element) => element.unit == toInt(value));
                  });
                },
              ),
              ReceiptInput(
                  controller: _amount,
                  onChanged: (value) { setState(() {});})
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReceiptPriceDisplay(
                  label: '单价',
                  price: '\$${_unitPrice.toStringAsFixed(2)}'),
              ReceiptPriceDisplay(
                  label: '总价',
                  price: '\$${_amount.text.isEmpty ? 0.00.toStringAsFixed(2) : _totalPrice.toStringAsFixed(2)}',
              ),
              ColorButton(
                  onPressed: () {
                    if(_amount.text.isNotEmpty){
                      // insert the receipt to the cart
                      receiptModel.addReceiptItem(ReceiptItem(
                          name: '$_flavorValue${widget.menuItem.name}',
                          unit: _optionValue,
                          quantity: toInt(_amount.text),
                          unitPrice: _unitPrice,
                          totalPrice: _totalPrice)
                      );

                      setState(() {
                        _flavorValue = widget.flavorList[0];
                        _optionValue = toInt(widget.unitList[0]);
                        _optionIndex = 0;
                        _flavorIndex = 0;
                        _amount.clear();
                        FocusScope.of(context).unfocus();
                      });
                    }
                  },
                  label: const Icon(FontAwesomeIcons.angleDoubleRight)),
            ],
          ),
        ],
      ),
    );
  }
}
