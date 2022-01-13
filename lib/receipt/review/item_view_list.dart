import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/review/merchant_item_dialog.dart';
import 'package:flutter/material.dart';

class ItemViewList extends StatelessWidget {
  final ReceiptModel receiptModel;

  const ItemViewList({
    Key? key,
    required this.receiptModel
  }) : super(key: key);

  final TextStyle _labelTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('商品名称', style: _labelTextStyle),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('数量', style: _labelTextStyle),
                  Text('单价', style: _labelTextStyle),
                  Text('总价', style: _labelTextStyle),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ListView.builder(
            shrinkWrap: true,
            itemCount: receiptModel.merchantCart.length,
            itemBuilder: (context, index){
              MerchantItem merchantItem = receiptModel.merchantCart[index];
              return InkWell(
                onTap: (){
                  showDialog(context: context, builder: (context){
                    return MerchantItemDialog(merchantItem: merchantItem);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(merchantItem.name, style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${merchantItem.quantity}盒'),
                          Text('\$${merchantItem.unitPrice}'),
                          Text('\$${merchantItem.totalPrice}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 15),
                Text('数量: ${receiptModel.cartQuantity}', style: _labelTextStyle,),
                receiptModel.deliveryFee > 0
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('运费:  \$${receiptModel.deliveryFee.toStringAsFixed(2)}', style: _labelTextStyle,),
                        Text('商品总价: \$${receiptModel.total.toStringAsFixed(2)}', style: _labelTextStyle,),
                        Text('订单总额: \$${(receiptModel.total + receiptModel.deliveryFee).toStringAsFixed(2)}', style: _labelTextStyle,),
                      ],
                    )
                    : Text('总额: \$${receiptModel.total.toStringAsFixed(2)}', style: _labelTextStyle,),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15,)
      ],
    );
  }
}
