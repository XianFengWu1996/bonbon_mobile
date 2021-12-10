import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReceiptDialog extends StatefulWidget {
  final ReceiptItem item;
  const ReceiptDialog({Key? key, required this.item}) : super(key: key);

  @override
  _ReceiptDialogState createState() => _ReceiptDialogState();
}

class _ReceiptDialogState extends State<ReceiptDialog> {
  final TextStyle _nameTextStyle = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    letterSpacing: 3
  );

  int _updateCount = 0;

  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child:SizedBox(
        height: 300,
        child: Column(
          children: [
            // close button
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: const Icon(FontAwesomeIcons.times, size: 30,)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  // item name and item unit
                  Row(
                    children: [
                      Text(widget.item.name, style: _nameTextStyle,),
                      Text('(${widget.item.unit})', style: _nameTextStyle),
                      const SizedBox(width: 20),
                    ],
                  ),
                  // item price
                  Row(
                    children: [
                      Text('\$${widget.item.unitPrice}',style: _nameTextStyle),
                    ],
                  ),
                  // item quantity and plus minus button
                  Container(
                    width: 225,
                    height: 65,
                    margin: const EdgeInsets.only(top: 20, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleButton(
                            icon: FontAwesomeIcons.minus,
                            onTap: (){
                              setState(() {
                                if((widget.item.quantity + _updateCount) > 0){
                                  _updateCount--;
                                }
                              });
                            },
                        ),
                        Text((widget.item.quantity + _updateCount).toString(), style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w400
                        ),),
                        CircleButton(icon: FontAwesomeIcons.plus,
                          onTap: (){
                            setState(() {
                              _updateCount++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // delete and update button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        receiptModel.deleteReceiptItem(widget.item);
                        Navigator.pop(context);
                      }, icon:const Icon(FontAwesomeIcons.trash), color: Colors.red, ),
                      ColorButton(onPressed: (){
                        if(widget.item.quantity + _updateCount > 0){
                          receiptModel.updateReceiptItem(widget.item, _updateCount);
                        } else {
                          receiptModel.deleteReceiptItem(widget.item);
                        }
                        Navigator.pop(context);
                      }, label: const Text('Update'), padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;
  const CircleButton({
      Key? key,
      required this.icon,
      required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      splashColor: Colors.lightBlue,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(icon, size: 30,),
      ),
    );
  }
}

