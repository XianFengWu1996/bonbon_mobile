import 'package:badges/badges.dart';
import 'package:bonbon_mobile/components/transparent_appbar.dart';
import 'package:bonbon_mobile/components/button.dart';
import 'package:bonbon_mobile/model/menu_model.dart';
import 'package:bonbon_mobile/model/receipt_model.dart';
import 'package:bonbon_mobile/receipt/menu/receipt_dropdown.dart';
import 'package:bonbon_mobile/receipt/menu/receipt_input.dart';
import 'package:bonbon_mobile/receipt/menu/receipt_price_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:validators/sanitizers.dart';

class ReceiptMenu extends StatefulWidget {
  const ReceiptMenu({Key? key}) : super(key: key);

  @override
  State<ReceiptMenu> createState() => _ReceiptMenuState();
}

class _ReceiptMenuState extends State<ReceiptMenu> {
  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    MenuModel menuModel = Provider.of<MenuModel>(context);

    return Scaffold(
      appBar: TransparentAppBar(
        appBarTitle: '菜单',
        onPressed: (){
          receiptModel.resetReceipt();
          Navigator.pushNamedAndRemoveUntil(context, '/receipt/home', (route) => false);
        },
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 25),
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/receipt/review');
              },
              child: Badge(
                badgeContent: Text(receiptModel.cartQuantity.toString(), style: const TextStyle(color: Colors.white),),
                badgeColor: Colors.lightBlueAccent,
                child: const Icon(FontAwesomeIcons.receipt, size: 28, color: Colors.red,),
                position: BadgePosition.topEnd(top: 2),
              ),
            ),
          ),
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: Colors.grey,
            ),
            child: PopupMenuButton(
              color: Colors.grey[500],
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Edit Menu",style: TextStyle(color: Colors.white),),
                ),
              ],
              onSelected: (item) => {
                Navigator.pushNamed(context, '/receipt/menu/edit')
              },
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: ListView.builder(
            shrinkWrap: true,
              itemCount: menuModel.menuList.length,
              itemBuilder: (BuildContext context, index){
                List<String> _flavorList = [];
                List<MenuItemOptions> _options = menuModel.menuList[index].options;

                // generate a list of flavor
                for (MenuItemOptions menuItemOption in _options) {
                  _flavorList.add(menuItemOption.flavor);
                }

                return MenuCard(
                  menuItem: menuModel.menuList[index],
                  flavorList: _flavorList.toSet().toList(),
                );
              }),
        ),
      ),
    );
  }
}

class MenuCard extends StatefulWidget {
  final MenuItem menuItem;
  final List<String> flavorList;

  const MenuCard({
    Key? key,
    required this.menuItem,
    required this.flavorList,
  }) : super(key: key);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  final TextEditingController _amount = TextEditingController();
  String _flavorValue = '';
  num _flavorIndex = 0;
  String _unitValue = '';
  final List<String> _unitList =[];
  num _optionIndex = 0;

  queryForUnitList(){
    _unitList.clear();

    for (var element in widget.menuItem.options) {
      if(element.flavor == _flavorValue){
        for (var element in element.unitOption) {
          _unitList.add(element.unit);
        }
      }
    }
    _unitValue = _unitList.isEmpty ? '' : _unitList.first;

  }

  @override
  void initState() {
    super.initState();
    _flavorValue = widget.flavorList[0];
    queryForUnitList();
  }

  @override
  Widget build(BuildContext context) {
    ReceiptModel receiptModel = Provider.of<ReceiptModel>(context);
    double _width = MediaQuery.of(context).size.width;

    num _unitPrice = widget.menuItem.options[_flavorIndex as int].unitOption[_optionIndex as int].price;
    num _totalPrice =  ((widget.menuItem.options[_flavorIndex as int].unitOption[_optionIndex as int].price * toInt(_amount.text)));

    void addMerchantItem(){
      if(_amount.text.isNotEmpty){
        // insert the receipt to the cart
        receiptModel.addMerchantItem(MerchantItem(
            name: '$_flavorValue${widget.menuItem.name} ($_unitValue)',
            unit: _unitValue,
            quantity: toInt(_amount.text),
            unitPrice: _unitPrice,
            totalPrice: _totalPrice)
        );

        setState(() {
          _flavorValue = widget.flavorList[0];
          _unitValue = _unitList[0];
          _optionIndex = 0;
          _flavorIndex = 0;
          _amount.clear();
          FocusScope.of(context).unfocus();
        });
      }
    }

    void onChangeFlavor(value){
      setState(() {
        _flavorValue = value!;
        _flavorIndex = widget.menuItem.options.indexWhere(
                (element) => element.flavor == value);
        queryForUnitList();
      });
    }

    void onChangeUnit(value){
      setState(() {
        _unitValue = value!;
        _optionIndex = widget.menuItem.options[_flavorIndex as int].unitOption.indexWhere(
                (element) => element.unit == value);
      });
    }

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
            widget.menuItem.name,
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
                dropdownList: widget.flavorList.toSet().toList(),
                onChanged: onChangeFlavor,
              ),
              ReceiptDropdown(
                value: _unitValue,
                width: _width * .18,
                dropdownList: _unitList.toSet().toList()..sort(),
                onChanged: onChangeUnit,
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
                  onPressed: addMerchantItem,
                  label: const Icon(FontAwesomeIcons.angleDoubleRight)),
            ],
          ),
        ],
      ),
    );
  }
}
