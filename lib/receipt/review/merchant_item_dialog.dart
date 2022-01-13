import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

const TextStyle _nameTextStyle = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
    overflow: TextOverflow.ellipsis
);

class MerchantItemDialog extends StatefulWidget {
  final MerchantItem merchantItem;
  const MerchantItemDialog({Key? key, required this.merchantItem}) : super(key: key);

  @override
  _MerchantItemDialogState createState() => _MerchantItemDialogState();
}

class _MerchantItemDialogState extends State<MerchantItemDialog> {
  int _count = 0;

  @override
  void initState() {
    super.initState();
    _count = widget.merchantItem.quantity as int;
  }

  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);

    void addCount(){
      setState(() {
        _count++;
      });
    }

    void subtractCount(){
      setState(() {
        if(_count > 0){
          _count--;
        }
      });
    }

    void onDelete(){
      receiptModel.deleteMerchantItem(widget.merchantItem);
      Navigator.pop(context);
    }

    void onUpdate(){
      Navigator.pop(context);

      if(_count > 0){
        receiptModel.updateMerchantItem(widget.merchantItem, _count);
      } else {
        receiptModel.deleteMerchantItem(widget.merchantItem);
      }
    }

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child:SizedBox(
        height: 355,
        child: Column(
          children: [
            // close button
            Container(
              margin: const EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: const Icon(FontAwesomeIcons.times, size: 32,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Column(
                children: [
                  MerchantItemDialogTitle(
                      title: widget.merchantItem.name,
                      subtitle: widget.merchantItem.unitPrice.toString()
                  ),

                  // item quantity with plus minus button
                  ItemCountController(
                      count: _count.toString(),
                      addCount: addCount,
                      subtractCount: subtractCount
                  ),
                  // delete and update button
                  MerchantDialogActionButtons(
                      onDelete: onDelete,
                      onUpdate: onUpdate,
                      buttonText: widget.merchantItem.unitPrice * _count,
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

class MerchantItemDialogTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const MerchantItemDialogTitle({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // item name and item unit
        Row(
          children: [
            Flexible(child: Text(title, style: _nameTextStyle,)),
            const SizedBox(width: 20),
          ],
        ),
        // item price
        Row(
          children: [
            Text('\$$subtitle',style: _nameTextStyle),
          ],
        ),
      ],
    );
  }
}

class ItemCountController extends StatelessWidget {
  final String count;
  final void Function()? addCount;
  final void Function()? subtractCount;

  const ItemCountController({
    Key? key,
    required this.count,
    required this.addCount,
    required this.subtractCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 225,
      height: 65,
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: FontAwesomeIcons.minus,
            onTap: subtractCount,
          ),
          Text(count, style: const TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w400
          ),),
          CircleButton(icon: FontAwesomeIcons.plus,
            onTap: addCount,
          ),
        ],
      ),
    );
  }
}

class MerchantDialogActionButtons extends StatelessWidget {
  final void Function()? onDelete;
  final void Function()? onUpdate;
  final num buttonText;

  const MerchantDialogActionButtons({
    Key? key,
    required this.onDelete,
    required this.onUpdate,
    required this.buttonText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: onDelete, icon:const Icon(FontAwesomeIcons.trash), color: Colors.red, ),
        ColorButton(onPressed: onUpdate, label: Text('Update  \$$buttonText'), padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),),
      ],
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

