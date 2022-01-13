import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/review/customer_info.dart';
import 'package:bonbon_mobile/receipt/review/item_view_list.dart';
import 'package:bonbon_mobile/receipt/review/review_action_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptReview extends StatefulWidget {
  const ReceiptReview({ Key? key }) : super(key: key);

  @override
  _ReceiptPreviewState createState() => _ReceiptPreviewState();
}

class _ReceiptPreviewState extends State<ReceiptReview> {
  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);

    void previewOnPress(){
      Navigator.pushNamed(context, '/receipt/preview');
    }

    return Scaffold(
      appBar: const TransparentAppBar(
        navigatorPath: '/receipt/menu',
        appBarTitle: 'Review',
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              CustomerInfo(
                  receiptName: receiptModel.receiptName,
                  name: receiptModel.customerName,
                  phone: receiptModel.customerPhone,
                  date: receiptModel.pickupDate
              ),
              ItemViewList(receiptModel: receiptModel),
              ReviewActionArea(
                previewOnPress: previewOnPress,
                saveOnPress: (){
                  receiptModel.generateReceipt();
                },
                saveButtonText: receiptModel.id.isEmpty ? 'Save' : 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


