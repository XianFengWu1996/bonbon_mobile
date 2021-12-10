
import 'package:flutter/material.dart';

class ReceiptModel extends ChangeNotifier {
  final List<ReceiptItem> _receiptCart = [];
  double _total = 0;
  int _cartQuantity = 0;

  String _customerName = '';
  String _customerPhone = '';
  String _pickupDate = '';

  List<ReceiptItem> get receiptCart => _receiptCart;
  double get total => _total;
  int get cartQuantity  => _cartQuantity;

  String get customerName => _customerName;
  String get customerPhone => _customerPhone;
  String get pickupDate => _pickupDate;

  addReceiptItem(ReceiptItem item){
    for (var element in _receiptCart) {
      if(element.name == item.name){
        element.quantity += item.quantity;
        element.totalPrice += item.totalPrice;
        _total = _total + item.totalPrice;
        _cartQuantity += item.quantity as int;
        return;
      }
    }

    _receiptCart.add(item);
    _total = _total + item.totalPrice;
    _cartQuantity += item.quantity as int;
    notifyListeners();
  }

  updateReceiptItem(ReceiptItem item, num updateCount){
    for (var element in _receiptCart) {
      if (element.name == item.name) {
        element.quantity += updateCount;
        element.totalPrice += updateCount * element.unitPrice;
        _total += updateCount * element.unitPrice;
        _cartQuantity += updateCount as int;
      }
    }
    notifyListeners();
  }

  deleteReceiptItem(ReceiptItem item){
    _receiptCart.removeWhere((element) => element.name == item.name);

    // reset the total
    _total = 0;
    _cartQuantity = 0;

    // calculate the total
    for (var element in _receiptCart) {
      _total = _total + element.totalPrice;
      _cartQuantity += element.quantity as int;
    }
    notifyListeners();
  }

  clearReceiptCart(){
    _receiptCart.clear();
    _total = 0;
    _cartQuantity = 0;
    _customerName = '';
    _customerPhone = '';
    _pickupDate = '';
    notifyListeners();
  }

  saveCustomerInfo({
    required name, required phone, required pickupDate
}){
    _customerName = name;
    _customerPhone = phone;
    _pickupDate = pickupDate;

    notifyListeners();
  }
}


class ReceiptItem{
  final String name;
  final num unit;
  num quantity;
  final num unitPrice;
  num totalPrice;

  ReceiptItem({
    required this.name,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });
}

class MenuItem {
  String? name;
  List<Options> options;


  MenuItem({
    this.name,
    this.options = const [],
  });

  toObject(Map map){
    List<Options> _optionsList = [];

    for(var option in map['options']){
      _optionsList.add(Options().toObject(option));
    }

    return MenuItem(
        name: map['name'],
        options: _optionsList
    );
  }
}

class Options {
  final List<Option>? option;
  final String? flavor;
  
  Options({
    this.option,
    this.flavor,
  });

  toObject(Map map) {
    List<Option> _list = [];
    map['option'].forEach((el)
    {
      _list.add(Option().toObject(el));
    });

    return Options(
      flavor: map['flavor'],
      option: _list,
    );
  }
}

class Option {
  final num? unit;
  final num? price;

  Option({
    this.unit,
    this.price,
  });

  toObject(Map map) {
    return Option(
        unit: map['unit'],
        price: map['price']
    );
  }
}

List item = [
  {
    "name": "雪媚娘",
    "options": [
      {
        "flavor": '草莓',
        "option": [
          {
            "unit": 4,
            "price": 14,
          },
          {
            "unit": 6,
            "price": 18,
          },
        ]
      },
      {
        "flavor": '香蕉焦糖',
        "option": [
          {
            "unit": 4,
            "price": 14,
          },
          {
            "unit": 6,
            "price": 18,
          },
        ]
      },
      {
        "flavor": '奥利奥',
        "option": [
          {
            "unit": 4,
            "price": 14,
          },
          {
            "unit": 6,
            "price": 18,
          },
        ]
      },
      {
        "flavor": '芒果',
        "option": [
          {
            "unit": 4,
            "price": 14,
          },
          {
            "unit": 6,
            "price": 18,
          },
        ]
      },
    ]
  },
  {
    "name": "肉松小贝",
    "options": [
      {
        "flavor": '海苔',
        "option": [
          {
            "unit": 4,
            "price":14,
          },
          {
            "unit": 6,
            "price": 18,
          },
        ]
      },
      {
        "flavor": '咸蛋',
        "option": [
          {
            "unit": 4,
            "price":16,
          },
          {
            "unit": 6,
            "price": 22,
          },
        ]
      },
      {
        "flavor": '咸蛋麻薯',
        "option": [
          {
            "unit": 4,
            "price":18,
          },
          {
            "unit": 6,
            "price": 24,
          },
        ]
      },
      {
        "flavor": '紫米',
        "option": [
          {
            "unit": 4,
            "price":18,
          },
          {
            "unit": 6,
            "price": 24,
          },
        ]
      },
    ]
  },
  {
    "name": "半熟芝士",
    "options": [
      {
        "flavor": '奥利奥',
        "option": [
          {
            "unit": 4,
            "price": 15,
          },
        ]
      },
      {
        "flavor": '原味',
        "option": [
          {
            "unit": 4,
            "price": 15,
          },
        ]
      },
    ]
  },
  {
    "name": "桃酥",
    "options": [
      {
        "flavor": '宫廷',
        "option": [
          {
            "unit": 10,
            "price": 8,
          },
        ]
      },
    ]
  },
  {
    "name": "可可脆",
    "options": [
      {
        "flavor": '夏威夷',
        "option": [
          {
            "unit": 0,
            "price": 10,
          },
        ]
      },
    ]
  },
  {
    "name": "曲奇",
    "options": [
      {
        "flavor": '生巧',
        "option": [
          {
            "unit": 6,
            "price": 15,
          },
        ]
      },
    ]
  },

];