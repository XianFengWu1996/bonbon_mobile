import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/receipt_customer_dialog.dart';
import 'package:bonbon_mobile/receipt/receipt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptDisplay extends StatelessWidget {
  const ReceiptDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle _labelTextStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
    );

    const TextStyle _itemTextStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );

    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    String _phone = receiptModel.customerPhone;
    String _formatNumber = _phone.isNotEmpty ? '(${_phone.substring(0,3)})-${_phone.substring(3,6)}-${_phone.substring(6)}' : '';
    return GestureDetector(
      onDoubleTap: (){
        Navigator.pop(context);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right:25),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 40,), //todo remove on production
                        Image.asset('assets/images/bonbon_logo.png', height: 100,),
                        InkWell(
                          onTap: (){
                            showDialog(context: context, builder: (context) {
                              return const ReceiptCustomerDialog();
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(top: 40, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('客户名称：${receiptModel.customerName}', style: _itemTextStyle,),
                                Text('电话号码：$_formatNumber', style: _itemTextStyle,),
                                Text('取单日期： ${receiptModel.pickupDate}',style: _itemTextStyle,),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('商品名称', style: _labelTextStyle),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('数量', style: _labelTextStyle,),
                                  Text('单价', style: _labelTextStyle,),
                                  Text('总价', style: _labelTextStyle,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: receiptModel.receiptCart.length,
                            itemBuilder: (BuildContext context, index){
                              return InkWell(
                                onTap: (){
                                  showDialog(context: context, builder: (BuildContext context){
                                    ReceiptItem _item = receiptModel.receiptCart[index];
                                    return ReceiptDialog(item: _item);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${receiptModel.receiptCart[index].name} '
                                        '${receiptModel.receiptCart[index].unit == 0? '' : '(${receiptModel.receiptCart[index].unit.toString()})'}',
                                        style: _itemTextStyle),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${receiptModel.receiptCart[index].quantity.toString()}盒', style: _itemTextStyle,),
                                          Text('\$${receiptModel.receiptCart[index].unitPrice.toString()}', style: _itemTextStyle),
                                          Text('\$${receiptModel.receiptCart[index].totalPrice.toString()}', style: _itemTextStyle),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(height: 15),
                                Text('数量: ${receiptModel.cartQuantity}', style: _labelTextStyle,),
                                Text('总额: \$${receiptModel.total.toStringAsFixed(2)}', style: _labelTextStyle,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            height: 50,
                          ),
                          Text('所有产品都属于私人定制，做好以后不退不换。不接受口头预定，请以全款预付为准。', style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),),
                          Text('所有预定需先完成付款再进行制作，请确认订单信息和自取时间后再付款。如有食物过敏或饮食限制请提前告知。'
                              '订单完成后需当天取走，本店目前只提供Quincy附近配送服务(需配送费)，其他地区仅限自取，望周知。谢谢谅解 。'),
                          Text('最终解释权归BonBon Patisserie所有。'),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

