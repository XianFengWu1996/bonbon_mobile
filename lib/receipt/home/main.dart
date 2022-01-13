import 'package:bonbon_mobile/components/Dialogs/delete_confirmation_dialog.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ReceiptHome extends StatefulWidget {
  const ReceiptHome({Key? key}) : super(key: key);

  @override
  _ReceiptHomeState createState() => _ReceiptHomeState();
}

class _ReceiptHomeState extends State<ReceiptHome> {
  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    MenuModel menuModel = Provider.of<MenuModel>(context);
    return Scaffold(
      appBar: const TransparentAppBar(
        appBarTitle: '收据',
        navigatorPath: '/home',
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.plus),
        onPressed: () async {
          if(menuModel.menuList.isEmpty){
            await menuModel.getMenuList();
          }
          Navigator.pushNamed(context, '/receipt/menu');
          receiptModel.clearMerchantItemData();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: receiptModel.receipts.length,
                  itemBuilder: (context, index){
                    Receipt _receipt = receiptModel.receipts[index];
                    return Slidable(
                      endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context){
                                showDialog(context: context, builder: (context) {
                                  return DeleteConfirmationDialog(
                                    textToConfirm: _receipt.receiptName,
                                    onPressed: () {
                                      receiptModel.deleteReceipt(_receipt);
                                      Navigator.pop(context);
                                    },
                                  );
                                });
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]
                      ),
                      child: Card(
                        child: ListTile(
                          title: Text(_receipt.receiptName),
                          subtitle: Text(_receipt.customerName),
                          onTap: ()  async {
                           receiptModel.generateReceiptModel(_receipt);
                            if(menuModel.menuList.isEmpty){
                              await menuModel.getMenuList();
                            }
                            Navigator.pushNamed(context, '/receipt/menu');
                          },
                        )
                      ),
                    );
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
