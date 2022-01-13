import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/review/item_view_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReceiptPreview extends StatelessWidget {
  const ReceiptPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 40,), //todo remove on production
                      Image.asset('assets/images/bonbon_logo.png', height: 100,),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 40, bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('客户名称：${receiptModel.customerName}', style: _itemTextStyle,),
                            Text('电话号码：$_formatNumber', style: _itemTextStyle,),
                            Text('取单日期： ${receiptModel.pickupDate}',style: _itemTextStyle,),
                            receiptModel.address.isEmpty ? Container()
                                : Text('送货地址:  ${receiptModel.address}',style: _itemTextStyle,),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                      ItemViewList(receiptModel: receiptModel),
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
    );
  }
}

